FROM debian:bullseye-20220418-slim

# Set timezone to UTC by default and configure locales

RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8


RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -qqy --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false


ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ENV VERSION $VERSION
ARG BUILD_TIMESTAMP
ENV BUILD_TIMESTAMP $BUILD_TIMESTAMP