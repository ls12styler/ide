# My IDE

Run via:
```
docker run -it --rm -v `pwd`:/home/user/workspace -e HOST_USER_ID=$(id -u $USER) -e HOST_GROUP_ID=$(id -g $USER) ls12styler/ide:latest
```
This mounts the CWD under `/home/user/workspace`.
