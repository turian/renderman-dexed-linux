# dexed-docker-ubuntu

Docker image for running Dexed Renderman on Ubuntu

## Instructions

```
docker build -t dexed .

docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/home/docker/.Xauthority -it dexed bash
#docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/home/spooky/.Xauthority -v ~/wav2synth:/home/spooky/wav2synth -it registry.gitlab.com/turian/wav2synth bash
```
