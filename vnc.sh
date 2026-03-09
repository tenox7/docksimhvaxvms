#!/bin/bash
set -x
while true; do
	if [ ! -f /tmp/.X0-lock ]; then
		rm -rf /tmp/.X11-unix/X0
		Xvnc :0 -geometry ${GEOMETRY} -depth 24 \
			-rfbauth /root/.vnc/passwd -rfbport 5900 \
			-query 127.0.0.1 -ac
	fi
	sleep 10
done
