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
alias dive="docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest $@"
alias sbt="docker run --rm -it -v $HOST_PATH:/project -v $HOST_PATH/.ivy2:/root/.ivy2 -w /project ls12styler/scala-sbt:latest"

source $ZSH/oh-my-zsh.sh
