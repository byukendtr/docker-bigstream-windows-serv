@echo off
REM create container name node_bigstream
docker run --name node_bigstream -v c:/data:/data -p 19980:19980 -p 19080:19080 -p 19180:19180 -p 6380:6379 -it -d bigstream





