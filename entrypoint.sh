#!/bin/sh

# Git config
if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

# Get standard cali USER_ID variable
USER_ID=${HOST_USER_ID:-9001}
GROUP_ID=${HOST_GROUP_ID:-9001}

# Change 'me' uid to host user's uid
if [ ! -z "$USER_ID" ] && [ "$(id -u me)" != "$USER_ID" ]; then
    # Create the user group if it does not exist
    groupadd --non-unique -g "$GROUP_ID" group

    # Set the user's uid and gid
    usermod --non-unique --uid "$USER_ID" --gid "$GROUP_ID" me
fi
chown -R me: /home/me

# Give user `me` permission to use docker!
if [ -f "/var/run/docker.sock" ]; then
    # Find the hosts group ID for the docker socket
    HOST_DOCKER_SOCKET_GROUP_ID=`stat -c %g /var/run/docker.sock`
    # create the group `docker`
    groupadd --non-unique -g "$HOST_DOCKER_SOCKET_GROUP_ID" docker
    # add `me` to the `docker` group
    adduser me docker
fi

exec /sbin/su-exec me tmux -u -2 new -s ${PROJECT_NAME}
