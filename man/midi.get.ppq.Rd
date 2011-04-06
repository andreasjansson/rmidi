\name{midi.get.ppq}
\alias{midi.get.ppq}
\title{Get the PPQ}
\description{
	Get the current ppq of the MIDI sequencer.
}
\usage{
midi.get.ppq()
}
\value{
	Returns the current pulses per quarter value.
}
\seealso{
	\code{\link{midi.set.ppq}}
}
\examples{
p <- midi.get.ppq()
}