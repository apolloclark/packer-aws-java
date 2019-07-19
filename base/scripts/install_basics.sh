#!/bin/bash -eux

if [ -x "$(command -v apt-get)" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -yq
    apt-get install -yq aptitude software-properties-common python-minimal \
      nano curl wget git gnupg2 apt-transport-https
fi

if [ -x "$(command -v yum)" ]; then
    yum update -y
    yum install -y which nano curl wget git gnupg2 initscripts
fi
