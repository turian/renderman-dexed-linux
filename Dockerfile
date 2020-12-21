FROM ubuntu:16.04
ENV LANG C.UTF-8
LABEL maintainer="lastname@gmail.com"
LABEL version="0.1"
LABEL description="RenderMan Python API for controlling the Dexed FM synthesizer"

WORKDIR /root/

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update
RUN apt-get upgrade -y

# Some command line utils you probably want
RUN apt-get install -y sudo less bc screen tmux unzip vim wget

# Build tools
RUN apt-get install -y python-pip git build-essential autoconf libtool pkg-config libboost-all-dev apt-utils python-numpy

# JUCE dependencies
RUN apt-get install -y llvm clang libfreetype6-dev libx11-dev libxinerama-dev libxrandr-dev libxcursor-dev mesa-common-dev libasound2-dev freeglut3-dev libxcomposite-dev libcurl4-gnutls-dev

# We have an X server for Dexed
RUN apt-get install -y xfce4 xfce4-goodies xfonts-base

# Audio tools
RUN apt-get install -y libsndfile-dev

RUN apt-get install -y mlocate && /usr/bin/updatedb

# remove unused files
RUN apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# Add non root user
RUN useradd -ms /bin/bash renderman && echo "renderman:renderman" | chpasswd && adduser renderman sudo
USER renderman
ENV HOME /home/renderman

RUN pip install soundfile

# Build the branch of renderman recommended here:
# https://spiegelib.github.io/spiegelib/getting_started/installation.html
RUN cd ~ && git clone -b update_midi_buffer https://github.com/jorshi/RenderMan.git
# On Ubuntu 18 you have to edit the makefile to include
#    -fvisibility=default
# Instead, we just use Ubuntu 16.04 for this Dockerfile
RUN cd ~/RenderMan/Builds/LinuxMakefile/ && make && mv build/librenderman.so ~
RUN rm -Rf ~/RenderMan/


RUN cd ~ && wget https://github.com/asb2m10/dexed/archive/v0.9.4hf1.tar.gz && tar zxvf v0.9.4hf1.tar.gz
RUN cd ~/dexed-0.9.4hf1/Builds/Linux/ && make && mv build/Dexed.so ~
RUN rm -Rf ~/dexed-0.9.4hf1/ ~/v0.9.4hf1.tar.gz
