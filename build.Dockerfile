FROM debian:bullseye-20220418-slim AS base

# Set timezone to UTC by default and configure locales

RUN ln -sf /usr/share/zoneinfo/Etc/Zulu /etc/localtime
RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8

WORKDIR /opt

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -qqy --assume-yes --no-install-recommends \
    git \
    ca-certificates \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    LANG=en_US.UTF-8; \
    echo $LANG UTF-8 > /etc/locale.gen; \
    locale-gen; \
    update-locale LANG=$LANG; \
    export LANG=$LANG; \
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y -qq --auto-remove -o APT::AutoRemove::RecommendsImportant=false;
  

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ENV VERSION $VERSION
ARG BUILD_TIMESTAMP
ENV BUILD_TIMESTAMP $BUILD_TIMESTAMP

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Dockerfile:1.4" \
      org.label-schema.description="Base Image" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor="CommodityStream, Inc" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
