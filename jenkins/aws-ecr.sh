#!/usr/bin/env bash
docker build -t jenkins-server ./server
#docker build -t jenkins-agent ./agent
$(aws ecr get-login --profile tt7-dev)
docker tag jenkins-server:latest 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-server:latest
#docker tag jenkins-server:latest 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-server:$(git rev-parse --short HEAD)
#docker tag jenkins-agent:latest 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-agent:latest
#docker tag jenkins-agent:latest 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-agent:$(git rev-parse --short HEAD)
docker push 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-server:latest
#docker push 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-server:$(git rev-parse --short HEAD)
#docker push 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-agent:latest
#docker push 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-agent:$(git rev-parse --short HEAD)