#!/bin/bash
#
# Shuttle initialization to my own framework
#
CHAVERMA_HOST_FILE=".chaverma-host"

if [ ! -d ".chaverma" ]; then
    >&2 echo "Fatal error configuring shell: missing .chaverma directory."
    return 1
fi

if [ -r ".chaverma/functions" ]; then
    . .chaverma/functions
else
    >&2 echo "Fatal error configuring shell: functions file missing."
    return 1
fi


if [ -r ".chaverma/all_shell_options" ]; then
    . .chaverma/all_shell_options
else
    >&2 echo "Fatal error configuring shell: shell options file missing."
    return 1
fi

! is_interactive && return 0

host_dir=
if [ -r "$HOME/$CHAVERMA_HOST_FILE" ]; then
    host_dir="$(cat $HOME/$CHAVERMA_HOST_FILE)"
else
    # Not assigning this above to avoid calling the command unnecessarily, speeding up the start
    host_dir="$(hostname)"
fi

path_to_init="$HOME/.chaverma/host-$host_dir/init"
if [ -r "$path_to_init" ]; then
    . "$path_to_init"
else
    >&2 echo "Fatal error configuring shell: init file $path_to_init does not exist."
    return 1
fi
