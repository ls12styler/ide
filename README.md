# My IDE

This allows an instance of the IDE per project.

Run via:

```
function ide() {
  PROJECT_DIR=${PWD##*/}
  PROJECT_NAME=${PWD#"${PWD%/*/*}/"}
  CONTAINER_NAME=${PROJECT_NAME//\//_}
  TMUX_RESURRECT=${HOME}/.ide/${PROJECT_NAME}/tmux/resurrect
  mkdir -p ${TMUX_RESURRECT}
  ZSH=${HOME}/.ide/${PROJECT_NAME}/zsh/
  mkdir -p ${ZSH}
  touch ${ZSH}/zsh_history
  docker run --rm -it \
  -w /${PROJECT_DIR} \
  -v $PWD:/${PROJECT_DIR} \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.ssh:/home/me/.ssh \
  -v ${TMUX_RESURRECT}:/home/me/.tmux/resurrect \
  -v ${ZSH_HISTORY}:/home/me/.zsh_history \
  -e IVY_PATH=${HOME}/.ivy2 \
  -e HOST_PATH=$PWD \
  -e HOST_USER_ID=$(id -u $USER) \
  -e HOST_GROUP_ID=$(id -g $USER) \
  -e PROJECT_NAME=$PROJECT_NAME \
  -e GIT_USER_NAME="Me McMe" \
  -e GIT_USER_EMAIL="me@me.com" \
  -e KUBE_HOME="/path/to/.kube" \
  -e HELM_HOME="/path/to/.helm" \
  --name $CONTAINER_NAME \
  --net host \
  ls12styler/ide:latest
}
```

This mounts the CWD under `/workspace`.

# Using Docker

// DOCUMENT

# TODO's

* Secrets?
** SSH Keys -- mounted host directory for now.
