FROM jenkinsci/jnlp-slave:alpine

USER root
# add docker and shadow (for groupadd and usermod)
RUN apk add --update --no-cache \
        docker \
        shadow
# update jenkins user to be able to run docker commands against outside daemon
# this is known as docker outside of docker (aka DooD)
# this developer doesn't know why 'staff' is the magic group for this privelege
RUN groupadd -g 50 staff \
    && usermod -aG staff jenkins

USER jenkins
