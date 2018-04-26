FROM alpine:latest

RUN apk update && apk add -y vim tmux

COPY .tmux.conf ~/.tmux.conf
COPY .vimrc ~/.vimrc
