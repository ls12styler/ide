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

alias vim="nvim"
alias dive="docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest $@"
alias sbt="docker run --rm -it -u $HOST_USER_ID:$HOST_GROUP_ID -v $HOST_PATH:/project -v $IVY_PATH:/tmp/.ivy2 -w /project ls12styler/scala-sbt:latest -Dsbt.ivy.home=/tmp/.ivy2 -Dsbt.global.base=/tmp/.sbt -Dsbt.boot.directory=/tmp/.sbt"
alias kubectl="docker run --rm -it -v ${KUBE_HOME}:/.kube -w /project -v ${HOST_PATH}:/project bitnami/kubectl:latest"
alias k8s=kubectl
alias helm="docker run -ti --rm -v ${HOST_PATH}:/apps -v ${KUBE_HOME}:/root/.kube -v ${KUBE_HOME}:/root/.config/kube -v ${HELM_HOME}:/root/.config/helm -v ${HELM_HOME}/cache:/root/.cache/helm alpine/helm"
alias gcloud="docker run --rm -it --volumes-from=gcloud-config -v ${HOST_PATH}:/local google/cloud-sdk:latest gcloud"
alias terraform="docker run --rm -it -v $HOST_PATH:/workspace -w /workspace hashicorp/terraform:light"
alias tf=terraform

source $ZSH/oh-my-zsh.sh
