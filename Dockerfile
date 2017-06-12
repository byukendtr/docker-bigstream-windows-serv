FROM ubuntu
MAINTAINER R Trisith
################# Install packages #############################
# install curl, wget, git, nano
RUN 	apt-get update && apt-get install -y curl && apt-get install -y wget && apt-get install -y git && \
	apt-get install -y nano

# nodeJS
RUN	curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN	apt-get install -y nodejs
RUN	apt-get install -y build-essential


# pm2
RUN	npm install -y pm2@latest -g
	
# redis
RUN	apt-get install -y redis-server


# rabbitmq
RUN	echo 'deb http://www.rabbitmq.com/debian/ testing main' | \
     	tee /etc/apt/sources.list.d/rabbitmq.list
RUN	wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | \
     	apt-key add -
RUN	apt-get update
RUN	apt-get install -y rabbitmq-server

# edit redis permanent store
RUN	sed -i 's/appendonly no/appendonly yes/g' /etc/redis/redis.conf



################################################################

# big-stream clone
RUN 	git clone https://github.com/igridproject/node-bigstream.git ~/node-bigstream
RUN 	npm install --prefix ~/node-bigstream

EXPOSE 19980 19080 19180 6379

# start server
ENTRYPOINT 	rabbitmq-server -detached && \
		/etc/init.d/redis-server start && \
		pm2 start ~/node-bigstream/serv-httplistener.js && \
		pm2 start ~/node-bigstream/serv-scheduler.js && \
		pm2 start ~/node-bigstream/serv-api.js && \
		pm2 start ~/node-bigstream/serv-storage.js && \
		pm2 start ~/node-bigstream/work-jobworker.js && \
		pm2 reload all && \
		/bin/bash










