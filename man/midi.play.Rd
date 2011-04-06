\name{midi.play}
\alias{midi.play}
\title{Play a MIDI Sequence}
\description{
	Output an rmidi matrix as MIDI data using the ALSA MIDI interface.
}
\usage{
midi.play(mat)
}
\arguments{
	\item{mat}{a five column rmidi matrix.}
}
\details{
	The matrix is processed and sent to the ALSA MIDI sequencer interface,
	which produces MIDI data.  The MIDI data is outputted using the ALSA
	subscription mechanism and can be routed using Jack (see the
	documentation for the qjackctl program).

	To play multiple matrices at the same time, simply use \code{rbind} to
	merge them into one matrix.
}
\value{
	Returns NULL.
}
\note{
	There is currently no way to stop midi.play while it is being
	played.  One crude workaround if things need to stop playing is simply
	to disconnect the rmidi output from whatever is receiving it as input
	in Jack.

	midi.play is synchronous, which in effect means that while MIDI is
	being played the user has no control over R.
}
\seealso{
	\code{\link{midi.matrix}}, \code{\link{rbind}}
}
\examples{
## play a simple chromatic scale
m <- midi.note(0:11 * midi.get.ppq(), midi.get.ppq(), 60:71)
midi.play(m)
}