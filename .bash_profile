#!/bin/bash
#
# .bash_profile, configuration for login shells.
#
_set_path () {
  local paths=(
    "$HOME/bin"
    # Added by claude-switch installer
    "$HOME/.local/bin"
    "/usr/local/bin"
    "/usr/local/opt/openjdk/bin"
    "$HOME/go/bin"
    "$HOME/.rvm/bin"
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
    "/usr/local/sbin"
    "/usr/bin"
    "/usr/sbin"
    "/bin"
    "/sbin"
  )

  export PATH=""
  for path in ${paths[@]}; do
    [ -d "$path" ] && PATH="$PATH":"$path"
  done
  PATH=${PATH:1:${#PATH}}  # In case you forget, this trims the leading ":"

  export PATH
}
_set_path

_set_variables () {
  export EDITOR=vim
  # Stupid MacOS warning
  export BASH_SILENCE_DEPRECATION_WARNING=1
}
_set_variables

# From here it converges to configuration for login shells
[[ $- == *i* ]] && [ -f ~/.bashrc ] && . ~/.bashrc
