#!/bin/sh

# Get standard cali USER_ID variable
USER_ID=${HOST_USER_ID:-9001}
GROUP_ID=${HOST_GROUP_ID:-9001}

# Change 'user' uid to host user's uid
if [ ! -z "$USER_ID" ] && [ "$(id -u user)" != "$USER_ID" ]; then
    # Create the user group if it does not exist
    groupadd --non-unique -g "$GROUP_ID" group

    # Set the user's uid and gid
    usermod --non-unique --uid "$USER_ID" --gid "$GROUP_ID" user
fi
chown -R user: /home/user

exec /sbin/su-exec user tmux -u "$@"
