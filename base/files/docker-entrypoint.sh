#!/bin/bash

set -euo pipefail

# Check if the the user has invoked the image with flags.
# eg. "-classpath /usr/bin" will call "jshell -classpath /usr/bin"
if [[ -z $1 ]] || [[ ${1:0:1} == '-' ]] ; then
  exec jshell "$@"
else
  # They may be looking for a subcommand, like "jshell --help".
  subcommands=$(jshell --help 2>&1 | grep '    -' | awk '{$1=$1};1' | awk '{print $1}')

  # If we _did_ get a subcommand, pass it to jshell
  for subcommand in $subcommands; do
      if [[ $1 == $subcommand ]]; then
        exec jshell "$@"
      fi
  done
fi

# If niether of those worked, then they have specified the binary they want, so
# just do exactly as they say.
exec "$@"
