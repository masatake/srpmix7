FROM docker.io/library/fedora:31
RUN set -x && \
    yum -y install zsh rpm-build dnf-plugins-core
RUN set -x && \
    yum -y install gcc annobin

ENV SRPMIX_STYPE dds
ENV SRPMIX_EXPANDER srpm

COPY ./srpmix7 /usr/bin/srpmix7
