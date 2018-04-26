FROM alpine:latest

# Install basics (HAVE to install bash for tpm to work)
RUN apk update && apk add vim tmux git bash zsh wget curl

# Create me a user
RUN addgroup -S me && adduser -h /home/me -s /bin/zsh -D -S me me 
USER me:me
WORKDIR /home/me

# Install oh-my-zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
COPY zshrc .zshrc
ENV SHELL /bin/zsh

# Configure text editor - vim!
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# Consult the vimrc file to see what's installed
COPY vimrc .vimrc 
# Ctrl-P isn't managed by Vundle :(
RUN git clone https://github.com/kien/ctrlp.vim.git .vim/bundle/ctrlp.vim
RUN vim +PluginInstall +qall >> /dev/null

COPY tmux.conf .tmux.conf
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#RUN ~/.tmux/plugins/tpm/bin/install_plugins

# Fix dotfiles permissions
USER root
RUN chown me:me .zshrc .tmux.conf .vimrc
USER me:me

#CMD tmux
