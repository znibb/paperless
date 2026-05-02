# docker-paperless <!-- omit from toc -->
Document management using paperless-ngx

This setup assumes that you're already running:
  - A [Traefik](https://github.com/znibb/docker-traefik) reverse-proxy
  - An [Authentik](https://github.com/znibb/docker-authentik) Identity Provider

## Table of contents <!-- omit from toc -->
- [1. Authentik setup](#1-authentik-setup)
- [Persistent storage setup](#persistent-storage-setup)
- [2. Docker setup](#2-docker-setup)
- [3. Application setup](#3-application-setup)
- [4. Maintenance](#4-maintenance)
  - [4.1. Update file names](#41-update-file-names)
  - [4.2. Change logo](#42-change-logo)

## 1. Authentik setup
See [Authentik](https://github.com/znibb/docker-authentik) repo

## Persistent storage setup
Separate storage for data and database is used and set in `.env`

Note for NFS mount usage:
DATA_DIR should use the same UID and GID for Mapall User and Group as in `.env` and DB_DIR should use 999:1001. The /mnt/pool/paperless entries should be owned by the same respective permissions.

Mount the NFS shares using `fstab`
- `truenas:/mnt/pool/paperless/data  /mnt/paperless/data nfs rw,nfsvers=3,hard,intr,noatime,_netdev,async 0 0`
- `truenas:/mnt/pool/paperless/db    /mnt/paperless/db   nfs rw,nfsvers=3,hard,intr,noatime,_netdev,async 0 0`

The directory structure under the `data` dir should be pre-allocated: `mkdir -p /mnt/paperless/data/{data,media,consume,export}

## 2. Docker setup
1. Initialize config by running init.sh: `./init.sh`
2. Input personal information into `.env`
3. Run `docker compose up` and check logs

## 3. Application setup
1. Go to `LOCAL_IP:8000` and log in with your superuser account
1. In the left menu under the `ADMINISTRATION` section go to `Users & Groups`
1. Create a group with basic permissions and name it e.g. `Basic`, needs at least `View` permission for `UISettings` to be able to access the service (suggested to give all permissions and remove `AppConfig`, `User`, `Group` and all but `View` for `UISettings`)
1. (Optionally) Create a group called `All` that has ALL permissions
1. Go to `https://paperless.DOMAIN.COM` and log in with your Authentik user

## 4. Maintenance
### 4.1. Update file names
If you change the `PAPERLESS_FILENAME_FORMAT` and want to update existing filenames to the new format run `docker compose exec paperless document_renamer`
### 4.2. Change logo
1. Go to `Configuration` and upload an icon using the `Application Logo` pane
2. Open `docker-compose.yml` and change the `PAPERLESS_APP_LOGO` environment variable to `/logo/FILENAME`