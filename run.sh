#!/bin/sh

docker run -it --rm \
    -p 23:23 \
    -p 21:21 \
    -p 513:513 \
    -p 514:514 \
    -p 177:177 \
    tenox7/openvms73:latest
