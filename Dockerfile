FROM ubuntu:focal

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
  apt-get install -y curl software-properties-common

# GCC
ARG GCC_VERSION=11
RUN apt-add-repository -y ppa:ubuntu-toolchain-r/test && \
  apt-get update && \
  apt-get install -y g++-$GCC_VERSION g++-$GCC_VERSION-multilib make && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$GCC_VERSION $GCC_VERSION \
  --slave /usr/bin/g++ g++ /usr/bin/g++-$GCC_VERSION

WORKDIR /root

# Pin
ARG PIN_VERSION=3.23-98579-gb15ab7903
ARG PIN_SHA256=996090dfeec7dd58db1babbc3c95f8e4abfcb9b0e1014b02ffdbc09224bb48c0
RUN curl -fsSL https://software.intel.com/sites/landingpage/pintool/downloads/pin-$PIN_VERSION-gcc-linux.tar.gz -o pin-$PIN_VERSION-gcc-linux.tar.gz && \
  echo "${PIN_SHA256}  pin-$PIN_VERSION-gcc-linux.tar.gz" | sha256sum -c && \
  tar zxf pin-$PIN_VERSION-gcc-linux.tar.gz && \
  rm pin-$PIN_VERSION-gcc-linux.tar.gz && \
  ln -s pin-$PIN_VERSION-gcc-linux pin-gcc-linux

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
