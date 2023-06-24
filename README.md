# Sourcebans Docker Image

[Docker Image](https://hub.docker.com/r/crinis/sourcebans) for [SourceBans++](https://github.com/sbpp/sourcebans-pp/).

## Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

## Usage

### Installation

If you use [Docker Compose](https://docs.docker.com/compose/) there is an example [docker-compose.yml](docker-compose.yml) file you can use for fast setup. **Please pay attention to the `INSTALL` environment variable.**

1. Change settings including passwords in docker-compose.yml
2. Set environment variable `INSTALL` to true.
3. Run `docker-compose up`.
4. Visit https://example.org/install and enter your database and admin credentials.
5. Stop using `STRG+C` or `docker-compose down`.
6. Set environment variable `INSTALL` to false.
7. Run `docker-compose up` and visit your new Sourcebans installation.

### Image Tags

See all available image tags [here](https://hub.docker.com/r/crinis/sourcebans/tags). 

There are various different types of tags you can use if you automate your deployment.
- Tags like `:sb-1.7.0` follow the tags of the Sourcebans repository. They may be rebuild with updated packages at any time. There is a slight chance that they might break at some point.
- The `sb-dev` tag contains the latest build directly from the Sourcebans repository.
- Numbered tags like `:sb-5361142902` will only be build once and therefore won't break later on. They will never receive any changes.
- The [semver](https://semver.org/) tags, e.g. `:2.0.0` follow the tags on this Github repository. They may be rebuild with updated packages at any time. But may ship outdated Sourcebans versions for a longer time.
- `latest` points to the latest tag on this Github repository.

### Environment Variables

* `INSTALL` - If set to "true" this copies Sourcebans into the `/var/www/html` directory and may override your manual changes. This should be set on first install and can be enabled for a convenient update. **Always make a full backup before setting this to 'true'!**

### Volumes

* `/var/www/html/` - Contains the Sourcebans installation

### Useful File Locations

* `/usr/local/etc/php/conf.d/sourcebans.ini` - The Sourcebans specific PHP configuration that overrides defaults

### Updating

**Always create a full backup of your installation before updating.**

Change the Docker image tag and read below:

You can either update the SourceBans sources manually as described [here](https://sbpp.dev/docs/updating/) or set the `INSTALL` environment variable to `true` which will update to the latest SourceBans++ version included in the release. In case you made manual changes to any of the following directories they will be overriden.
- /var/www/html/themes/default
- /var/www/html/updater
- /var/www/html/install
- /var/www/html/pages
- /var/www/html/includes

### Rootless

The image can be used fully rootless. But up to and including Sourcebans release 1.7.0 you will not be able to login when exposing a non-standard port.

## Authors

* *Initial work* - [Crinis](https://github.com/crinis)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details. The image contains software that use different licenses.
