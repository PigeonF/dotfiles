# include .profile if it exists
[[ -f ~/.profile ]] && . ~/.profile

export HISTFILE="${XDG_STATE_HOME}/bash/history"
export HISTFILESIZE=100000
export HISTIGNORE='ls:exit'
export HISTSIZE=10000

# include .bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc
