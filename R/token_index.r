#' Prepare a tokenIndex
#' 
#' Creates a tokenIndex data.table, that is required to use \link{find_nodes}. 
#' Accepts any data.frame given that the required columns (doc_id, token_id, parent, relation) are present.
#' 
#' The default column names can be changed with \link{tokenindex_columns}. Note, however, that you can only change
#' the special columns used in the functions for finding and annotating nodes (doc_id, token_id, relation, parent). If you want to use specific rules,
#' such as for quote or clause extraction, other specific columns might be required (e.g., POS, lemma). 
#' 
#' The data will be sorted by the doc_id and token_id columns (or aliases specified in \link{tokenindex_columns}).
#' Accordingly, it is recommended to use numeric token_id's. 
#' Some parsers return token_id's as numbers with a prefix (t_1, w_1), in which case sorting is inconvenient (t_15 > t_100).
#'
#' @param tokens 
#' @export
as_tokenindex <- function(tokens) {
  check_colnames(colnames(tokens))
  new_index = !is(tokens, 'tokenIndex')
  if (!is(tokens, 'data.table')) tokens = data.table::data.table(tokens)

  has_keys = data.table::key(tokens)
  if (!identical(has_keys, cname('doc_id','token_id'))) data.table::setkeyv(tokens, cname('doc_id','token_id'))
  has_indices = data.table::indices(tokens)
  doc_id__parent = paste(cname('doc_id','parent'), collapse='__')     ## paired doc_id__parent index
  if (!doc_id__parent %in% has_indices) data.table::setindexv(tokens, cname('doc_id','parent'))
  if (!cname('relation') %in% has_indices) data.table::setindexv(tokens, cname('relation')) ## relation index
  
  if (new_index) {
    check_tokens(tokens)
    data.table::setattr(tokens, name = 'class', c('tokenIndex', class(tokens)))
  }
  tokens
}

#' Specify the column names used in rsyntax.
#' 
#' Certain columns are required for applying (or writing) rsyntax rules. With the default column names, these are:
#' document id ("doc_id"), position or id of the token ("token_id"), 
#' the token id of the parent ("parent") and the dependency relation to this parent ("relation")
#'
#' With this function, you can specify aliases instead of these default names. Note, however, that this is only possible for
#' the special columns used in the functions for finding and annotating nodes (doc_id, token_id, relation, parent). If you want to use specific rules,
#' such as for quote or clause extraction, other specific columns might be required (e.g., POS, lemma). 
#' 
#'
#' @param doc_id document id
#' @param token_id position or id of the token
#' @param parent the token id of the parent
#' @param relation dependency relation of token to it's parent
#'
#' @export
tokenindex_columns <- function(doc_id='doc_id', token_id='token_id', parent='parent', relation='relation') {
  options(TOKENINDEX_doc_id = doc_id)
  options(TOKENINDEX_token_id = token_id)
  options(TOKENINDEX_parent = parent)
  options(TOKENINDEX_relation = relation)
}

## shorthand for getting column names from either the specified options or default (itself)
cname <- function(...) sapply(list(...), function(x) getOption(paste0('TOKENINDEX_', x), default = x))


check_colnames <- function(columns) {
  names = c('doc_id','token_id','parent','relation')
  missing = c()
  for (name in names) {
    if (!cname(name) %in% columns) missing = c(missing, sprintf('"%s" (%s)', cname(name), name))
  }
  if (length(missing) > 0) {
    stop(sprintf('Invalid token columns: %s.\nYou can either change the column names, or specify aliases using the tokenindex_columns() function',
                 paste(missing, collapse=', ')))
  }
}

check_tokens <- function(tokens) {
  if (anyDuplicated(tokens, by = c(cname('doc_id'),cname('token_id')))) stop(sprintf('Cannot have duplicate doc_id - token_id pairs. ("%s" - "%s")', cname('doc_id'), cname('token_id')))
  missing_parents = tokens[!tokens[,cname('doc_id','token_id'), with=F], on=cname('doc_id','token_id')]
  if (nrow(missing_parents) > 0) warning(sprintf('There are %s tokens with missing parents', nrow(missing_parents)))
}

