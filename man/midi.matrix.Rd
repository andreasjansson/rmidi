\name{midi.matrix}
\alias{midi.matrix}
\alias{midi.cols.tick}
\alias{midi.cols.command}
\alias{midi.cols.channel}
\alias{midi.cols.byte1}
\alias{midi.cols.byte2}
\alias{midi.ncol}
\title{Create a Zero RMidi Matrix}
\description{
	This function returns an rmidi matrix with all cells having the value
	0.	rmidi matrices have the
	following columns: tick, command, channel, byte1, byte2.
}
\usage{
midi.matrix(rows = 1)
}
\arguments{
	\item{rows}{the number of rows in the matrix}
}
\details{
	rmidi matrices are matrices of integers. Below is an explanation of
	the semantics of the different columns.

	The \emph{tick} column specifies the tick time at which the MIDI event is to
	occur. Note that tick times start from 0.

	The \emph{command} column specifies the MIDI command the event corresponds
	to. See \code{\link{midi.recognised.commands}} for a list of the
	currently available commands.

	The \emph{channel} column specifies the MIDI channel to be used. Note
	that the channel numbering starts from 0.

	The \emph{byte1} and \emph{byte2} columns have different meaning
	depending on the command column. For example, in a noteon command, the
	byte1 column is the pitch and byte2 is the velocity. Both columns have
	ranges (0, 127).

	To avoid having to remember the order of the columns rmidi defines the
	variables \code{midi.cols.tick}, \code{midi.cols.command},
	\code{midi.cols.channel}, \code{midi.cols.byte1} and
	\code{midi.cols.byte2}.
}
\value{
	Returns a zero rmidi matrix.
}
\seealso{
	\code{\link{midi.recognised.commands}}, \code{\link{midi.get.ppq}}
}
\examples{
## create a c4 minim with velocity 100, starting at time 0, on channel 3
## (obviously a lot easier to do with midi.note)

m <- midi.matrix(2)
c4 <- midi.notes.c + 12 * 5

m[1, midi.cols.tick] <- 0
m[1, midi.cols.channel] <- 3
m[1, midi.cols.command] <- midi.cmd.noteon
m[1, midi.cols.byte1] <- c4
m[1, midi.cols.byte2] <- 100

m[2, midi.cols.tick] <- midi.get.ppq() * 2
m[2, midi.cols.channel] <- 3
m[2, midi.cols.command] <- midi.cmd.noteoff
m[2, midi.cols.byte1] <- c4
m[2, midi.cols.byte2] <- 0
}