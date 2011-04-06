\name{midi.set.tempo}
\alias{midi.set.tempo}
\title{Set the Tempo}
\description{
	Set the tempo of the MIDI sequencer.  The default tempo is 120 bpm.
}
\usage{
midi.set.tempo(bpm)
}
\arguments{
	\item{bpm}{the tempo in beats per minute, positive real number.}
}
\value{
	Returns NULL
}
\seealso{
	\code{\link{midi.get.tempo}}
}
\examples{
## set the tempo to 120 bpm
midi.set.tempo(120)
}