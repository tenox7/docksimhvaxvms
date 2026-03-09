#!/bin/bash
set -x
FONTPATH="/usr/share/fonts/X11/dec/75dpi/,/usr/share/fonts/X11/dec/100dpi/,/usr/share/fonts/X11/dec/misc/,/usr/share/fonts/X11/dec/Type1/,/usr/share/fonts/X11/dec/Speedo/,/usr/share/fonts/X11/dec/decwin/75dpi/,/usr/share/fonts/X11/dec/decwin/100dpi/,/usr/share/fonts/X11/misc/,/usr/share/fonts/X11/75dpi/,/usr/share/fonts/X11/100dpi/,/usr/share/fonts/X11/Type1/"
while true; do
	if [ ! -f /tmp/.X0-lock ]; then
		rm -rf /tmp/.X11-unix/X0
		Xvnc :0 -geometry ${GEOMETRY} -depth 24 \
			-rfbauth /root/.vnc/passwd -rfbport 5900 \
			-fp ${FONTPATH} \
			-query 127.0.0.1 -ac
	fi
	sleep 10
done
