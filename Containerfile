FROM docker.io/tailscale/tailscale:latest AS BASE

FROM alpine:edge

COPY --from=BASE /usr/local/bin/* /usr/local/bin/

RUN set -x \
  \
  && apk add --no-cache \
    ca-certificates \
    iptables \
    iproute2 \
    ip6tables

ENTRYPOINT [ "/usr/local/bin/containerboot" ]