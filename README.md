# renderman-dexed-linux

Full instructions for using the RenderMan Python API for controlling
the Dexed FM synthesizer on Linux. 

If you would like to use OSX, the
[Spiegelib](https://spiegelib.github.io/spiegelib/getting_started/installation.html)
documentation is great.

## Ubuntu Setup

We provide instructions for setting up your environment on a fresh
Ubuntu box, however these steps could be adapted for other Linux
flavors. These instructions were test on a fresh Ubuntu 20.04 box:

```
apt-get update
apt-get install screen
# Optionally, update everything to the latest and reboot
apt-get dist-upgrade -y
/sbin/shutdown -r now

### Docker Instructions

Since Renderman is no longer maintained, it was easiest to build
this image using Ubuntu 16.04 with python2.7.

```
docker build -t dexed .

docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/home/docker/.Xauthority -it dexed bash
#docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/home/spooky/.Xauthority -v ~/wav2synth:/home/spooky/wav2synth -it registry.gitlab.com/turian/wav2synth bash
```

cd ~/RenderMan/Builds/LinuxMakefile/build/

