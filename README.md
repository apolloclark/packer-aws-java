# packer-openjdk

Packer based project for provisioning a "java" image using Ansible remote, 
and Serverspc, for AWS, or Virtualbox, with Elastic monitoring and Java.

## Requirements

To use this project, you must have installed:
- [Packer](https://www.packer.io/downloads.html)
- [Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)
- [Serverspec](http://serverspec.org/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
- [jq](https://stedolan.github.io/jq/)

(Optional)
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)

## Install
```shell
git clone --recurse-submodules https://github.com/apolloclark/packer-openjdk
cd ./packer-openjdk

# update submodules
git submodule update --recursive --remote

# set your Docker hub username
export DOCKER_USERNAME="apolloclark" # $(whoami)
export DOCKER_PASSWORD=""

# build both the Ubuntu 16.04 and Centos 7.6 images
./build_packer_docker_all.sh



# clean up ALL previous builds
./clean_packer_docker.sh

# Gradle, clean up previous builds, from today
gradle clean --parallel --project-dir gradle-build

# Gradle, build all images, in parallel
gradle test --rerun-tasks --parallel --project-dir gradle-build

# Gradle, build only specific OS images
gradle ubuntu18.04:test --project-dir gradle-build --rerun-tasks
gradle ubuntu16.04:test --project-dir gradle-build --rerun-tasks
gradle centos7.6:test   --project-dir gradle-build --rerun-tasks
gradle rhel7.6:test     --project-dir gradle-build --rerun-tasks
gradle rhel8.0:test     --project-dir gradle-build --rerun-tasks

# Gradle, publish images
gradle push --parallel --project-dir gradle-build

# Gradle, list tasks, and dependency graph
gradle tasks --project-dir gradle-build
gradle tasks --all --project-dir gradle-build
gradle test taskTree --project-dir gradle-build

# Gradle, debug
gradle properties
gradle ubuntu16.04:info --project-dir gradle-build
gradle ubuntu16.04:test --project-dir gradle-build --info --rerun-tasks
rm -rf ~/.gradle



## Deploy to AWS, with Packer
```shell
git clone https://github.com/apolloclark/packer-openjdk
cd ./packer-openjdk/base
# create a keypair named "packer" or change lines 26, 27 in build_packer_aws.sh
./build_packer_aws.sh
```

## Deploy to Virtualbox, with Packer
```shell
git clone https://github.com/apolloclark/packer-openjdk
cd ./packer-openjdk/base
./build_packer_virtualbox.sh
```

## Deploy to Virtualbox, with Vagrant
```shell
git clone https://github.com/apolloclark/packer-openjdk
cd ./packer-openjdk/base
vagrant up
vagrant ssh
```

## Ansible

Ansible Roles:
- [idealista.java](https://github.com/idealista/java_role)
