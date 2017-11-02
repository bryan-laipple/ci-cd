#!/usr/bin/env bash
#
# This script will build and tag a docker image then push it to ECR
#
# If your AWS CLI configuration has a named profile other than 'default' for AWS account
# then pass the profile name as the first argument.  If a profile is not passed as an argument
# the default profile is used.
#
# Usage:
#
# ./aws-ecr.sh <aws account id> <profile>
#
awsAccountId=$1
profile=${2:-default}
region=us-west-2
ecrRepo=jenkins-server
# TODO update for ecrRepo=jenkins-agent
ecrArn=${awsAccountId}.dkr.ecr.${region}.amazonaws.com/${ecrRepo}

build_docker_image() {
# TODO update for ecrRepo=jenkins-agent
  docker build -t ${ecrRepo} ./server
  docker tag ${ecrRepo}:latest ${ecrArn}:latest
  docker tag ${ecrRepo}:latest ${ecrArn}:$(git rev-parse --short HEAD)
}

push_to_ecr() {
  $(aws --profile $profile ecr get-login --no-include-email)
  docker push ${ecrArn}:latest
  docker push ${ecrArn}:$(git rev-parse --short HEAD)
}

build_docker_image
push_to_ecr
