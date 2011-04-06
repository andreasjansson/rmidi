##
## rmidi - R/MIDI interface
## Copyright (C) 2011 Andreas Jansson
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
##


midi.ncol <- 5
midi.cols.tick <- 1
midi.cols.command <- 2
midi.cols.channel <- 3
midi.cols.byte1 <- 4
midi.cols.byte2 <- 5

midi.cmd.noteon <- 1
midi.cmd.noteoff <- 2
midi.cmd.controller <- 3
#midi.cmd.pitchbend <- 4 # too be implemented next
midi.recognised.commands <- c(midi.cmd.noteon, midi.cmd.noteoff,
                              midi.cmd.controller)

midi.set.tempo <- function(bpm)
{
  if(bpm < 1)
    stop("Tempo must be positive.")

  .C("midi_set_tempo", as.numeric(bpm), PACKAGE="rmidi")
  invisible()
}

midi.set.ppq <- function(ppq)
{
  if(ppq < 1)
    stop("PPQ must be a positive integer")

  .C("midi_set_ppq", as.integer(ppq), PACKAGE="rmidi")
  invisible()
}

midi.get.tempo <- function()
{
  return(.C("midi_get_tempo", bpm = 0, PACKAGE="rmidi")$bpm)
}

midi.get.ppq <- function()
{
  return(.C("midi_get_ppq", ppq = as.integer(0), PACKAGE="rmidi")$ppq)
}

midi.play <- function(mat)
{
  m <- mat
  storage.mode(m) <- "integer"

  if(any(mat[,midi.cols.tick] < 0)) # TODO: check upper bound as well
    stop("Tick time must be a positive number")

  if(length(match(m[,midi.cols.command],midi.recognised.commands, nomatch=TRUE)) < nrow(m))
    stop("The matrix contains unrecognised commands")

  data.cols <- c(midi.cols.channel,
                 midi.cols.byte1,
                 midi.cols.byte2)
  if(sum(m[,data.cols] < 0 | m[,data.cols] > 127))
    stop("Data values must be in the range (0, 127).")

  # not sure if this helps or not, but it feels right
  m <- m[order(m[,1]),]

  # if the matrix has only one command, nrow(m) will now be NULL
  rows <- nrow(m)
  if(is.null(rows))
    rows <- 1

  .Call("midi_play", m, as.integer(rows), PACKAGE="rmidi")
  invisible()
}

midi.note <- function(tick, duration, pitch, velocity = 127, channel = 0,
                      noteoff.velocity = 0)
{
  rows <- length(tick)

  m <- midi.matrix(rows * 2)

  m[1:rows,
    c(midi.cols.tick,
      midi.cols.command,
      midi.cols.channel,
      midi.cols.byte1,
      midi.cols.byte2)] <-
        c(tick,
          rep(midi.cmd.noteon, length.out = rows),
          rep(channel, length.out = rows),
          rep(pitch, length.out = rows),
          rep(velocity, length.out = rows))

  m[(rows + 1):(rows * 2),
    c(midi.cols.tick,
      midi.cols.command,
      midi.cols.channel,
      midi.cols.byte1,
      midi.cols.byte2)] <-
        c(tick + rep(duration, length.out = rows),
          rep(midi.cmd.noteoff, length.out = rows),
          rep(channel, length.out = rows),
          rep(pitch, length.out = rows),
          rep(noteoff.velocity, length.out = rows))

  return(m)
}

midi.controller <- function(tick, param, value, channel = 0)
{
  rows <- length(tick)

  m <- midi.matrix(rows)

 m[1:rows,
    c(midi.cols.tick,
      midi.cols.command,
      midi.cols.channel,
      midi.cols.byte1,
      midi.cols.byte2)] <-
        c(tick,
          rep(midi.cmd.controller, length.out = rows),
          rep(channel, length.out = rows),
          rep(param, length.out = rows),
          rep(value, length.out = rows))

  return(m)
}

midi.matrix <- function(rows = 1)
{
  return(midi.colname(matrix(0, rows, midi.ncol)))
}

midi.colname <- function(mat)
{
  cols <- character(5)
  cols[midi.cols.tick] <- "tick"
  cols[midi.cols.command] <- "command"
  cols[midi.cols.channel] <- "channel"
  cols[midi.cols.byte1] <- "byte1"
  cols[midi.cols.byte2] <- "byte2"

  colnames(mat) <- cols
  return(mat)
}

midi.scale <- function(pitch, scale = midi.scales.chromatic)
{
  scale <- sort(unique(scale %% 12))

  # 11 (rounded up) octaves in 127 notes, 12 notes in a scale
  scale <- rep(scale, 11) + rep(0:10 * 12, each=length(scale))
  scale <- scale[scale >= 0 & scale <= 127]
  index <- findInterval(pitch, scale)
  index[index == 0] <- 1
  pitch <- scale[index]

  return(pitch)
}

midi.read.file <- function(filename)
{
  filename <- path.expand(filename)
  m <- .Call("midi_read_file", as.character(filename), PACKAGE="rmidi")
  return(midi.colname(m))
}
