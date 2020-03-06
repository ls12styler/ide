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
  -e KUBE_CONFIG="/path/to/.kube/config" \
  -e HELM_CONFIG="/path/to/.helm" \
  --name $CONTAINER_NAME \
  --net host \
  ls12styler/ide:latest
}
```

This mounts the CWD under `/workspace`.

# Using Docker

Docker is installed onto the image. When running a container using the image, you can mount the Docker unix socket using `-v /var/run/docker.sock:/var/run/docker.sock`, which will gives access to the host machines Docker services. There is a limitation with using volume mounts because we're actually using the host services. Using something like `-e HOST_PATH=$PWD`, we can the mount directories from the host by prefixing mount options when running containers with `-v $HOST_PATH:/some/path`.

# TODO's

* Secrets?
** SSH Keys -- mounted host directory for now.
