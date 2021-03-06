# renderman-dexed-linux

Full instructions for using the RenderMan Python API for controlling
the Dexed FM synthesizer on Linux. We use Dexed 0.9.4 since later
versions drop VST2 support. (This might not matter under Linux?)

If you would like to use OSX, the
[Spiegelib](https://spiegelib.github.io/spiegelib/getting_started/installation.html)
documentation is great.

Since Renderman is no longer maintained, it was easiest to build
our Docker image using Ubuntu 18.04 with Python2.7 (gross, I know).
If you have suggestions about how to build it under Python3, perhaps
using Projucer to create a new Makefile, great. Alternately,
you can consider exposing the API in Docker through a simple local
web-service.

## Initial Setup

In principle, your base system can be any Linux flavor.

We have been able to get initial setup to work on the following configurations:
* LambdaLabs cloud instances (Ubuntu 20.04 Focal).
* Ubuntu 18.04 (Bionic), on a Digital
Ocean droplet with only 1GB of memory.

With Ubuntu 20.04, we had issues getting the headless xserver
working, [described
here](https://stackoverflow.com/questions/65387635/couldnt-get-a-file-descriptor-referring-to-the-console-through-ssh-ubuntu-20).
If you have more luck, please submit a pull request.

Unfortunately, the Ubuntu 18.04 instructions used to work for Ubuntu
20.10 (Groovy), but no longer work.

### Ubuntu 18.04 (Bionic)

As root:
```
git clone https://github.com/turian/renderman-dexed-linux.git
cd renderman-dexed-linux
./setup.sh
# Let's reboot so we get everything we dist-upgraded on
/sbin/shutdown -r now
```

Log out and SSH back in as `ubuntu` user. Note that the `ubuntu`
user has no password, and uses the same SSH authorized keys as root.

Proceed to the section 'User Instructions'.

### LambdaLabs Ubuntu 20.04 (Focal)

SSH in, don't use the web console:

```
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt install -y docker.io xinit
sudo usermod -aG docker ${USER}
sudo perl -i -pe 's/allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config
```

Log out and SSH back in. Proceed to the section 'User Instructions'.

## User instructions

Now, SSH in as `ubuntu` user and run:
```
screen
```

In one screen, start Xorg:
```
startx
```

In other screen, run the docker:
```
docker pull turian/renderman-dexed
# Or, build the docker yourself
#docker build -t turian/renderman-dexed .

docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/home/renderman/.Xauthority -it turian/renderman-dexed bash
```

FYI, within the docker, renderman has sudo permissions with password
renderman.
```
cd ~
python example.py
ls -l example.wav
```

If everyone goes well, `example.wav` should exist and contain 441388 bytes.
