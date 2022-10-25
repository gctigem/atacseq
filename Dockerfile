# IMAGE
FROM ubuntu:22.10

# ENVIRONMENT
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# ARGUMENT
ARG DEBIAN_FRONTEND=noninteractive

# APT UPDATE
RUN apt-get -yqq update && apt-get -yqq upgrade

# APT BASE TOOL
RUN apt-get install -yqq apt-utils build-essential ca-certificates

# APT TOOL
RUN apt-get install -yqq wget curl gzip gawk bzip2 htop tree mc ranger
RUN apt-get install -yqq python3 python3-pip default-jdk

# DOCKER
RUN apt-get install -yqq docker.io

# NEXTFLOW
RUN curl -fsSl get.nextflow.io | bash
RUN mv nextflow ~/bin

# CLEAN
RUN apt-get -yqq autoremove && apt-get -yqq autoclean
