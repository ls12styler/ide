#!/bin/sh

# Git config
if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

export IVY_PATH=${IVY_PATH:-"${HOST_PATH}/.ivy2"}

# Create a user and group that matches the host, either using ID's provided or
# collected from the '/workspace' directory
export HOST_USER_ID=${HOST_USER_ID:-`stat -c %u /workspace`}
export HOST_GROUP_ID=${HOST_GROUP_ID:-`stat -c %g /workspace`}

groupadd -g $HOST_GROUP_ID group
useradd -u $HOST_USER_ID -g group me

# To fix (:fingerscrossed:) an issue encoutered with the permissions of the SSH
# config and keys when used on other contexts, seemingly introduced by the
# below `chown` of the entire contents of the local users $HOME, rather than
# mouting the ~/.ssh directory directly, we only mount to then copy the
# contents into the local users' $HOME

[ -d "/local/.ssh" ] && cp -r /local/.ssh /home/me/.ssh

# This is to ensure all the files that we copy into the container are owned
# with the right permissions
chown -R me: /home/me

export PROJECT_NAME=${PROJECT_NAME:-"Standalone"}
exec /sbin/su-exec me tmux -u -2 new -s ${PROJECT_NAME}
