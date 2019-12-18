FROM registry.redhat.io/ubi7/ubi
RUN set -x && \
    yum -y install zsh rpm-build yum-utils
RUN set -x && \
    yum -y install gcc annobin
RUN set -x && \
    yum repolist && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum-config-manager --enable rhel-7-server-extras-rpms

ENV SRPMIX_STYPE yds
ENV SRPMIX_EXPANDER srpm

COPY ./srpmix7 /usr/bin/srpmix7
