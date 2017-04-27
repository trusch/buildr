FROM debian:stretch

# Install base: gcc, golang, nodejs + build utils (gpg, pass, make, curl...)
RUN apt-get update && apt-get install -y make gcc g++ automake curl unzip xz-utils ca-certificates apt-transport-https gnupg2 pass
RUN curl -o /opt/go1.8.1.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz
RUN cd /opt && tar xfvz go1.8.1.linux-amd64.tar.gz
RUN curl -o /opt/node-v7.9.0-linux-x64.tar.xz https://nodejs.org/dist/v7.9.0/node-v7.9.0-linux-x64.tar.xz
RUN cd /opt && tar xfvJ node-v7.9.0-linux-x64.tar.xz && mv node-v7.9.0-linux-x64 nodejs

ENV GOROOT /opt/go
ENV GOPATH /go

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Install armhf gcc cross compiler + libboost
RUN apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
RUN dpkg --add-architecture armhf && apt-get update
RUN apt-get install -y libboost-system-dev libboost-system-dev:armhf

# Install acbuild
RUN curl -L -o /opt/acbuild-v0.4.0.tar.gz https://github.com/containers/build/releases/download/v0.4.0/acbuild-v0.4.0.tar.gz
RUN cd /opt && tar xfvz acbuild-v0.4.0.tar.gz && mv acbuild-v0.4.0 acbuild

ENV PATH /opt/nodejs/bin:/opt/go/bin:/opt/acbuild:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
