#!/bin/bash
# create new image from alpine linux mini fs image
# https://nl.alpinelinux.org/alpine/edge/releases/armhf/alpine-minirootfs-3.5.1-armhf.tar.gz
# https://nl.alpinelinux.org/alpine/v3.5/releases/x86_64/alpine-minirootfs-3.5.1-x86_64.tar.gz

function setTag(){
	TAG=$1
}

VALID_ARCHS=("x86" "x86_64" "aarch64" "armhf")
echo "${VALID_ARCHs[3]}"
function checkArch(){
	local valid=0
	for arch in "${VALID_ARCHS[@]}"
	do
		if [ "$1" == "${arch}" ]
		then
			valid=1
			ARCH=$1
		fi	
	done
	
	if [ ${valid} -ne 1 ]
	then
		printf "\nTarget Architecture $1 not supported.\n"
		printf "	*** Aborting Execution ***	\n"
		exit 1
	else
		if [ "$1" == "${VALID_ARCHS[3]}" ]
		then
			VERSION_MM="edge"
		fi

	fi
}

CONTAINER_NAME=alpine_base
ARCH="x86_64"
VERSION_MAJOR=3
VERSION_MINOR=5
VERSION_MM=v${VERSION_MAJOR}.${VERSION_MINOR}
VERSION_REVISION=1
VERSION=${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_REVISION} # e.g. "3.5.1"

if [ $# -eq 1 ] 
then
	setTag $1
elif [ $# -eq 2 ] 
then
	setTag $1
	checkArch $2
else 
	printf "\nNumber of parameters not supported.\n"
	printf	"Usage:\n"
	printf	"1. Argument (mandatory) - Image Tag\n"
	printf	"2. Argument (optional)	- Target Architecture (x86,x86_64,aarch64,armhf)\n"
	printf	"		*** Aborting Execution ***\n"
	exit 2
fi

#printf "\nDebug => https://nl.alpinelinux.org/alpine/${VERSION_MM}/releases/${ARCH}/alpine-minirootfs-${VERSION}-${ARCH}.tar.gz\n"

printf "\nDownloading Alpine Linux Image...\n"
CUR_DIR=$(pwd)
IMAGE=alpine-minirootfs-${VERSION}-${ARCH}.tar.gz
cd ${CUR_DIR}
wget https://nl.alpinelinux.org/alpine/${VERSION_MM}/releases/${ARCH}/alpine-minirootfs-${VERSION}-${ARCH}.tar.gz
chmod u+x ${CUR_DIR}/${IMAGE}

printf "\nDeleting previous image and all dependant containers..."
docker ps -a | awk '{ print $1,$2 }' | grep ${TAG} | awk '{print $1 }' | xargs -I {} docker rm {}
docker rmi ${TAG}

printf "\nCreating Docker Base Image from Alpine Linux v${VERSION} targeting ${ARCH}\n"
docker import alpine-minirootfs-${VERSION}-${ARCH}.tar.gz ${TAG}

printf "\nRunning container ${CONTAINER_NAME} from newly build image...\n"
docker run -d --name ${CONTAINER_NAME} ${TAG} /bin/sh

printf "\nCommitting changes to images ${TAG}...\n"
docker commit ${CONTAINER_NAME} ${TAG}:latest

printf "\nPushing newly created image ${TAG} into public repo...\n"
docker push ${TAG}
