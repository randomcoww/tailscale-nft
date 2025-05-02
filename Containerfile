# https://github.com/tailscale/tailscale/blob/main/Dockerfile

FROM golang:1.24-alpine AS build-env
ARG VERSION_LONG

RUN set -x \
  && apk add --no-cache \
    git \
  && git clone --depth 1 -b v$VERSION_LONG https://github.com/tailscale/tailscale.git /go/src/tailscale

WORKDIR /go/src/tailscale

RUN go mod download

# Pre-build some stuff before the following COPY line invalidates the Docker cache.
RUN go install \
  github.com/aws/aws-sdk-go-v2/aws \
  github.com/aws/aws-sdk-go-v2/config \
  gvisor.dev/gvisor/pkg/tcpip/adapters/gonet \
  gvisor.dev/gvisor/pkg/tcpip/stack \
  golang.org/x/crypto/ssh \
  golang.org/x/crypto/acme \
  github.com/coder/websocket \
  github.com/mdlayher/netlink

# see build_docker.sh
ARG VERSION_LONG=""
ENV VERSION_LONG=$VERSION_LONG
ARG VERSION_SHORT=""
ENV VERSION_SHORT=$VERSION_SHORT
ARG VERSION_GIT_HASH=""
ENV VERSION_GIT_HASH=$VERSION_GIT_HASH
ARG TARGETARCH

RUN GOARCH=$TARGETARCH go install -ldflags="\
  -X tailscale.com/version.longStamp=$VERSION_LONG \
  -X tailscale.com/version.shortStamp=$VERSION_SHORT \
  -X tailscale.com/version.gitCommitStamp=$VERSION_GIT_HASH" \
  -v ./cmd/tailscale ./cmd/tailscaled ./cmd/containerboot

FROM alpine:edge

COPY --from=build-env /go/bin/* /usr/local/bin/

RUN set -x \
  \
  && apk add --no-cache \
    ca-certificates \
    iptables \
    iproute2 \
    ip6tables

ENTRYPOINT [ "/usr/local/bin/containerboot" ]