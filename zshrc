# Path to your oh-my-zsh installation.
export ZSH="/home/me/.oh-my-zsh"

# What's my theme?
ZSH_THEME="xxf"

# Plugins?
plugins=(
  git
  tmux
)

PROJECT_NAME=${PROJECT_NAME:-~}

HOST="[IDE] ($PROJECT_NAME)"

alias vim="nvim"

source $ZSH/oh-my-zsh.sh
