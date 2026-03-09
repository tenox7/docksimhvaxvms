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
    bash \
    iproute2 \
    procps \
    tigervnc-standalone-server \
    xfonts-base \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-scalable \
    xfonts-terminus \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /openvms

RUN ln -s /usr/lib/aarch64-linux-gnu/libpcap.so.1.10 /usr/lib/aarch64-linux-gnu/libpcap.so || \
    ln -s /usr/lib/x86_64-linux-gnu/libpcap.so.1.10 /usr/lib/x86_64-linux-gnu/libpcap.so || true && \
    mkdir -p /data /root/.vnc && \
    sh -c 'echo vncvms | vncpasswd -f > /root/.vnc/passwd' && \
    chmod 600 /root/.vnc/passwd

COPY --from=builder /build/simh/BIN/vax /openvms/vax
COPY vax.dsk.xz /openvms/
COPY ka655x.bin /openvms/
COPY nvram.bin /openvms/
COPY vax.ini /openvms/vax.ini
COPY entrypoint.sh /openvms/
COPY vnc.sh /openvms/
COPY dec/ /usr/share/fonts/X11/dec/

COPY --chmod=755 ps-wrapper.sh /usr/bin/ps-wrapper.sh
RUN chmod +x /openvms/entrypoint.sh /openvms/vnc.sh && \
    mv /usr/bin/ps /usr/bin/ps.real && \
    mv /usr/bin/ps-wrapper.sh /usr/bin/ps

ENV GEOMETRY=1280x1024

EXPOSE 23 21 513 514 177 5900

VOLUME ["/data"]

ENTRYPOINT ["/openvms/entrypoint.sh"]
