# autoconf script

AC_INIT(rmidi, 0.1, andreas.s.t.jansson@gmail.com)

AC_CHECK_HEADERS([alsa/asoundlib.h])

AC_CONFIG_SRCDIR([src/rmidi.c])
AC_CONFIG_HEADER([src/config.h])

# find R home and set CC/CFLAGS
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi
RBIN="${R_HOME}/bin/R"
CC=`"${RBIN}" CMD config CC`;
CFLAGS=`"${RBIN}" CMD config CFLAGS`

LIBS="${PKG_LIBS}"

CFLAGS="-DHAS_CONFIG_H=1 ${CFLAGS}"

AC_PROG_CC

AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
