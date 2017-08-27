# SourceBans++

A [Docker image](https://hub.docker.com/r/crinis/sourcebans/) for running SourceBans++ in a Docker container.

## Getting Started
These instructions will help you to get a containerized installation of SourceBans++ running. This includes a web interface and a database with phpMyAdmin. I recommend to use fixed tags of my Docker images as the latest tag is subject to change.

### Prerequisites
You need a working installation of Docker and Docker compose to follow the installation instructions.

[Install Docker](https://docs.docker.com/engine/installation/)

[Install Docker Compose](https://docs.docker.com/compose/install/)

### Installing
For a basic setup use my pre-configured [docker-compose.yml](docker-compose.yml). Make sure to change all passwords before running this in production.

Run the following command in the same folder as the docker-compose.yml file to get the containers running.
```
docker-compose up
```
Now you should have your SourceBans++ web interface running at port 80 and an instance of phpMyAdmin at port 8080.

Visit the SourceBans++ web interface at yourdomain.tld/install/ and follow the installation instructions.

After you have finished the installation process set the environment variable "INSTALL" of the "web" service to false. This will automatically delete the install/ and updater/ folders the next time you start the containers. Now run
```
docker-compose up
```
again.

Install the appropriate [SourceBans++](https://github.com/sbpp/sourcebans-pp/) plugins working for your type of gameserver.

## Versioning
I use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/crinis/hlxce-docker/tags). 

## License
This project is licensed under the GPLv3 License - see the [LICENSE.md](LICENSE.md) file for details