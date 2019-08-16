#!/bin/bash -eux

# https://github.com/docker-library/openjdk/blob/master/11/jdk/slim/Dockerfile
# create symlinks, to retain compatibility with the OpenJDK Docker images
export JAVA_HOME="/usr/local/openjdk-11 "

if [ -x "$(command -v apt-get)" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -yq
    apt-get install -yq aptitude software-properties-common python-minimal \
      nano curl wget git gnupg2 apt-transport-https
    python --version

    mkdir -p /usr/lib/jvm/java-11-openjdk-amd64
    ln -s /usr/lib/jvm/java-11-openjdk-amd64/ $JAVA_HOME
elif [ -x "$(command -v dnf)" ]; then
    dnf makecache
    dnf --assumeyes install which nano curl wget git gnupg2 initscripts \
        hostname python3
    dnf clean all
    alternatives --set python /usr/bin/python3
    python --version

    mkdir -p /usr/lib/jvm/java-11-openjdk-11.0.4.11-0.el8_0.x86_64
    ln -s /usr/lib/jvm/java-11-openjdk-11.0.4.11-0.el8_0.x86_64/ $JAVA_HOME
elif [ -x "$(command -v yum)" ]; then
    yum makecache fast
    yum update -y
    yum install -y which nano curl wget git gnupg2 initscripts hostname gzip \
        tar
    yum clean all
    python --version

    mkdir -p /usr/lib/jvm/java-11-openjdk-11.0.4.11-0.el7_6.x86_64
    ln -s /usr/lib/jvm/java-11-openjdk-11.0.4.11-0.el7_6.x86_64/ $JAVA_HOME
fi
