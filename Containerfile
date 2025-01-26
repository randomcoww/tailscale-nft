FROM alpine:edge

RUN set -x \
  \
  && apk add --no-cache \
    tailscale \
    ca-certificates \
    iptables \
    iproute2 \
    ip6tables

ENTRYPOINT [ "/usr/local/bin/containerboot" ]