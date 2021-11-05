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
  -v ~/.ssh:/local/.ssh \
  -v ${TMUX_RESURRECT}:/home/me/.tmux/resurrect \
  -v ${ZSH_HISTORY}:/home/me/.zsh_history \
  -e IVY_PATH=${HOME}/.ivy2 \
  -e HOST_PATH=$PWD \
  -e HOST_USER_ID=$(id -u $USER) \
  -e HOST_GROUP_ID=$(id -g $USER) \
  -e PROJECT_NAME=$PROJECT_NAME \
  -e GIT_USER_NAME="Me McMe" \
  -e GIT_USER_EMAIL="me@me.com" \
  --name $CONTAINER_NAME \
  --net host \
  ls12styler/ide:latest
}
```

This mounts the CWD under `/workspace`.

# Using Docker

Expose the local machines Docker Socket over HTTP using the following:
```
docker run -d --restart=always \
    -p 127.0.0.1:2376:2376 \
    --name docker-http \
    -v /var/run/docker.sock:/var/run/docker.sock \
    alpine/socat \
    tcp-listen:2376,fork,reuseaddr unix-connect:/var/run/docker.sock
```

Update the `ide()` function above to include and set the following Docker Environment Variables:
```
DOCKER_HOST=tcp://$(docker inspect -f "{{.NetworkSettings.IPAddress}}" docker-http):2376
```

# Config

## gcloud, kubectl, helm & terraform

Follow: https://cloud.google.com/sdk/docs/downloads-docker

# TODO's

* Secrets?
** SSH Keys -- mounted host directory for now.
