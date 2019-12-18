FROM docker.io/library/centos:8
RUN set -x && \
    dnf -y install zsh rpm-build yum-utils
RUN set -x && \
    dnf -y install gcc annobin
RUN dnf config-manager --set-enabled PowerTools

ENV SRPMIX_STYPE dds
ENV SRPMIX_EXPANDER srpm

COPY ./srpmix7 /usr/bin/srpmix7
    
