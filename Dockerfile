FROM alpine:latest

# Install basics (HAVE to install bash & ncurses for tpm to work)
RUN apk update && apk add -U --no-cache zsh git shadow su-exec neovim tmux bash ncurses less curl python2 python3 ruby openssh-client

# Create a user called 'user'
RUN useradd -ms /bin/zsh user
#USER user
# Do everything from now in that users home directory
WORKDIR /home/user
ENV HOME /home/user

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

# Entrypoint script does switches u/g ID's and `chown`s everything
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
