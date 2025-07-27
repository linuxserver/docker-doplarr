# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.22

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DOPLARR_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="nemchik"

RUN \
  echo "**** install runtime packages ****" && \
  if [ -z ${DOPLARR_RELEASE+x} ]; then \
    DOPLARR_RELEASE=$(curl -sX GET "https://api.github.com/repos/kiranshila/doplarr/releases/latest" \
    | jq -r .tag_name); \
  fi && \
  DOPLARR_VER=${DOPLARR_RELEASE#v} && \
  curl -o \
  /tmp/doplarr.jar -L \
    "https://github.com/kiranshila/doplarr/releases/download/v${DOPLARR_VER}/doplarr.jar" && \
  mkdir -p /app/doplarr/bin && \
  cp /tmp/doplarr.jar -d /app/doplarr/bin && \
  chmod +x /app/doplarr/bin/doplarr.jar && \
  apk add --no-cache \
    openjdk17-jre-headless && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    $HOME/.cache

# copy local files
COPY root/ /

# ports and volumes
VOLUME /config
