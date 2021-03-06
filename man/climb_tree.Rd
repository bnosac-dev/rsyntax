% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/applied_reshape.r
\name{climb_tree}
\alias{climb_tree}
\title{Have a node adopt its parent's position}
\usage{
climb_tree(.tokens, tq, unpack = T, take_fill = T, give_fill = T,
  only_new = "relation", depth = Inf)
}
\arguments{
\item{.tokens}{A tokenIndex}

\item{tq}{A tquery. Needs to have a node labeled "origin" that has a parent labeled "target"}

\item{unpack}{If TRUE, create separate branches for the parent and the node that inherits the parent position}

\item{take_fill}{If TRUE, give the node that will inherit the parent position a copy of the parent children (but only if it does not already have children with this relation; see only_new)}

\item{give_fill}{If TRUE, copy the children of the node that will inherit the parent position to the parent (but only if it does not already have children with this relation; see only_new)}

\item{only_new}{A character vector giving one or multiple column names that need to be unique for take_fill and give_fill}

\item{depth}{Certain relations can be recursively nested (e.g. conjunction within conjunction). Depth specifies how far to inherit (by default infinite)}
}
\description{
This function is mainly used for removing conjunctions from dependency trees.
}
\details{
given a tquery that identfies a node labeled "origin", that has a parent labeled "target", 
recursively have child adopt the parent's position (parent and relation column)
and adopt parents fill nodes. only_new restricts adding fill nodes to relations that child
does not already have. This seems to be a good heuristic for dealing with argument drop
}
