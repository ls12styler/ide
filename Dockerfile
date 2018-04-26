FROM alpine:latest

# Install basics (HAVE to install bash & ncurses for tpm to work)
RUN apk update && apk add vim tmux git bash zsh wget curl ncurses

WORKDIR /home/me
ENV HOME /home/me

# Install oh-my-zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
COPY zshrc .zshrc
ENV SHELL /bin/zsh
ENV TERM xterm-256color

# Configure text editor - vim!
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# Consult the vimrc file to see what's installed
COPY vimrc .vimrc 
# Ctrl-P isn't managed by Vundle :(
RUN git clone https://github.com/kien/ctrlp.vim.git .vim/bundle/ctrlp.vim
RUN vim +PluginInstall +qall >> /dev/null

COPY tmux.conf .tmux.conf
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

# Fix dotfiles permissions
# Create me a user
RUN addgroup -S me && adduser -h /home/me -s /bin/zsh -D -S me me 
RUN chown -R me:me /home/me
USER me:me

#CMD tmux
