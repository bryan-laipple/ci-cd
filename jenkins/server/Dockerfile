FROM jenkinsci/jenkins:2.46.1-alpine

USER root
# add docker, shadow (for groupadd and usermod), node, python, aws-cli
RUN apk add --update --no-cache \
        docker \
        shadow \
        nodejs \
        python \
        py-pip \
    && pip install --upgrade pip \
    && pip install awscli

# update jenkins user to be able to run docker commands against outside daemon
# this is known as docker outside of docker (aka DooD)
# this developer doesn't know why 'staff' is the magic group for this privelege
# dood group id obtained from running `getent group docker` on host that will run this container
RUN groupadd -g 50 staff \
    && groupadd -g 497 dood \
    && usermod -a -G staff,docker,dood jenkins

USER jenkins
# updates based on info from https://github.com/jenkinsci/docker/blob/master/README.md
#COPY conf/plugins.txt /var/jenkins_home/plugins.txt
#RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# set number of executors
ARG executors=2
RUN { \
		echo 'import jenkins.model.*'; \
		echo 'Jenkins.instance.setNumExecutors('${executors}')'; \
	} > /usr/share/jenkins/ref/init.groovy.d/executors.groovy