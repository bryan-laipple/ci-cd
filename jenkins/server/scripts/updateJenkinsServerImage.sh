#!/usr/bin/env bash
$(aws ecr get-login --region us-west-2)
docker pull 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-server:latest
docker tag 763497084069.dkr.ecr.us-west-2.amazonaws.com/jenkins-server:latest jenkins-server:latest