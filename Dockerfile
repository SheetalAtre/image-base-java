FROM registry.access.redhat.com/ubi8/ubi-minimal:8.7 as java-builder
LABEL maintainer="OpsMx"

ARG JAVA_PACKAGE=java-11-openjdk-jmods
RUN microdnf update && microdnf install --setopt=tsflags=nodocs ${JAVA_PACKAGE}

# Build a custom JRE.
# For now, we will include all modules.  We could try to remove the ones
# we don't need to reduce image size and security attack surface.
WORKDIR /jrebuild
RUN java --list-modules | cut -d'@' -f1 > modules
RUN jlink --output runtime --add-modules `paste -sd, - < modules` --compress 2 --vm server

# Build a minimal base image with our custom Java installed.

FROM registry.access.redhat.com/ubi8/ubi-minimal:8.7 AS java-base
LABEL maintainer="OpsMx"
COPY --from=java-builder /jrebuild/runtime /opsmx-java11-runtime
ARG OPSMXUSER=1001
ENV JAVA_HOME=/opsmx-java11-runtime \
    PATH=${PATH}:/opsmx-java11-runtime/bin \
    WORK_DIR=/opsmx/workdir \
    CONF_DIR=/opsmx/conf
