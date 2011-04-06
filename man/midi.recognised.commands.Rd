\name{midi.recognised.commands}
\alias{midi.recognised.commands}
\alias{midi.cmd.noteon}
\alias{midi.cmd.noteoff}
\alias{midi.cmd.controller}
\title{Recognised MIDI Commands}
\description{
	These are the currently supported MIDI commands:
	\itemize{
		\item \code{midi.cmd.noteon}
		\item \code{midi.cmd.noteoff}
		\item \code{midi.cmd.controller}
	}

	rmidi commands are represented as integers which can be obtained by
	the variables \code{midi.cmd.XXX}.
}
\section{noteon and noteoff}{
	Simple note on and note off messages.  The easiest way to work with
	noteon and noteoff is to use the function \code{midi.note}.
}
\section{controller}{
	MIDI Controller messages.  The \code{midi.controller} function
	provides a convenient way of working with controller messages.
}
\seealso{
	\code{\link{midi.note}}, \code{\link{midi.controller}}
}