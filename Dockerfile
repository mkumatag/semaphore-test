FROM alpine:3.7 as qemu

ARG QEMU_VERSION=2.9.1-1
ARG CROSS_ARCHS="aarch64 ppc64le"

RUN apk --update add curl

# Enable non-native runs on amd64 architecture hosts
RUN for i in ${CROSS_ARCHS}; do curl -L https://github.com/multiarch/qemu-user-static/releases/download/v${QEMU_VERSION}/qemu-${i}-static.tar.gz | tar zxvf - -C /usr/bin; done
RUN chmod +x /usr/bin/qemu-*

FROM arm64v8/golang:1.9.4-alpine3.7
MAINTAINER Trevor Tao <trevor.tao@arm.com>

# Enable non-native builds of this image on an amd64 hosts.
# This must be the first RUN command in this file!
COPY --from=qemu /usr/bin/qemu-*-static /usr/bin/


RUN apk add --no-cache su-exec curl bash git openssh mercurial make wget util-linux docker tini
RUN apk upgrade --no-cache
