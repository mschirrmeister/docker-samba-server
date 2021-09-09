FROM alpine:3.14 AS build

ARG TARGETARCH

RUN apk add --no-cache openssl curl \
  && ARCH= && Arch="${TARGETARCH}" \
  && case "${Arch##*-}" in \
    amd64|x86_64) ARCH='amd64';; \
    aarch64|arm64|arm/v8) ARCH='aarch64';; \
    arm) ARCH='arm';; \
    armhf|arm/v7) ARCH='armhf';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  && curl -o /tmp/s6-overlay.tar.gz -fsSL --compressed https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-$ARCH.tar.gz

FROM alpine:3.14

ENV USERNAME samba
ENV PASSWORD password
ENV UID 1000
ENV GID 1000

RUN apk add --no-cache samba-server samba-common-tools openssl curl

COPY --chown=0:0 --from=build /tmp/s6-overlay.tar.gz /tmp/
RUN tar -xzf /tmp/s6-overlay.tar.gz -C /

COPY s6/config.init /etc/cont-init.d/00-config
COPY s6/smbd.run /etc/services.d/smbd/run
COPY s6/nmbd.run /etc/services.d/nmbd/run

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

ENTRYPOINT ["/init"]

