#!/bin/bash
#
# Configure broken host machine to run correctly
#
set -ex

XEBEC_IMAGE=${XEBEC_IMAGE:-xebecproject/xebecd}

distro=$1
shift

memtotal=$(grep ^MemTotal /proc/meminfo | awk '{print int($2/1024) }')

#
# Only do swap hack if needed
#
if [ $memtotal -lt 2048 -a $(swapon -s | wc -l) -lt 2 ]; then
    fallocate -l 2048M /swap || dd if=/dev/zero of=/swap bs=1M count=2048
    mkswap /swap
    grep -q "^/swap" /etc/fstab || echo "/swap swap swap defaults 0 0" >> /etc/fstab
    swapon -a
fi

free -m

if [ "$distro" = "trusty" -o "$distro" = "ubuntu:14.04" ]; then
    curl https://get.docker.io/gpg | apt-key add -
    echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list

    # Handle other parallel cloud init scripts that may lock the package database
    # TODO: Add timeout
    while ! apt-get update; do sleep 10; done

    while ! apt-get install -y lxc-docker; do sleep 10; done
fi

# Always clean-up, but fail successfully
docker kill xebecd-node 2>/dev/null || true
docker rm xebecd-node 2>/dev/null || true
stop docker-xebecd 2>/dev/null || true

# Always pull remote images to avoid caching issues
if [ -z "${XEBEC_IMAGE##*/*}" ]; then
    docker pull $XEBEC_IMAGE
fi

# Initialize the data container
docker volume create --name=xebecd-data
docker run -v xebecd-data:/xebec --rm $XEBEC_IMAGE xebec_init

# Start xebecd via upstart and docker
curl https://raw.githubusercontent.com/xebecproject/docker-xebecd/master/upstart.init > /etc/init/docker-xebecd.conf
start docker-xebecd

set +ex
echo "Resulting xebec.conf:"
docker run -v xebecd-data:/xebec --rm $XEBEC_IMAGE cat /xebec/.xebeccore/xebec.conf
