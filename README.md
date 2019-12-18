# My IDE

This allows an instance of the IDE per project.

Run via:

```
function ide() {
  PROJECT_DIR=${PWD##*/}
  PROJECT_NAME=${PWD#"${PWD%/*/*}/"}
  CONTAINER_NAME=${PROJECT_NAME//\//_}
  mkdir -p ~/.tmux/resurrect/${PROJECT_NAME}
  mkdir -p ~/.zsh/history/${PROJECT_NAME}
  touch ~/.zsh/history/${PROJECT_NAME}/zsh_history
  docker run --rm -it \
  -w /${PROJECT_DIR} \
  -v $PWD:/${PROJECT_DIR} \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.ssh:/home/me/.ssh \
  -v ~/.tmux/resurrect/${PROJECT_NAME}:/home/me/.tmux/resurrect \
  -v ~/.zsh/history/${PROJECT_NAME}/zsh_history:/home/me/.zsh_history \
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

Docker is installed onto the image. When running a container using the image, you can mount the Docker unix socket using `-v /var/run/docker.sock:/var/run/docker.sock`, which will gives access to the host machines Docker services. There is a limitation with using volume mounts because we're actually using the host services. Using something like `-e HOST_PATH=$PWD`, we can the mount directories from the host by prefixing mount options when running containers with `-v $HOST_PATH:/some/path`.

# TODO's

* Secrets?
** SSH Keys -- mounted host directory for now.
