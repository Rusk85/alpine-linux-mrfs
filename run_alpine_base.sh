#!/bin/bash
IMAGE_NAME=$1

docker run -ti -u root ${IMAGE_NAME} /bin/sh
