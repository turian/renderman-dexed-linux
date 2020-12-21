# renderman-dexed-linux

Full instructions for using the RenderMan Python API for controlling
the Dexed FM synthesizer on Linux. 

If you would like to use OSX, the
[Spiegelib](https://spiegelib.github.io/spiegelib/getting_started/installation.html)
documentation is great.

Since Renderman is no longer maintained, it was easiest to build
our Docker image using Ubuntu 16.04 with Python2.7 (gross, I know).
If you have suggestions about how to build it under Python3, perhaps
using Projucer to create a new Makefile, great. Alternately,
you can consider exposing the API in Docker through a simple local
web-service.

## Host Setup

In principle, you base system can be any Linux flavor. We provide
scripts for Ubuntu 18.04 that set up docker and a headless xserver.

With Ubuntu 20.04, we had issues getting the headless xserver
working. If you have more luck, please submit a pull request.

As root:
```
git clone https://github.com/turian/renderman-dexed-linux.git
cd renderman-dexed-linux
./setup.sh
# Let's reboot so we get everything we dist-upgraded on
/sbin/shutdown -r now
```

Now, SSH in as `renderman`:
```
screen
# In one screen, start Xorg
startx
```
Note that the host renderman user has no password, and uses the
same SSH authorized keys as root.

## Docker Instructions

In other screen, run the docker

```
docker pull turian/renderman-dexed
# Or, build the docker yourself
#docker build -t renderman-dexed .

docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/home/renderman/.Xauthority -it turian/renderman-dexed bash
```

FYI, the username is also renderman within the docker. Within the docker,
renderman has sudo permissions with password renderman.
```
cd ~
python example.py
ls -l example.wav
```

If everyone goes well, `example.wav` should exist and contain 441388 bytes.
