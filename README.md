# My IDE

Run via:
```
docker run -it --rm -v `pwd`:/workspace -e HOST_USER_ID=$(id -u $USER) -e HOST_GROUP_ID=$(id -g $USER) ls12styler/ide:latest
```
This mounts the CWD under `/workspace`.
