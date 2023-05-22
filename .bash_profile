#!/bin/bash
#
# Shuttle initialization to my own framework
if [ ! -f ~/.bash/init ]; then
  >&2 echo "bash init not available!"
else
  . ~/.bash/init
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
source /opt/homebrew/etc/bash_completion
source ~/.bash_hotpads_mac
