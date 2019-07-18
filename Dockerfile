FROM alpine:latest as builder

ARG DOCKER_CLI_VERSION="18.06.3-ce"
ENV DOCKER_DOWNLOAD_URL="https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz"

# install docker client
RUN apk --update add curl \
    && mkdir -p /tmp/download \
    && curl -L $DOCKER_DOWNLOAD_URL | tar -xz -C /tmp/download

ARG DOCKER_COMPOSE_VERSION="1.24.1"
ENV COMPOSE_DOWNLOAD_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64"

# install docker-compose
RUN curl -L $COMPOSE_DOWNLOAD_URL > /bin/docker-compose \
    && chmod +x /bin/docker-compose

FROM alpine:latest

# Install basics (HAVE to install bash & ncurses for tpm to work)
RUN apk update && apk add -U --no-cache \
	bash zsh git neovim less curl bind-tools \
	man build-base su-exec shadow openssh-client \
	# Required for docker-compose
	py-pip python-dev libffi-dev openssl-dev gcc libc-dev make

# Install docker client
COPY --from=builder /tmp/download/docker/docker /usr/local/bin/docker

# Install docker-compose
COPY --from=builder /bin/docker-compose /usr/local/bin/docker-compose

# Install tmux
COPY --from=ls12styler/tmux:latest /usr/local/bin/tmux /usr/local/bin/tmux

# Install jQ!
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -O /bin/jq && chmod +x /bin/jq

# Create a user called 'me'
RUN useradd -ms /bin/zsh me
# Do everything from now in that users home directory
WORKDIR /home/me
ENV HOME /home/me

# Setup my $SHELL
ENV SHELL /bin/zsh
# Install oh-my-zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN wget https://gist.githubusercontent.com/xfanwu/18fd7c24360c68bab884/raw/f09340ac2b0ca790b6059695de0873da8ca0c5e5/xxf.zsh-theme -O .oh-my-zsh/custom/themes/xxf.zsh-theme
# Copy ZSh config
COPY zshrc .zshrc

# Configure text editor - vim!
RUN curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Consult the vimrc file to see what's installed
COPY vimrc .config/nvim/init.vim 
# Ctrl-P isn't managed by Vundle :(
RUN nvim +PlugInstall +qall >> /dev/null

# Install TMUX
COPY tmux.conf .tmux.conf
RUN git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
RUN .tmux/plugins/tpm/bin/install_plugins

# Copy git config over
COPY gitconfig .gitconfig

# Entrypoint script does switches u/g ID's and `chown`s everything
COPY entrypoint.sh /bin/entrypoint.sh

# Set working directory to /workspace
WORKDIR /workspace

# Default entrypoint, can be overridden
CMD ["/bin/entrypoint.sh"]
