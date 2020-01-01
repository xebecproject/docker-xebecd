# Debugging

## Things to Check

* RAM utilization -- xebecd is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The xebec blockchain will continue growing and growing and growing.  Then it will grow some more.  At the time of writing, 2GB+ is necessary.

## Viewing xebecd Logs

    docker logs xebecd-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the xebecd node, but will not connect to already running containers or processes.

    docker run -v xebecd-data:/xebec --rm -it xebecproject/xebecd bash -l

You can also attach bash into running container to debug running xebecd

    docker exec -it xebecd-node bash -l


