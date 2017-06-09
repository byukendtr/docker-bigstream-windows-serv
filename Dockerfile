FROM ubuntu
MAINTAINER R Trisith
################# Install packages #############################
# curl, wget, git
RUN 	apt-get update && apt-get install -y curl && apt-get install -y wget && apt-get install -y git

# nodeJS
RUN	curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN	apt-get install -y nodejs
RUN	apt-get install -y build-essential

# docker
RUN	apt-get remove docker docker-engine
RUN	apt-get install -y \
    	apt-transport-https \
    	ca-certificates \
    	curl \
    	software-properties-common
RUN	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN	add-apt-repository \
   	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   	$(lsb_release -cs) \
   	stable"
RUN	apt update
RUN	apt-get install -y docker-ce

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

# nano editor
RUN 	apt-get install -y nano


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









