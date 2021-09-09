# Samba Server Container

[![Docker Pulls](https://img.shields.io/docker/pulls/mschirrmeister/samba-server.svg)](https://hub.docker.com/r/mschirrmeister/samba-server/)
[![Docker Stars](https://img.shields.io/docker/stars/mschirrmeister/samba-server.svg)](https://hub.docker.com/r/mschirrmeister/samba-server/)
[![Docker Build Status](https://github.com/mschirrmeister/docker-samba-server/actions/workflows/build.yml/badge.svg)](https://github.com/mschirrmeister/docker-samba-server/actions)

[Samba 4](https://www.samba.org/) server running under [s6 overlay](https://github.com/just-containers/s6-overlay) on [Alpine Linux](https://hub.docker.com/_/alpine/). Runs both `smbd` and `nmbd` services.

## Configuration

See [example directory](https://github.com/mschirrmeister/docker-samba-server/tree/master/example) for sample config file.

## Quickstart

Docker manual example:

    docker run -it --rm \
      --name samba-server \
      -p 139:139 \
      -p 445:445 \
      -e USERNAME=username \
      -e PASSWORD=password \
      -v /opt/docker/etc/samba/smb.conf:/etc/samba/smb.conf \
      --mount type=bind,source=/mnt/movies,target=/mnt/movies,bind-propagation=rshared \
      mschirrmeister/samba-server

Docker compose example:

```yml
samba:
  image: mschirrmeister/samba-server

  volumes:
    # You must provide a Samba config file
    - ./smb.conf:/etc/samba/smb.conf

    # Shares
    - ~/projects:/mnt/projects
    - ~/videos:/mnt/videos:ro

  ports:
    - "137:137/udp"
    - "138:138/udp"
    - "139:139/tcp"
    - "445:445/tcp"

  environment:
    - USERNAME=username
    - PASSWORD=password
```
