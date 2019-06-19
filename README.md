# My IDE

This allows an instance of the IDE per project.

Run via:

```
  PROJECT_NAME=${PWD#"${PWD%/*/*}/"}
  CONTAINER_NAME=${PROJECT_NAME//\//_}
  docker run -it --rm \
  -v $PWD:/workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.ssh:/home/me/.ssh \
  -v ~/.tmux/ressurect/${PROJECT_NAME}:/home/me/.tmux/resurrect \
  -e HOST_PATH=$PWD \
  -e HOST_USER_ID=$(id -u $USER) \
  -e HOST_GROUP_ID=$(id -g $USER) \
  -e PROJECT_NAME=$PROJECT_NAME \
  -e GIT_USER_NAME="My Name" \
  -e GIT_USER_EMAIL="me@email.com" \
  --name $CONTAINER_NAME \
  ls12styler/ide:latest
```

This mounts the CWD under `/workspace`.

# Using Docker

Docker is installed onto the image. When running a container using the image, you can mount the Docker unix socket using `-v /var/run/docker.sock:/var/run/docker.sock`, which will gives access to the host machines Docker services. There is a limitation with using volume mounts because we're actually using the host services. Using something like `-e HOST_PATH=$PWD`, we can the mount directories from the host by prefixing mount options when running containers with `-v $HOST_PATH:/some/path`.

# TODO's

* Secrets?
** SSH Keys -- mounted host directory for now.
