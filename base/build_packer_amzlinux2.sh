#!/bin/bash -eux

docker pull amazoncorretto:11

docker build -t apolloclark/openjdk:11-amzlinux2 - < Dockerfile_amzlinux2

docker tag apolloclark/openjdk:11-amzlinux2 apolloclark/openjdk:11-amzlinux2-$(date -u '+%Y%m%d')

docker images | grep 'amzlinux2' | grep 'openjdk'

export DOCKER_USERNAME="apolloclark"
export PACKAGE_NAME="openjdk"
export PACKAGE_VERSION="11"
export IMAGE_NAME="amzlinux2"

rspec ./spec/Dockerfile_amzlinux2.rb

docker push apolloclark/openjdk:11-amzlinux2

docker push apolloclark/openjdk:11-amzlinux2-$(date -u '+%Y%m%d')
