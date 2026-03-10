#!/bin/sh

docker run -it --rm \
    -e GEOMETRY=1920x1200 \
    -p 23:23 \
    -p 21:21 \
    -p 69:69 \
    -p 513:513 \
    -p 514:514 \
    -p 177:177 \
    -p 5900:5900 \
    --name docksimhvaxvms \
    tenox7/openvms73:latest

    #-v ./data:/data \
    #-v /Volumes/tmp/VMS:/vms \
