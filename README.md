# Sourcebans Docker Image

[Docker Image](https://hub.docker.com/r/crinis/sourcebans) for [SourceBans++](https://github.com/sbpp/sourcebans-pp/).

## Prerequisites

In order to run this container you'll need [Docker](https://docs.docker.com/get-started/get-docker/) or [Podman](https://podman.io/docs/installation) installed.

## Usage

### Installation

If you use [Docker Compose](https://docs.docker.com/compose/) there is an example [docker-compose.yml](docker-compose.yml) file you can use for a fast setup.

1. Copy `docker-compose.yml` and create an `.env` file next to it containing the database passwords:
   ```
   DB_PASSWORD=ThisShouldBeAStrongPassword
   DB_ROOT_PASSWORD=ThisShouldBeAnotherStrongPassword
   ```
2. Run `docker compose up -d`. SourceBans++ is copied into the volume automatically on first start.
3. Visit `http://localhost/install` (the host port mapped to container port 8080, port 80 in the example) and complete the web installer. Use `db` as the database host and the credentials from your `.env` file.
4. Run `docker compose restart web`. The restart removes the `install` and `updater` directories from the webroot.

### Image Tags

See all available image tags [here](https://hub.docker.com/r/crinis/sourcebans/tags).

There are various different types of tags you can use if you automate your deployment.
- Tags like `:sb-1.8.4` follow the tags of the Sourcebans repository. The image containing the latest Sourcebans release will be rebuilt with updated packages regularly. There is a slight chance that they might break at some point.
- Numbered tags like `:sb-5361142902` will only be built once and therefore won't break later on. They will never receive any changes.
- The [semver](https://semver.org/) tags, e.g. `:3.0.0` follow the release tags on this Github repository. The latest release will be rebuilt with updated packages regularly. But may ship outdated Sourcebans versions for a longer time.
- `latest` points to the latest tag on this Github repository.

### Environment Variables

* `INSTALL` - If set to `true` this force-copies Sourcebans into the `/var/www/html` directory, overwriting the directories `themes/default`, `updater`, `install`, `pages` and `includes` (your `config.php`, demos, uploads and custom themes are kept). Use it for a single start when updating, then set it back to `false`. **Always make a full backup before setting this to `true`!** When the webroot is empty (first start), Sourcebans is installed automatically regardless of this variable.
* `SET_OWNER` - If set to `true` (default) the ownership of the `/var/www/html` directory is recursively set to the webserver user and group on every start. This only works when the container starts as root.
* `SET_OWNER_UID` - UID that `/var/www/html` is chowned to when `SET_OWNER` is `true`. Defaults to `33` (`www-data` in the official PHP images).
* `SET_OWNER_GID` - GID that `/var/www/html` is chowned to when `SET_OWNER` is `true`. Defaults to `33`.

### Ports

The webserver inside the container listens on port **8080** (unprivileged, so the image also works rootless). Map any host port you like onto it, e.g. `-p 80:8080`, or rely on `docker run -P` to publish it automatically.

### Volumes

* `/var/www/html/` - Contains the Sourcebans installation including `config.php`, demos and uploads.

### Useful File Locations

* `/usr/local/etc/php/conf.d/sourcebans.ini` - The Sourcebans specific PHP configuration that overrides defaults

### Backups

Create a backup of both the webroot volume and the database before any update:

```sh
# Webroot (named volume "sourcebans" from the example compose file)
docker run --rm -v sourcebans:/var/www/html -v "$(pwd)":/backup debian:stable-slim \
    tar czf /backup/sourcebans-files.tar.gz -C /var/www/html .

# Database
docker compose exec db mariadb-dump -u root -p"$DB_ROOT_PASSWORD" sourcebans > sourcebans-db.sql
```

### Updating

**Always create a full backup of your installation before updating** (see [Backups](#backups)).

1. Pull the new image tag (`docker compose pull`).
2. Set the `INSTALL` environment variable to `true` and run `docker compose up -d`. This replaces the Sourcebans sources with the version shipped in the image.
3. If the new image contains a new Sourcebans version, visit `/updater` and run the database migration.
4. Set `INSTALL` back to `false` and run `docker compose up -d` again. This removes the `install` and `updater` directories.

Alternatively you can update the SourceBans sources manually as described [here](https://sbpp.dev/docs/updating/).

#### Migrating from the 1.7.0-era images (tags `2.x`, `:sb-1.7.0` and older)

Newer images ship SourceBans++ 1.8.x on PHP 8.3 (previously 1.7.0 on PHP 8.1, which is end-of-life). Your existing volume keeps running the old sources until you update them: follow the steps above, including the `/updater` run to migrate the database schema.

### Rootless

The image can be used fully rootless, e.g. with rootless Podman. The webserver binds port 8080 and never needs root; the entrypoint skips the ownership change when not running as root.

With Podman, run the container with your own user mapped into the user namespace so the volume stays writable:

```yaml
services:
  web:
    image: docker.io/crinis/sourcebans:latest
    user: ${UID:-1000}:${GID:-1000}
    userns_mode: keep-id
    volumes:
      - sourcebans:/var/www/html/:z
```

When running as a non-root user on a rootful Docker daemon (`docker run --user`), named volumes work out of the box: the webroot ships world-writable with a sticky bit, like the official PHP images. When bind-mounting a host directory instead, make sure it is writable by the container user.

## Authors

* *Initial work* - [Crinis](https://github.com/crinis)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details. The image contains software that use different licenses.
