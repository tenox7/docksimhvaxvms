#!/bin/bash
if [ "$1" = "-p" ] && [ "$2" = "0" ]; then
	exit 1
fi
exec /usr/bin/ps.real "$@"
