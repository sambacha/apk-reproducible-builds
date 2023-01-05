# syntax=docker/dockerfile:1.4

# FROM debian:stretch-20220418 AS builder
FROM buildpack-deps:bullseye-scm@sha256:ecad7c5bf28a62451725306f097e8c731eeeed1c21f4763c1f47eed26e38a9c7 AS builder

ARG DEBIAN_FRONTEND=noninteractive


COPY docker/ docker/
COPY docker/apt.conf docker/sources.list /etc/apt/

RUN dpkg --add-architecture i386

ENV RUN DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
  apt-utils \
  \
  $(cat docker/dependencies.txt) \
  && rm -rf /var/lib/apt/lists/* 
  
# RUN apt-get update -y && apt-get install -y 

# RUN apt-get update -y && apt-get install -y $(cat docker/dependencies.txt)
RUN docker/print-versions.sh docker/dependencies.txt

ENV ANDROID_COMMAND_LINE_TOOLS_FILENAME commandlinetools-linux-7583922_latest.zip
ENV ANDROID_API_LEVELS                  android-31
ENV ANDROID_BUILD_TOOLS_VERSION         31.0.0

ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH         ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/bin

RUN cd /usr/local/
RUN wget -q "https://dl.google.com/android/repository/${ANDROID_COMMAND_LINE_TOOLS_FILENAME}"
RUN unzip ${ANDROID_COMMAND_LINE_TOOLS_FILENAME} -d /usr/local/android-sdk-linux
RUN rm ${ANDROID_COMMAND_LINE_TOOLS_FILENAME}

RUN yes | sdkmanager --update --sdk_root="${ANDROID_HOME}"
RUN yes | sdkmanager --sdk_root="${ANDROID_HOME}" "platforms;${ANDROID_API_LEVELS}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "extras;google;m2repository" "extras;android;m2repository" "extras;google;google_play_services"

RUN update-java-alternatives -s java-1.8.0-openjdk-amd64
RUN yes | sdkmanager --licenses --sdk_root="${ANDROID_HOME}"
RUN update-java-alternatives -s java-1.11.0-openjdk-amd64

RUN rm -rf ${ANDROID_HOME}/tools

RUN docker/gradlewarmer/gradlew --version
