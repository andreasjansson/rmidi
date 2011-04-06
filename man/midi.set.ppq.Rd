\name{midi.set.ppq}
\alias{midi.set.ppq}
\title{Set the PPQ Value}
\description{
	Set the pulses per quarter of the MIDI sequencer.  The default is 96.
}
\usage{
midi.set.ppq(ppq)
}
\arguments{
	\item{ppq}{the pulses (ticks) per quarter note (crotchet)}
}
\value{
	Returns NULL
}
\seealso{
	\code{\link{midi.get.ppq}}
}
\examples{
## set the ppq to 192
midi.set.ppq(192)
}