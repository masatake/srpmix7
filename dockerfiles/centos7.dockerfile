FROM docker.io/library/centos:7
RUN set -x && \
    yum -y install zsh rpm-build yum-utils

RUN yum -y install centos-release-scl-rh

ENV SRPMIX_STYPE yds
ENV SRPMIX_EXPANDER srpm

RUN yum -y install cpp

COPY ./srpmix7 /usr/bin/srpmix7
