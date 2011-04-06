\name{midi.get.tempo}
\alias{midi.get.tempo}
\title{Get the Tempo}
\description{
	Get the current tempo of the MIDI sequencer.
}
\usage{
midi.get.tempo()
}
\value{
	Returns the current tempo in beats per minute.
}
\seealso{
	\code{\link{midi.set.tempo}}
}
\examples{
t <- midi.get.tempo()
}