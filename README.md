# Sourcebans Docker Image

[Docker Image](https://hub.docker.com/r/crinis/sourcebans) for [SourceBans++](https://github.com/sbpp/sourcebans-pp/)

## Getting Started

These instructions will cover usage information for the docker container 

### Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Quickstart

If you use [Docker Compose](https://docs.docker.com/compose/) there is an example [docker-compose.yml](docker-compose.yml) file you can use for fast setup.

Create a Docker network
```shell
docker network create sourcebans-db
```

Start a MariaDB container

```shell
docker run -d --volume sourcebans-mysql:/var/lib/mysql/ --network sourcebans-db \
    --env MYSQL_DATABASE=sourcebans --env MYSQL_USER=sourcebans --env MYSQL_PASSWORD=ThisShouldBeAStrongPassword --env MYSQL_ROOT_PASSWORD=ThisShouldBeAStrongPassword \
    --name sourcebans-mariadb mariadb:5
```

Start the Sourcebans container that is based on the official PHP Docker Image.

```shell
docker run -d -p 80:80 --volume sourcebans:/var/www/html/ --network sourcebans-db --name sourcebans crinis/sourcebans:latest
```

Connect to your Docker host on port 80 and go through the setup process at yourhost/install in your browser using your specified credentials for the MySQL container and `sourcebans-mariadb` if not otherwise specified as the database host.

After completing the installation steps you first need to stop the sourcebans container...

```shell
docker rm -f sourcebans
```
... and restart while setting the `REMOVE_SETUP_DIRS` environment variable to "true". This will remove your install/ and updater/ directories.

```shell
docker run -d -p 80:80 --volume sourcebans:/var/www/html/ --network sourcebans-db --env REMOVE_SETUP_DIRS=true --name sourcebans crinis/sourcebans:latest
```

Now visit Sourcebans in your browser.

#### Using Image Tags

Make sure to use version tagged images (e.g. `crinis/sourcebans:1.0.0`) as the `latest` tag might be changed without backwards compatibility.
[Available tags](https://github.com/crinis/sourcebans-docker/tags) 

#### Environment Variables

* `REMOVE_SETUP_DIRS` - Removes the install/ and updater/ directories. You have to set this to "true" after installing or updating your installation

#### Volumes

* `/var/www/html/` - Contains the Sourcebans installation

#### Useful File Locations

* `/usr/local/etc/php/conf.d/sourcebans.ini` - The Sourcebans specific PHP configuration that overrides defaults

#### Updating

You can either update the SourceBans sources manually as described [here](https://sbpp.dev/docs/updating/) or set the `UPDATE_SRC` environment variable to `true` which will update to the latest SourceBans++ version included in the release. This might override manual changes.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/crinis/sourcebans-docker/tags).

## Authors

* *Felix Spittel* - *Initial work* - [Crinis](https://github.com/crinis)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details. The image contains software that use different licenses.
