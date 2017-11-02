#!/usr/bin/env bash
#
# This script will pull the latest jenkins-server docker image from ECR into the local Docker repository.
#
# If your AWS CLI configuration has a named profile other than 'default' for AWS account
# then pass the profile name as the first argument.  If a profile is not passed as an argument
# the default profile is used.
#
# Usage:
#
# ./updateJenkinsServerImage.sh <aws account id> <profile>
#
awsAccountId=$1
profile=${2:-default}
region=us-west-2
ecrRepo=jenkins-server
ecrArn=${awsAccountId}.dkr.ecr.${region}.amazonaws.com/${ecrRepo}

$(aws --profile $profile ecr get-login --no-include-email)
docker pull ${ecrArn}:latest
docker tag ${ecrArn}:latest ${ecrRepo}:latest