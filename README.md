# renderman-dexed-linux

Full instructions for using the RenderMan Python API for controlling
the Dexed FM synthesizer on Linux. 

If you would like to use OSX, the
[Spiegelib](https://spiegelib.github.io/spiegelib/getting_started/installation.html)
documentation is great.

## Ubuntu Setup

These instructions were tested on a fresh Ubuntu 18.04 box.
With Ubuntu 20.04, we had issues getting the headless xserver working.

As root:

```
./setup.sh
# Let's reboot so we get everything we dist-upgraded on
/sbin/shutdown -r now
```

Now, SSH in as `renderman`:

```
screen
startx
```

### Docker Instructions

Since Renderman is no longer maintained, it was easiest to build
this image using Ubuntu 16.04 with Python2.7 (gross, I know).
However, your base system can be any Linux flavor.

```
docker build -t renderman-dexed .

docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/home/docker/.Xauthority -it renderman-dexed bash
```
