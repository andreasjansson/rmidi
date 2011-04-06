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

#ifndef RMIDI_H__
#define RMIDI_H__

#ifdef HAS_CONFIG_H
#include "config.h"
#endif

#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>
#include <R_ext/Rdynload.h>

#define RMIDI_VERSION 0.1

#define RMIDI_CLIENT_NAME "rmidi"
#define RMIDI_PORT_NAME RMIDI_CLIENT_NAME
#define DEFAULT_PPQ 96
#define DEFAULT_TEMPO 120.0

#define CMD_NOTEON 1
#define CMD_NOTEOFF 2
#define CMD_CONTROLLER 3
#define CMD_PITCHBEND 4

#define NCOL 5
#define COL_TICK 0
#define COL_COMMAND 1
#define COL_CHANNEL 2
#define COL_BYTE1 3
#define COL_BYTE2 4

#endif
