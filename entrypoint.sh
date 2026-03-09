#!/bin/bash

DISK_COMPRESSED="/openvms/vax.dsk.xz"
DISK_RUNTIME="/data/vax.dsk"

if [ ! -f "$DISK_RUNTIME" ]; then
    echo "Decompressing disk image... (Mount volume or path -v ...:/data to persist changes)"
    xz -vdc "$DISK_COMPRESSED" > "$DISK_RUNTIME"
    echo "Done..."
    echo "============================================"
    echo "Default login: system password: systempassword"
    echo "VNC password: vncvms"
    echo "============================================"
else
    echo "Using existing disk image"
fi

NVRAM_SOURCE="/openvms/nvram.bin"
NVRAM_RUNTIME="/data/nvram.bin"

if [ ! -f "$NVRAM_RUNTIME" ]; then
    cp "$NVRAM_SOURCE" "$NVRAM_RUNTIME"
fi

cd /data
/openvms/vnc.sh >/dev/null 2>&1 &
exec /openvms/vax /openvms/vax.ini
