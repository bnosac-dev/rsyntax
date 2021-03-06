% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/syntax_rules.r
\name{apply_queries}
\alias{apply_queries}
\title{Apply queries created with \link{tquery}}
\usage{
apply_queries(tokens, ..., as_chain = F, block = NULL, check = F,
  fill = T)
}
\arguments{
\item{tokens}{A tokenIndex data.table, or any data.frame coercible with \link{as_tokenindex}.}

\item{...}{tqueries, as created with \link{tquery}. Can also be a list with tquery functions. It is recommended to use named arguments/lists, to name the tqueries.}

\item{as_chain}{If TRUE, Nodes that have already been assigned assigned earlier in the chain will be ignored (see 'block' argument).}

\item{block}{Optionally, specify ids (doc_id - sentence - token_id triples) where find_nodes will stop (ignoring the id and recursive searches through the id). 
Can also be a data.table returned by (a previous) apply_queries, in which case all ids are blocked.}

\item{check}{If TRUE, return a warning if nodes occur in multiple patterns, which could indicate that the find_nodes query is not specific enough.}
}
\value{
A data.table in which each row is a node for which all conditions are satisfied, and each column is one of the linked nodes 
               (parents / children) with names as specified in the label argument.
}
\description{
Apply queries created with \link{tquery}
}
\examples{
## it's convenient to first prepare vectors with relevant words/pos-tags/relations
.SAY_VERBS = c("tell", "show","say", "speak") ## etc.
.QUOTE_RELS=  c("ccomp", "dep", "parataxis", "dobj", "nsubjpass", "advcl")
.SUBJECT_RELS = c('su', 'nsubj', 'agent', 'nmod:agent') 

quotes_direct = tquery(lemma = .SAY_VERBS,
                         children(label = 'source', p_rel = .SUBJECT_RELS),
                         children(label = 'quote', p_rel = .QUOTE_RELS))
quotes_direct ## print shows tquery

tokens = subset(tokens_corenlp, sentence == 1)

nodes = apply_queries(tokens, quotes_direct)
nodes
annotate(tokens, nodes, column = 'example')

}
