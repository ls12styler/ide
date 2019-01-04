# My IDE

Run via:
```
docker run -it --rm -v `pwd`:/workspace \
    -e HOST_USER_ID=$(id -u $USER) -e HOST_GROUP_ID=$(id -g $USER) \
	-e GIT_USER_NAME="My Name" -e GIT_USER_EMAIL="my@email.com"
	ls12styler/ide:latest
```
This mounts the CWD under `/workspace`.
