\name{midi.read.file}
\alias{midi.read.file}
\title{Read a MIDI File}
\description{
	Parse a MIDI file and return an rmidi matrix.
}
\usage{
midi.read.file(filename)
}
\arguments{
	\item{filename}{the path to a .mid file}
}
\details{
	Reads and parses a \code{.mid} file and returns its contents in the
	form of an rmidi matrix.  The parser is limited to a subset of the commands
	that rmidi can currently handle (see
	\code{\link{midi.recognised.commands}} for the list	of commands).
}
\value{
	An rmidi matrix.
}
\note{
	midi.read.file is currently unable to handle midi files where the time
	is specified as real time, as opposed to tick time.  This may change
	in future versions of rmidi.
}
\author{
	The \code{midifile.c} and \code{midifile.h} files are written by Tim
	Thompson and Michael Czeiszperger, modified by James Allwright and the
	ABC MIDI project.
}
\seealso{
	\code{\link{midi.recognised.commands}}
}
\examples{
## read a midi file, reverse it, and play it back
## (without retaining velocities)

## read the file into mat
\dontrun{mat <- midi.read.file("/path/to/midifile.mid")

## reverse
mat <- mat[length(mat):1,]
mat[,midi.cols.tick] <- max(mat[,midi.cols.tick]) - mat[,midi.cols.tick]

## swap noteon and noteoff
mat[mat[,midi.cols.command] == midi.cmd.noteon, midi.cols.command] <-
    -midi.cmd.noteoff
mat[mat[,midi.cols.command] == midi.cmd.noteoff, midi.cols.command] <-
    -midi.cmd.noteon
mat[mat[,midi.cols.command] == -midi.cmd.noteon, midi.cols.command] <-
    midi.cmd.noteon
mat[mat[,midi.cols.command] == -midi.cmd.noteoff, midi.cols.command] <-
    midi.cmd.noteoff

## set all velocities to 127
mat[,midi.cols.byte2] <- 127

## play it!
midi.play(mat)}
}
