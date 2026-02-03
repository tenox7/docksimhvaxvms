#!/bin/sh

DISK_COMPRESSED="/openvms/vax.dsk.xz"
DISK_RUNTIME="/data/vax.dsk"

if [ ! -f "$DISK_RUNTIME" ]; then
    echo "Decompressing disk image ..."
    xz -dc "$DISK_COMPRESSED" > "$DISK_RUNTIME"
    echo "Done. Use -v ...:/data to persist changes."
else
    echo "Using existing disk image"
fi

NVRAM_SOURCE="/openvms/nvram.bin"
NVRAM_RUNTIME="/data/nvram.bin"

if [ ! -f "$NVRAM_RUNTIME" ]; then
    cp "$NVRAM_SOURCE" "$NVRAM_RUNTIME"
fi

cd /data
exec /openvms/vax /openvms/vax.ini
