\name{midi.colname}
\alias{midi.colname}
\title{Set the Column Names of an RMidi Matrix}
\description{
	Apply meaningful column names (\code{tick}, \code{command}, etc.) to an rmidi matrix.
}
\usage{
midi.colname(mat)
}
\arguments{
	\item{mat}{An rmidi matrix}
}
\value{
	Returns a copy of the input matrix with applied colnames.
}
\note{
	This function is called internally by convenience functions such as
	midi.note, so there is no need to call \code{midi.colname} on such
	matrices.
}
\examples{
## apply colnames to a user-initialised matrix
m <- matrix(0, 3, 5)
m <- midi.colname(m)
}