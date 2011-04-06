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

#include "rmidi.h"

#ifdef HAVE_ALSA_ASOUNDLIB_H
#include <alsa/asoundlib.h>

static snd_seq_t *seq_handle;
static int port_out_id;
static int queue_id;
static int ppq;
static double bpm;

int value_at(SEXP *matrix, int row, int col, int nrow);
void midi_set_tempo(double *beats_per_minute);
void midi_set_ppq(int *pulses_per_quarter);
void midi_set_tempo_ppq();
double midi_get_tempo(double *bpm_ret);
int midi_get_ppq(long *ppq_ret);
SEXP midi_play(SEXP matrix, SEXP nrows_sexp);
void midi_stop();
int midi_cmd_noteon(int *ret);
int midi_cmd_noteoff(int *ret);
SEXP midi_read_file(SEXP filename_sexp);

// from read.c
int read_file(FILE *file, int **mat_ret, int *nrow_ret);

void R_init_rmidi(DllInfo *info)
{
  int err;

  if((err = snd_seq_open(&seq_handle,"default", SND_SEQ_OPEN_OUTPUT, 0)) < 0) {
    error("Error opening ALSA sequencer: %s\n", snd_strerror(err));
  }

  if((err = snd_seq_set_client_name(seq_handle, RMIDI_CLIENT_NAME)) < 0) {
    error("Failed to name client: %s\n", snd_strerror(err));
  }

  if((port_out_id = snd_seq_create_simple_port(
				seq_handle, RMIDI_PORT_NAME,
				SND_SEQ_PORT_CAP_READ|SND_SEQ_PORT_CAP_SUBS_READ,
				SND_SEQ_PORT_TYPE_MIDI_GM)) < 0) {
    error("Failed to create port: %s\n", snd_strerror(port_out_id));
  }

  // get queue for sequencer
  queue_id = snd_seq_alloc_queue(seq_handle);

  // set the output queue buffer size
  snd_seq_set_client_pool_output(seq_handle, 100);

	bpm = DEFAULT_TEMPO;
	ppq = DEFAULT_PPQ;
	midi_set_tempo(&bpm);
	midi_set_ppq(&ppq);
}

void R_unload_rmidi(DllInfo *info)
{
	snd_seq_close(seq_handle);
}

/**
 * Called using .C()
 */
void midi_set_tempo(double *beats_per_minute)
{
	bpm = *beats_per_minute;
	midi_set_tempo_ppq();
}

void midi_set_ppq(int *pulses_per_quarter)
{
	ppq = *pulses_per_quarter;
	midi_set_tempo_ppq();
}

void midi_set_tempo_ppq()
{
  snd_seq_queue_tempo_t *queue_tempo;
  snd_seq_queue_tempo_malloc(&queue_tempo);

  // microseconds per tick.
  int tempo = (int)(6e7 / (bpm * (double)ppq) *
		(double)ppq);

  snd_seq_queue_tempo_set_tempo(queue_tempo, tempo);
  snd_seq_queue_tempo_set_ppq(queue_tempo, ppq);
  snd_seq_set_queue_tempo(seq_handle, queue_id, queue_tempo);
  snd_seq_queue_tempo_free(queue_tempo);
}

double midi_get_tempo(double *bpm_ret)
{
	return *bpm_ret = bpm;
}

int midi_get_ppq(long *ppq_ret)
{
	return *ppq_ret = ppq;
}

/**
 * Called using .Call()
 */
SEXP midi_play(SEXP matrix, SEXP nrows_sexp)
{
	int i;
	int nrows = INTEGER(nrows_sexp)[0];
	snd_seq_event_t ev;
	int tick, command, channel, byte1, byte2;

	// start queue

  snd_seq_start_queue(seq_handle, queue_id, NULL);

  snd_seq_drain_output(seq_handle);

	for(i = 0; i < nrows; i ++) {
		tick = value_at(&matrix, i, COL_TICK, nrows);
		command = value_at(&matrix, i, COL_COMMAND, nrows);
		channel = value_at(&matrix, i, COL_CHANNEL, nrows);
		byte1 = value_at(&matrix, i, COL_BYTE1, nrows);
		byte2 = value_at(&matrix, i, COL_BYTE2, nrows);

		snd_seq_ev_clear(&ev);

		switch(command) {
		case CMD_NOTEON:
			snd_seq_ev_set_noteon(&ev, channel, byte1, byte2);
			break;
		case CMD_NOTEOFF:
			snd_seq_ev_set_noteoff(&ev, channel, byte1, byte2);
			break;
		case CMD_CONTROLLER:
			snd_seq_ev_set_controller(&ev, channel, byte1, byte2);
			break;
		default:
			break;
		}

		snd_seq_ev_schedule_tick(&ev, queue_id, 0, tick);
		snd_seq_ev_set_source(&ev, port_out_id);
		snd_seq_ev_set_subs(&ev);
		snd_seq_event_output_direct(seq_handle, &ev);
	}

	return R_NilValue;	
}

/**
 * midi_continue does not make sense. No changes you make will have
 * any effect since the notes are already scheduled. In R, selecting
 * a subset is very easy.
 */
void midi_stop()
{
	snd_seq_stop_queue(seq_handle, queue_id, NULL);
}

int midi_cmd_noteon(int *ret)
{
	return *ret = CMD_NOTEON;
}

int midi_cmd_noteoff(int *ret)
{
	return *ret = CMD_NOTEOFF;
}

int value_at(SEXP *matrix, int row, int col, int nrow)
{
	return INTEGER(*matrix)[row + col * nrow];
}

SEXP midi_read_file(SEXP filename_sexp)
{
	// raw mat is transposed, indexed by x + y * NCOL
	int *raw_mat, nrow;
	SEXP mat;
	FILE *file;
	int has_error = 0;

	if(!(file = fopen(CHAR(STRING_ELT(filename_sexp, 0)), "r")))
		error("Failed to open file (\"%s\").",CHAR(STRING_ELT(filename_sexp, 0)));
	if(read_file(file, &raw_mat, &nrow) < 0)
		has_error = 1;
	fclose(file);

	if(has_error)
		return R_NilValue;

	PROTECT(mat = allocMatrix(INTSXP, nrow, NCOL));
	int y, x;
	for(y = 0; y < nrow; y ++) {
		for(x = 0; x < NCOL; x ++) {
			INTEGER(mat)[y + x * nrow] = raw_mat[x + y * NCOL];

			//			Rprintf("%5d ", raw_mat[x + y * NCOL]);
			//			Rprintf("%5d ", INTEGER(mat)[y + x * nrow]);
		}
		//		Rprintf("\n");
	}
	free(raw_mat);

	UNPROTECT(1);

	return mat;
}

#endif
