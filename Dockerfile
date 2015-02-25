FROM ubuntu:14.04
MAINTAINER Marc Bachmann <marc.brookman@gmail.com>

# Add repository & accept EULA for MS fonts
RUN \
  echo "deb http://archive.ubuntu.com/ubuntu trusty main multiverse" >> /etc/apt/sources.list && \
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

# Install dependencies
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 \
  libssl-dev libpng-dev libjpeg-dev git \
  ttf-mscorefonts-installer

# Build phantomjs
WORKDIR /tmp
ENV PHANTOMJS_VERSION 2.0
RUN git clone git://github.com/ariya/phantomjs.git

WORKDIR /tmp/phantomjs
RUN git checkout $PHANTOMJS_VERSION && ./build.sh --confirm && mv bin/phantomjs /usr/local/bin/phantomjs

# Clean up
WORKDIR /
RUN apt-get remove -y curl automake build-essential && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
