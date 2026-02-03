FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libpcap-dev \
    libedit-dev \
    libpng-dev \
    libsdl2-dev \
    libvdeplug-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone https://github.com/simh/simh.git && \
    cd simh && \
    make vax

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    libpcap0.8 \
    xz-utils \
    libedit2 \
    libpng16-16 \
    libsdl2-2.0-0 \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /openvms

RUN ln -s /usr/lib/aarch64-linux-gnu/libpcap.so.1.10 /usr/lib/aarch64-linux-gnu/libpcap.so || \
    ln -s /usr/lib/x86_64-linux-gnu/libpcap.so.1.10 /usr/lib/x86_64-linux-gnu/libpcap.so || true && \
    mkdir -p /data

COPY --from=builder /build/simh/BIN/vax /openvms/vax
COPY vax.dsk.xz /openvms/
COPY ka655x.bin /openvms/
COPY nvram.bin /openvms/
COPY vax.ini /openvms/vax.ini
COPY entrypoint.sh /openvms/

RUN chmod +x /openvms/entrypoint.sh

EXPOSE 23 21 513 514 177

VOLUME ["/data"]

ENTRYPOINT ["/openvms/entrypoint.sh"]
