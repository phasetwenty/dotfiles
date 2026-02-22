#!/bin/bash
#
# Shuttle initialization to my own framework
if [ ! -f ~/.bash/init ]; then
  >&2 echo "bash init not available!"
else
  . ~/.bash/init
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.poetry/bin:$PATH"
