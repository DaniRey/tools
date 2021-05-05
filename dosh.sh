#!/bin/bash
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "1 argument required, $# provided"

containerId=`docker container ls -f name=$1 --format "{{.ID}}"`
containerName=`docker container ls -f name=$1 --format "{{.Names}}"`
matchingContainerCount=$(echo "${containerId}" | wc -l) 

if [ -z "$containerId" ]; then
	echo "No container matches given container name: $1"
	echo "Use one of the following"
	echo `docker container ls --format "{{.Names}}"`
elif [ "$matchingContainerCount" -gt "1" ]; then
	echo "Multiple containers match the given container name: $1"
	echo "Use one of the following"
	echo `docker container ls -f name=$1 --format "{{.Names}}"`
else
	echo "Opening shell on container: $containerName"
	docker exec -ti $containerId /bin/sh
fi

