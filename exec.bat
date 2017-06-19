@echo off
REM start container
docker start node_bigstream
REM execute it
docker exec -it node_bigstream /bin/bash