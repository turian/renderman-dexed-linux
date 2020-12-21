FROM ubuntu:16.04
ENV LANG C.UTF-8
LABEL maintainer="lastname@gmail.com"
LABEL version="0.1"
LABEL description="Dexed Renderman"

WORKDIR /root/

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update
RUN apt-get upgrade -y

# Some command line utils you probably want
RUN apt-get install -y sudo less bc screen tmux unzip vim wget

# Build tools
RUN apt-get install -y python3-pip git build-essential autoconf libtool pkg-config python3-dev python3-venv libboost-all-dev

# JUCE dependencies
RUN apt-get install -y llvm clang libfreetype6-dev libx11-dev libxinerama-dev libxrandr-dev libxcursor-dev mesa-common-dev libasound2-dev freeglut3-dev libxcomposite-dev libcurl4-gnutls-dev

# We have an X server for Dexed
RUN apt-get install -y xfce4 xfce4-goodies xfonts-base

# Audio tools
#RUN apt-get install -y bc ffmpeg sox opus-tools lame libsox-fmt-mp3 libasound2-dev graphviz python3-pip git screen  build-essential autoconf libtool pkg-config python3-dev libjack-dev unzip python3-venv nodejs npm nodejs-dev node-gyp libssl1.0-dev zlib1g-dev

RUN apt-get install -y mlocate && /usr/bin/updatedb

# remove unused files
RUN apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# Add non root user
RUN useradd -ms /bin/bash dexed && echo "dexed:dexed" | chpasswd && adduser dexed sudo
USER dexed
ENV HOME /home/dexed

#RUN jupyter nbextension enable --py widgetsnbextension
#RUN mkdir ~/.vst
#RUN cp /usr/lib/lxvst/helm.so ~/.vst/
#RUN rm -Rf ~/.helm/patches

RUN cd ~ && git clone -b update_midi_buffer https://github.com/jorshi/RenderMan.git
RUN cd ~/RenderMan/Builds/LinuxMakefile/ && make

#cd
#wget https://github.com/juce-framework/JUCE/releases/download/6.0.5/juce-6.0.5-linux.zip
#unzip juce-6.0.5-linux.zip

# Only on Ubuntu 18
#-fvisibility=default

RUN cd ~ && wget https://github.com/asb2m10/dexed/archive/v0.9.4hf1.tar.gz && tar zxvf v0.9.4hf1.tar.gz
RUN cd ~/dexed-0.9.4hf1/Builds/Linux/ && make
