@echo off
REM build image name bigstream
docker build -t=bigstream .
REM start container name node_bigstream
docker run --name node_bigstream -v c:/data:/data -p 19980:19980 -p 19080:19080 -p 19180:19180 -p 6380:6379 -it -d bigstream

setlocal
:PROMPT
echo Build Done!!!
echo.Running container...
echo.
SET /P exit=[Press ENTER to exit]
endlocal

