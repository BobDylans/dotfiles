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

export https_proxy=http://127.0.0.1:7890
export http_proxy=http://127.0.0.1:7890
export all_proxy=http://127.0.0.1:7890
export no_proxy=localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8
export NO_PROXY=$no_proxy


source /home/ivan/.config/broot/launcher/bash/br

# Added by jcode installer
export PATH="/home/ivan/.local/bin:$PATH"
