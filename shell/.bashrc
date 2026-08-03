#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR=nvim
export VISUAL=nvim

export https_proxy=http://127.0.0.1:7897
export http_proxy=http://127.0.0.1:7897


source /home/ivan/.config/broot/launcher/bash/br

# Added by jcode installer
export PATH="/home/ivan/.local/bin:$PATH"
