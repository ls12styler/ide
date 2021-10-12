FROM ls12styler/dind:20.10.8

# Install basics (HAVE to install bash for tpm to work)
RUN apk update && apk add -U --no-cache \
    bash zsh git git-perl neovim less curl bind-tools \
    man-pages build-base su-exec shadow openssh-client sed coreutils

# Set Timezone
RUN apk add tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone && \
    apk del tzdata

ENV HOME /home/me

# Install tmux
COPY --from=ls12styler/tmux:3.1b /usr/local/bin/tmux /usr/local/bin/tmux

# Install jQ!
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -O /bin/jq && chmod +x /bin/jq

# Configure text editor - vim!
RUN curl -fLo ${HOME}/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Consult the vimrc file to see what's installed
COPY vimrc ${HOME}/.config/nvim/init.vim
# Clone the git repos of Vim plugins
WORKDIR ${HOME}/.config/nvim/plugged/
RUN git clone --depth=1 https://github.com/ctrlpvim/ctrlp.vim && \
    git clone --depth=1 https://github.com/tpope/vim-fugitive && \
    git clone --depth=1 https://github.com/godlygeek/tabular && \
    git clone --depth=1 https://github.com/plasticboy/vim-markdown && \
    git clone --depth=1 https://github.com/vim-airline/vim-airline && \
    git clone --depth=1 https://github.com/vim-airline/vim-airline-themes && \
    git clone --depth=1 https://github.com/vim-syntastic/syntastic && \
    git clone --depth=1 https://github.com/frazrepo/vim-rainbow && \
    git clone --depth=1 https://github.com/airblade/vim-gitgutter && \
    git clone --depth=1 https://github.com/derekwyatt/vim-scala && \
    git clone --depth=1 https://github.com/hashivim/vim-terraform.git && \
    git clone --depth=1 https://github.com/ekalinin/Dockerfile.vim.git && \
    git clone --depth=1 https://github.com/junegunn/seoul256.vim

# In the entrypoint, we'll create a user called `me`
WORKDIR ${HOME}

# Setup my $SHELL
ENV SHELL /bin/zsh
# Install oh-my-zsh
RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true
RUN git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${HOME}/.oh-my-zsh/plugins/zsh-autocomplete
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
# Copy ZSh config
COPY zshrc ${HOME}/.zshrc
COPY p10k.zsh ${HOME}/.p10k.zsh

# Install TMUX
COPY tmux.conf ${HOME}/.tmux.conf
RUN git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm && \
    ${HOME}/.tmux/plugins/tpm/bin/install_plugins

# Copy git config over
COPY gitconfig ${HOME}/.gitconfig

# Entrypoint script creates a user called `me` and `chown`s everything
COPY entrypoint.sh /bin/entrypoint.sh

# Copy over the useful scripts
COPY scripts/* /usr/local/bin/

# Set working directory to /workspace
WORKDIR /workspace

# Default entrypoint, can be overridden
CMD ["/bin/entrypoint.sh"]
