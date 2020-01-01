Xebecd for Docker
================

[![Docker Stats](http://dockeri.co/image/xebecproject/xebecd)](https://hub.docker.com/r/xebecproject/xebecd/)

[![Build Status](https://travis-ci.org/xebecproject/docker-xebecd.svg?branch=master)](https://travis-ci.org/xebecproject/docker-xebecd/)


Docker image that runs the Xebec xebecd node in a container for easy deployment.


Requirements
------------

* Physical machine, cloud instance, or VPS that supports Docker (i.e. Vultr, Digital Ocean, KVM or XEN based VMs) running Ubuntu 14.04 or later (*not OpenVZ containers!*)
* At least 4 GB to store the block chain files
* At least 1 GB RAM + 2 GB swap file

Recommended and tested on Vultr 1024 MB RAM/320 GB disk instance @ $8/mo.  Vultr also *accepts Bitcoin payments*!  May run on the 512 MB instance, but took *forever* (1+ week) to initialize due to swap and disk thrashing.


Really Fast Quick Start
-----------------------

One liner for Ubuntu 14.04 LTS machines with JSON-RPC enabled on localhost and adds upstart init script:

    curl https://raw.githubusercontent.com/xebecproject/docker-xebecd/master/bootstrap-host.sh | sh -s trusty


Quick Start
-----------

1. Create a `xebecd-data` volume to persist the xebecd blockchain data, should exit immediately.  The `xebecd-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=xebecd-data
        docker run -v xebecd-data:/xebec --name=xebecd-node -d \
            -p 27270:27270 \
            -p 127.0.0.1:28280:28280 \
            xebecproject/xebecd

2. Verify that the container is running and  xebecd node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e10723sad        xebecproject/xebecd:latest          "xebec_oneshot"      2 seconds ago       Up 1 seconds        127.0.0.1:28280->28280/tcp, 0.0.0.0:27270->27270/tcp   xebecd-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f xebecd-node

4. Install optional init scripts for upstart and systemd are in the `init` directory.


Documentation
-------------

* To run in testnet, add environment variable `TESTNET=1` to `docker run` as such:

        docker run -v xebecd-data:/xebec --name=xebecd-node -d \
            --env TESTNET=1 \
            -p 27270:27270 \
            -p 127.0.0.1:28280:28280 \
            xebecproject/xebecd

* Additional documentation in the [docs folder](docs).

Credits
-------

Original work by Kyle Manna [https://github.com/kylemanna/docker-bitcoind](https://github.com/kylemanna/docker-bitcoind).
Modified to use Xebec Core instead of Bitcoin Core.

