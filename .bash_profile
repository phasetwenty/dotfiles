#!/bin/bash
#
# Shuttle initialization to my own framework
if [ ! -f ~/.bash/init ]; then
  >&2 echo "bash init not available!"
else
  . ~/.bash/init
fi


export PATH="$HOME/.poetry/bin:$PATH"
