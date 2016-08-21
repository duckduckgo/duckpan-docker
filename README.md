duckpan-docker
==============

A Dockerfile for installing DuckPAN.


### Requirements

* docker >= 1.12


### Build/Pull Image

Pull from docker.io Hub, or build locally

```console
$ docker pull soleo/duckpan
```

```console
$ docker build -t soleo/duckpan .
```

### Run

```console
$ # Checkout your own fork. e.g.
$ cd ~/projects && git clone https://github.com/soleo/zeroclickinfo-spice.git
$ # Bash from container
$ docker run -ti -p 5000:5000 -v ~/projects/zeroclickinfo-spice:/home/ddg/zeroclickinfo-spice --rm soleo/duckpan bash
# cd /home/ddg/zeroclickinfo-spice && duckpan server
```

Start hacking and building new feature from there! You can visit ``localhost:5000`` to test your stuff now.




