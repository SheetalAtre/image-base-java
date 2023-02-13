FROM registry.access.redhat.com/ubi8/ubi-minimal:8.7 as java-base
LABEL maintainer="OpsMx"

ARG JAVA_PACKAGE=java-11-openjdk-headless
ARG OPSMXUSER=1001

RUN microdnf update \
    && microdnf install --setopt=tsflags=nodocs curl ca-certificates ${JAVA_PACKAGE} \
    && microdnf clean all

ENV WORK_DIR=/opsmx/workdir \
    CONF_DIR=/opsmx/conf
