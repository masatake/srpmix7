FROM registry.redhat.io/ubi8/ubi
RUN set -x && \
    dnf -y install zsh rpm-build yum-utils
RUN set -x && \
    dnf -y install gcc annobin
RUN set -x && \
    dnf config-manager --set-enabled rhel-8-for-x86_64-appstream-rpms && \
     dnf config-manager --set-enabled codeready-builder-for-rhel-8-x86_64-rpms

ENV SRPMIX_STYPE dds
ENV SRPMIX_EXPANDER srpm

COPY ./srpmix7 /usr/bin/srpmix7
