# Path to your oh-my-zsh installation.
export ZSH="/home/me/.oh-my-zsh"

# What's my theme?
ZSH_THEME="xxf"

# Plugins?
plugins=(
  git
  tmux
  kubectl
  zsh-autosuggestions
)

bindkey '^ ' forward-word

HOST="[IDE] ($PROJECT_NAME)"

# Aliases
alias vim="nvim"
alias dive="docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest $@"
alias sbt="docker run --rm -it -u $HOST_USER_ID:$HOST_GROUP_ID -v $HOST_PATH:/project -v $IVY_PATH:/tmp/.ivy2 -w /project ls12styler/scala-sbt:latest -Dsbt.ivy.home=/tmp/.ivy2 -Dsbt.global.base=/tmp/.sbt -Dsbt.boot.directory=/tmp/.sbt"
alias k8s=kubectl
alias tf=terraform

source $ZSH/oh-my-zsh.sh
