# Android development environment for ubuntu.
# version 0.0.5

FROM ubuntu:17.04

MAINTAINER Rohith Ravindran <tr.rohith@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# Update packages
RUN apt-get -y update && \
    apt-get -y install software-properties-common bzip2 ssh net-tools socat curl git && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update

# Install JDK 8
RUN add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    apt-get -y install oracle-java8-installer

# Clean up Apt-get
RUN rm -rf /var/lib/apt/lists/*

# Copy install tools
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# Install android sdk
RUN wget -qO- http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | \
    tar xvz -C /usr/local/ && \
    mv /usr/local/android-sdk-linux /usr/local/android-sdk && \
    chown -R root:root /usr/local/android-sdk/

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install latest android tools and system images
RUN ( sleep 4 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk --no-ui --force -a --filter \
    platform-tool,android-22,android-23,build-tools-23.0.2,build-tools-23.0.3,sys-img-armeabi-v7a-android-22,extra-android-m2repository,extra-google-m2repository && \
    echo "y" | android update adb

# Create fake keymap file
RUN mkdir /usr/local/android-sdk/tools/keymaps && \
    touch /usr/local/android-sdk/tools/keymaps/en-us

# Create emulator
RUN echo "no" | android create avd -f -n emu-lollipop -t android-22 --abi default/armeabi-v7a

# To run 32 bit SDK on 64 bit Ubuntu, install following libs
RUN apt-get update && \
    apt-get -y install lib32stdc++6 lib32z1

# Cleaning
# RUN apt-get clean

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
