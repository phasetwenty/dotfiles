#!/bin/bash
#
umask 002
#
# Shell conveniences
#
export HISTFILESIZE=2000
# ignores duplicate lines and lines prepended with spaces. Latter is useful for preventing sensitive
# information persisting to a log
export HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# Case insensitive filenames for globbing
shopt -s nocaseglob
# Case insensitive filenames for tab completion
bind 'set completion-ignore-case on'

#
# application configuration
#
# Unfortunately, this is currently messing up Claude Code. When it shells out for
# some activity, the color option is inherited and creates errors in the subshell.
# I've been working around by using:
# $ GREP_OPTIONS= claude
[[ $- == *i* ]] && export GREP_OPTIONS='--color=always'
#
# -F: exit if less than one screen long
# -X: verbatim, "Disables sending the termcap initialization and deinitialization strings to the
#     terminal. This is sometimes desirable if the deinitialization string does something
#     unnecessary, like clearing the screen."
# -R: display raw control characters, i.e., disable color formatting
export LESS="-FXR"
#
# User functions
#
# Generates a random string of hex digits. I've used this in the past to tokenize informal secrets
hex_string() {
  # $1 length
  cat /dev/urandom | env LC_CTYPE=ALL tr -cd 'a-f0-9' | head -c "$1"
}

# Generate a random number up to a parameterize upper bound
rand() {
    # $1 upper bound
    [ -z $1 ] && echo "Usage: rand N where N is the upper bound to use" && return
    echo $(($RANDOM % $1))
}

#
# Set my home directories
#
_home_dirs () {
  local custom_dirs=(
      "bin"
      "Workspace"
  )
  for name in ${custom_dirs[@]}; do
      [ ! -d "$HOME/$name" ] && mkdir "$HOME/$name"
  done
}
_home_dirs

#
# Homebrew specifics
#
[ -e /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -e /opt/homebrew/etc/bash_completion ] && . /opt/homebrew/etc/bash_completion
#
# Aliases
#
ls_custom () {
  # Customized ls enforcing:
  # * Color
  # * Directories grouped first
  # * Paging with less
  #
  # It depends on an alternate build of ls coming from homebrew; if the package isn't available, 
  # directories can't group first. This approach is iterated from my first implementation, where I
  # check the package at shell start. I wanted to shave off some startup time so now it checks 
  # just in time and memoizes the result.
  #
  # $1 ls args
  # $2 target or empty
  #
  if [ -z "$MY_LS" ]; then
    local path=$(type -P gls)
    if [ $? ]; then
      MY_LS="$path -G --group-directories-first --color=always"
    else
      MY_LS="/bin/ls -G --color=always"
      >&2 echo "gls missing; no directory grouping is possible."
    fi
    export MY_LS
  fi

  if [ -z "$2" ]; then
    $MY_LS "$1" | less
  else
    $MY_LS "$1" "$2" | less
  fi
}

alias claude='GREP_OPTIONS= $(which claude)'
alias cleano='find . -name "*.orig" -exec rm {} \;'
alias jb-delete-cache='rm -rf ~/Library/Caches/JetBrains/'
alias ll='ls_custom -l' # probably don't need the extra L but I'm used to it.
alias la='ls_custom -la'
alias lhl='ls_custom -hl'
# Trailing space is load-bearing!
alias s='sudo '
#
# Prompt
# Prompt is so complicated I'm inclined to keep it as a separate file.
#
_init_prompt () {
  # Non-interative terminal => exit
  [[ $- != *i* ]] && return

  if [ -f "$HOME/.bash/prompt" ]; then
    . "$HOME/.bash/prompt"
  else
    >&2 echo "prompt init file is missing, shell is improperly configured!"
  fi
}
_init_prompt
#
# Applications
#
init_nvm () {
  # Initializing NVM
  # As you can see, this function isn't called, it's being saved for on-demand use. 2 reasons for this:
  # 1. The load time on the script is rough; seconds-scale
  # 2. I use nvm rarely; months with no use then a week or so
  #
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] || return
  export NVM_DIR="$HOME/.nvm"
  # This loads nvm
  . "/opt/homebrew/opt/nvm/nvm.sh"
  # This loads nvm bash_completion
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}

_init_dotfiles () {
    #
    # Sets another alias "dotfiles"
    #
    # Using a function for namespacing.
    export DOTFILES_REMOTE="https://github.com/phasetwenty/dotfiles.git"
    local dotfiles_repo_name='.dotfiles-repo'  # Name of the directory that holds our bare repo
    local dotfiles_alias="git --git-dir=$HOME/$dotfiles_repo_name/ --work-tree=$HOME"

    alias dotfiles="$dotfiles_alias"
    # Using this alias right away caused an error message to pop up.
    $dotfiles_alias config --local status.showUntrackedFiles no
}
_init_dotfiles

_init_git () {
  #
  # Git completion
  #
  # Completion, has no dependencies
  if [ ! -f ~/.gitrc/git-completion ]; then
    >&2 echo "git-completion is not available!"
  else
    # This script is hundreds of lines long, and I felt it would be easier to keep it contained.
    . ~/.gitrc/git-completion
  fi
}
_init_git

_init_git_email () {
  #
  # Git email
  # On work machine it's my work email, at home it's another email
  #
  if [[ $(hostname) == "ZG13786" ]]; then
      git config --global user.email "chaverman@zillowgroup.com"
  else
      git config --global user.email "chris.haverman@gmail.com"
  fi
}
_init_git_email

_init_iterm2 () {
  local _path_to_file="$HOME/.bash/applications/iterm2_shell_integration.bash"

  if [ -f "$_path_to_file" ]; then
    . "$_path_to_file"
  else
    >&2 echo "iterm2 shell integration is not available!"
  fi
}
_init_iterm2

#
# Work specifics
#
[ -d "$HOME/workspace/rpjava/app/invoice-delivery/server" ] && export IDEL="$HOME/workspace/rpjava/app/invoice-delivery/server"
export PODMAN_APPS="memcached percona redis"
[ -e "$HOME/.bash_hotpads_mac" ] && . "$HOME/.bash_hotpads_mac"
