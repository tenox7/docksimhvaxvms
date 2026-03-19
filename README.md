# OpenVMS 7.3 on SIMH VAX - Docker Container with DEC Windows via VNC

https://hub.docker.com/r/tenox7/openvms73

![VMSX11](vmsxdcmp.png)

## Running

```sh
docker run -it --rm tenox7/openvms73:latest
```

Login as `system` password is `systempassword`.


## Telnet 

To telnet/ftp/rlogin/rsh to the guest add `-p`, for example for telnet:

```sh
docker run -it --rm -p 23:23 tenox7/openvms73:latest
```

## VNC to DEC Windows

Conveniently this container now contains a VNC Server with X11 XDMCP Query. You can just VNC in to the container! The password is `vncvms`.  On MacOS you can simply `open vnc://127.0.0.1`.

```sh
docker run -it --rm -p 5900:5900 tenox7/openvms73:latest
```

Change resolution: `-e GEOMETRY=1920x1200`

## X11

To forward X11 XDMCP Query add `-p 177:177/udp`:

```sh
docker run -it --rm -p 23:23 -p 177:177/udp tenox7/openvms73:latest
```

*I was not able to connect to it unless the client display is `:0`. In particular `Xnest -ac -query :1` did not work for me. Only `:0` does. If you know how to fix it, LMK.*


## Persistent State

**WARNING:** by default the guest is ephemeral, the state is NOT preserved once you exit from the container.

In order to persist the data disk mount `/data` as a volume or bind mount:


```sh
docker run -it --rm -v path:/data tenox7/openvms73:latest
```

The disk image and nvram is stored in `/data` in the container. 

## Quiting

Ctrl^E in the terminal will shut down SIMH.
