\name{midi.note}
\alias{midi.note}
\title{Create RMidi Notes}
\description{
	This function provides a convenient way to create noteon and noteoff
	events.
}
\usage{
midi.note(tick, duration, pitch, velocity = 127, channel = 0, noteoff.velocity = 0)
}
\arguments{
	\item{tick}{
		a vector of tick times at which the notes should begin
	}
	\item{duration}{
		a vector of durations of the notes (differences in tick time between
		noteon and noteoff events).  Cyclic.
	}
	\item{pitch}{
		a vector of pitches.  Cyclic.
	}
	\item{velocity}{
		a vector of velocities for the noteon events.  Cyclic.
	}
	\item{channel}{
		a vector of MIDI channels to send the notes to.  Cyclic.
	}
	\item{noteoff.velocity}{
		a vector of velocities for the noteoff events.  Cyclic.
	}
}
\details{
	midi.note creates an rmidi matrix with tick * 2 rows, where the first
	half consists of noteon events and the second half noteoff events.

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
## create two whole tone runs, one based on crotchets and one
## based on dotted crotchets, with varying velocities

crotchet.time <- midi.get.ppq()
dotted.crotchet.time <- midi.get.ppq() * 1.5

r1 <- midi.note(0:23 * crotchet.time,
                crotchet.time,
                0:23 * 2 + 60,
                c(100, 120, 80, 110),
                0)

r2 <- midi.note(0:15 * dotted.crotchet.time,
                dotted.crotchet.time,
                0:15 * 2 + 48,
                c(120, 80, 100),
                1)

## play it!
midi.play(rbind(r1, r2))
}
