docker-zoom
---

# Introduction

The repository provides a script and Docker image to run
[Zoom](https://zoom.us) on Linux.  It supports audio and video calls as well as
screen sharing.  It uses PulseAudio and X11.

# Installation

To build the image yourself run command:
```
docker build -t jakubstefanski/zoom:latest image
```

You can download a [wrapper
script](https://github.com/jakubstefanski/docker-zoom/blob/master/docker-zoom)
that is useful for starting Zoom in a container. It prepares correct
`docker run` parameters for the image.

```
sudo wget https://raw.githubusercontent.com/jakubstefanski/docker-zoom/master/docker-zoom -O /usr/local/bin/docker-zoom
sudo chmod +x /usr/local/bin/docker-zoom
```

# Usage

The simplest case is to run Zoom just as it would be installed locally:
```
docker-zoom
```

To isolate the container from your home directory you can override HOME
environment variable (must be absolute path):
```
HOME=~/zoom-home docker-zoom
```

To see what options are passed to `docker run` set verbose to true:
```
DZOOM_VERBOSE=true docker-zoom
```

You can also override `docker run` options:
```
DZOOM_OPTS='--interactive' docker-zoom
```
