/*
    rmidi - R/MIDI interface
    Copyright (C) 2011 Andreas Jansson
   
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
   
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
   
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdio.h>
#include "midifile.h"
#include "rmidi.h"

#define INITIAL_MAT_SIZE 8
#define MAT_REALLOC_FACTOR 2

static FILE *f = 0;
static int has_error = 0;
static int *mat = 0;
static int nrow = 0;
static int mat_size;

int readchar(void);
int noteon_handler(int channel, int pitch, int velocity);
int noteoff_handler(int channel, int pitch, int velocity);
int tempo_handler(long mpqn);
int header_handler(int format, int ntracks, int division);
int error_handler(char *s);
int read_file(FILE *file, int **mat_ret, int *nrow_ret);
void add_row();

// from rmidi.c
void midi_set_tempo(double *beats_per_minute);
void midi_set_ppq(int *pulses_per_quarter);

int readchar(void)
{
	return getc(f);
}

int header_handler(int format, int ntracks, int division)
{
	if(division & 0x8000) {
		// to be implemented... maybe
	}
	else {
		division = division & 0x7FFF;
		midi_set_ppq(&division);
	}

	return 0;
}

int tempo_handler(long mpqn)
{
	int microseconds_per_minute = 60000000;
	double bpm = (double)microseconds_per_minute / (double)mpqn;

	midi_set_tempo(&bpm);

	return 0;
}

int noteon_handler(int channel, int pitch, int velocity)
{
	add_row();
	mat[COL_TICK + (nrow - 1) * NCOL] = Mf_currtime;

	if(velocity > 0)
		mat[COL_COMMAND + (nrow - 1) * NCOL] = CMD_NOTEON;
	else
		mat[COL_COMMAND + (nrow - 1) * NCOL] = CMD_NOTEOFF;
		
	mat[COL_CHANNEL + (nrow - 1) * NCOL] = channel;
	mat[COL_BYTE1 + (nrow - 1) * NCOL] = pitch;
	mat[COL_BYTE2 + (nrow - 1) * NCOL] = velocity;

	return 0;
}

int noteoff_handler(int channel, int pitch, int velocity)
{
	add_row();
	mat[COL_TICK + (nrow - 1) * NCOL] = Mf_currtime;
	mat[COL_CHANNEL + (nrow - 1) * NCOL] = channel;
	mat[COL_COMMAND + (nrow - 1) * NCOL] = CMD_NOTEOFF;
	mat[COL_BYTE1 + (nrow - 1) * NCOL] = pitch;
	mat[COL_BYTE2 + (nrow - 1) * NCOL] = velocity;

	return 0;
}

int error_handler(char *s)
{
	has_error = 0;
	return 0;
}

int read_file(FILE *file, int **mat_ret, int *nrow_ret)
{
	f = file;
	mat = 0;
	nrow = 0;

	Mf_getc = readchar;
	Mf_noteon = noteon_handler;
	Mf_noteoff = noteoff_handler;
	Mf_error = error_handler;
	Mf_header = header_handler;
	Mf_tempo = tempo_handler;
	mfread();

	if(has_error) {
		free(mat);
		return -1;
	}

	*mat_ret = mat;

	*nrow_ret = nrow;

	return 0;
}
 
void add_row()
{
	if(nrow == 0) {
		mat = malloc(sizeof(int) * NCOL * (mat_size = INITIAL_MAT_SIZE));
	}
	else if(nrow == mat_size) {
		mat = realloc(mat, sizeof(int) * NCOL *
									(mat_size = mat_size * MAT_REALLOC_FACTOR));
	}

	++ nrow;
}
