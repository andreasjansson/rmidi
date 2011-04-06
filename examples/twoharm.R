##
## TwoHarm - RMidi example music
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
##
## This piece doesn't really show off any off the more interesting
## RMidi features, like scales, but serves as a simple example of
## how to get sound out of R. It's a short two-part piece in A that
## I wrote a year ago. It really needs a third upper harmony, but
## I just haven't been able to figure one out. So therefore I'm
## GPL'ing it, in the hopes that someone else might. If you do, give
## me a shout!

ppq <- midi.get.ppq()
midi.set.tempo(52)

# attach a bunch of notes to make it simpler to write
attach(list(Cb = midi.notes.cb,
            C = midi.notes.c,
            Cs = midi.notes.cs,
            Db = midi.notes.db,
            D = midi.notes.d,
            Ds = midi.notes.ds,
            Eb = midi.notes.eb,
            E = midi.notes.e,
            Es = midi.notes.es,
            Fb = midi.notes.fb,
            # F = FALSE is in .GlobalEnv
            FF =  midi.notes.f,
            Fs = midi.notes.fs,
            Gb = midi.notes.gb,
            G = midi.notes.g,
            Gs = midi.notes.gs,
            Ab = midi.notes.ab,
            A = midi.notes.a,
            As = midi.notes.as,
            Bb = midi.notes.bb,
            B = midi.notes.b,
            Bs = midi.notes.bs), name="midi.notes")


pitch.upper <- c(FF, E, Gs, A,
                 B, E, B, Cs + 12, A,
                 Fs, A, B, FF, E,
                 E, Cs,
                 Cs, E, Fs, B - 12, A - 12,
                 Cs, E, Fs, G, Fs,
                 Fs, C + 12, B, A, B,
                 Gs, FF, Gs, B, E + 12,
                 E + 12, Cs + 12, A, Bb, A,
                 B, Gs, FF, E, Gs,
                 A)
dur.upper <- c(2, 2, 2, 2,
               2, 1, 1, 2, 2,
               2, 1, 1, 2, 2,
               6, 2,
               2, 1, 1, 2, 2,
               2, 1, 1, 2, 2,
               2, 1, 1, 2, 2,
               4, 1, 1, 1, 1,
               2, 1, 1, 2, 2,
               2, 1, 1, 2, 2,
               8) / 2

pitch.lower <- c(D + 12, Cs + 12, B, A,
                 Gs, A, Cs + 12,
                 D + 12, B, Gs,
                 A, FF, E,
                 A, D + 12,
                 E + 12, Cs + 12, D + 12, As, Fs,
                 B, B + 12, Ds + 12, Fs + 12,
                 E + 12, Gs + 12, B + 12, D + 24,
                 A + 12, G + 12, Fs + 12,
                 FF + 12, D + 12, E + 12, B,
                 A)

dur.lower <- c(2, 2, 2, 2,
               4, 2, 2,
               4, 2, 2,
               2, 2, 4,
               4, 4,
               2, 1, 1, 2, 2,
               2, 2, 2, 2,
               1, 1, 1, 5,
               4, 2, 2,
               2, 2, 2, 2,
               8) / 2

tick.upper <- cumsum(c(0, dur.upper[0:(length(dur.upper) - 1)]))
notes.upper <- midi.note(tick.upper * ppq, dur.upper * ppq, pitch.upper + 12 * 5, channel=0)

tick.lower <- cumsum(c(0, dur.lower[0:(length(dur.lower) - 1)]))
notes.lower <- midi.note(tick.lower * ppq, dur.lower * ppq - 4, pitch.lower + 12 * 4, channel=1)

midi.play(rbind(notes.upper, notes.lower))

detach("midi.notes")
F <- FALSE
