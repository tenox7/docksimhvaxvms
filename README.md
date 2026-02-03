# OpenVMS 7.3 on SIMH VAX - Docker Container

Running:

```sh
docker run -it --rm tenox7/openvms73:latest
```

Login as `system` password is `systempassword`.

To telnet/ftp/rlogin/rsh to the guest add `-p`, for example for telnet:

```sh
docker run -it --rm -p 23:23 tenox7/openvms73:latest
```

To forward X11 XDMCP Query add `-p 177:177`:

```sh
docker run -it --rm -p 23:23 -p 177:177 tenox7/openvms73:latest
```

**WARNING:** by default the guest is ephemeral, the state is NOT preserved once you exit from the container.

In order to persist the data disk mount `/data` as a volume or bind mount:


```sh
docker run -it --rm -v path:/data tenox7/openvms73:latest
```

The disk image and nvram is stored in `/data` in the container. 

