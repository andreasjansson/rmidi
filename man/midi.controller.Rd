\name{midi.controller}
\alias{midi.controller}
\title{Create Controller Events}
\description{
	This function provides a convenient way to create MIDI controller events.
}
\usage{
midi.controller(tick, param, value, channel = 0)
}
\arguments{
	\item{tick}{
		a vector of tick times at which the notes should begin
	}
	\item{param}{
		a vector of parameters.  Cyclic.
	}
	\item{value}{
		a vector of parameter values.  Cyclic.
	}
	\item{channel}{
		a vector of MIDI channels to send the notes to.  Cyclic.
	}
}
\details{
	midi.controller creates an RMidi matrix with tick rows, populated
	with parameters and values for controller events.

	All parameters except \code{tick} are cyclic, meaning that if you give
	shorter vectors than the tick vector length, these vectors will wrap
	around (independent of each other).
}
\value{
	Returns an rmidi matrix.
}
\seealso{
	\code{\link{midi.matrix}}
}
\examples{
## Sweep pan from left to right during one bar, 128 steps

ticks <- 0:127 * midi.get.ppq() * 4 / 128
pan.parameter <- 10 # for yamaha xg
pan <- 0:127
m <- midi.controller(ticks, pan.parameter, pan)

## play it!
midi.play(m)
}
