# IMAGE
FROM ubuntu:22.10

# ENVIRONMENT
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# ARGUMENT
ARG DEBIAN_FRONTEND=noninteractive

# APT INSTALL
RUN apt-get -yqq update && apt-get -yqq upgrade
RUN apt-get install -yqq apt-utils build-essential ca-certificates
RUN apt-get install -yqq wget curl gzip gawk git bzip2
RUN apt-get install -yqq python3 python3-pip
RUN apt-get install -yqq fastqc samtools bwa bamtools bedtools