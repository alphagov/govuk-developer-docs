---
title: Intro to Docker
section: Docker
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-01
review_in: 6 months
owner_slack: "#govuk-developers"
---

If you are new to Docker here's a quick intro in the context of the GOV.UK stack.

## Install Docker

*   Download Docker [https://www.docker.com/get-started](https://www.docker.com/get-started)
*   Docker for Mac intro [https://docs.docker.com/docker-for-mac/](https://docs.docker.com/docker-for-mac/)

## Video explaining the concepts in Docker

[https://www.youtube.com/watch?v=i7yoXqlg48M](https://www.youtube.com/watch?v=i7yoXqlg48M) - first 30 minutes

## Learn docker with content-publisher
This is a tutorial where we run a few things to get the [content-publisher] up and running in Docker. This is a convoluted example but it will help to explain and familiarise the concepts involved.

> Note: in the examples to run shell commands:
>
> * `$mac` shell prompt denotes running the command in a terminal on your Mac
> * `$dev` shell prompt denotes running the command in the docker container

### Run a container from an image

* Make sure you have docker running:

```shell
$mac docker --version
Docker version 18.09.2, build 6247962
```

* run from the root of the [content-publisher] project:

```shell
$mac cd ~/govuk/content-publisher
$mac docker run -it --rm ubuntu
```

##### What are the flags?

```shell
$mac docker run --help
...
-i, --interactive                    Keep STDIN open even if not attached
...
-t, --tty                            Allocate a pseudo-TTY
...
    --rm                             Automatically remove the container when it exits
```

#### What are Docker images and a container?
The `ubuntu` is the "image" that we specify. Using object oriented programming as an analogy, an image is like a "class". When we "instantiate" an instance of a class, these are called "containers".

Images are downloaded from the Docker Registry.

Another image is ruby:

```shell
$mac docker run -it --rm ruby:2.6.3 bash
```

Here we get a ruby image and specifying which version we want. The `bash` argument at the end is passed to the docker run command. It will execute this inside the container, which means we get a bash shell.

### Volumes

* Mount a volume by running:

```shell
$mac docker run -it --rm -v $(pwd):/app ruby:2.6.3 bash
```

This will map your current directory (being the root of the [content-publisher] project) to `/app` inside of the container.

* If you were to run bundle install for the app:

```shell
$dev cd /app
$dev bundle install
```

 The problem is that next time we spin up a container all of the gems would need re-installing.

#### Persistent volumes

Docker allows you create separate volumes for persistent data.

* Create a persistent volume for our gems:

```shell
$mac docker volume create content-publisher-bundle
```

*   Run docker with that volume:

```shell
$mac docker run -it --rm -v $(pwd):/app -v `content-publisher-bundle`:/usr/local/bundle ruby:2.6.3 bash
```

*   Then install the gems again:

```shell
$dev cd /app
$dev bundle install
```

This time the gems will install on the `content-publisher-bundle` which is mapped to the container at the `/usr/local/bundle` path.

### Specifying dependencies (node, PostgreSQL, Chrome)

* Try to run the tests:

```shell
$dev cd /app
$dev bundle exec rake
```

 We get an error about “could not find javascript runtime” because we don't have node installed.

#### Create ruby + node image

 We are going to create our own Docker image based off of the ruby one, and add in other dependencies such as node.

> Note: there will likely already be a Dockerfile, so just remove it for the tutorial.

*   Create a `Dockerfile` in the root of the [content-publisher] project:

```docker
FROM ruby:2.6.3

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash

RUN apt-get install nodejs && apt-get clean
```

*   Then run:

```shell
$mac docker build -t content-publisher
```

This creates an image based on the Dockerfile we just added.

`-t` tags, or names it, as `content-publisher`.

*   Now run a `content-publisher` container:

```shell
$mac docker run -it --rm -v $(pwd):/app -v content-publisher-bundle:/usr/local/bundle content-publisher bash
```

If we run the tests again, this time we see another problem about no database. That's because we haven't got PostgreSQL installed.

#### Use PostgreSQL image/container

*  In another terminal, if we run

```shell
$mac docker run -it --rm postgres
```

* Now to see what containers you have, run:

```shell
$mac docker ps
```

* Find the ID for the postgres container, and with it run:

```shell
$mac docker inspect [container ID for postgres]
```

Grab the IP address from the output. We will use that IP address to point the content-publisher container to the one running postgres. We'll need it so that rails knows where the database to run tests against.


*   Set these environment variables:

```shell
$dev export DATABASE_URL=postgres://postgres@172.17.0.3/content-publisher-dev
$dev export TEST_DATABASE_URL=postgres://postgres@172.17.0.3/content-publisher-test
```

> NOTE: The IP address will change randomly so you may need to update the IP address above each time you restart the container! See [Fixing IP with Docker Network]

*   Run the tests in content-publisher container:

```shell
$dev bundle exec rake db:setup
$dev bundle exec rake
```

We have a database, but no where for the database to store data!

*   Create a volume to persist to for the data:

```shell
$mac docker volume create content-publisher-postgres
```

* Restart the postgres container in your other terminal window/tab:

```shell
docker run -it --rm -v content-publisher-postgres:/var/lib/postgresql/data postgres
```

But we also need to specify a user to log into the database.

#### Create a database user

*   Add the `builder` user to Dockerfile:

```docker
RUN useradd -m builder
USER builder
```

* Re-build content-publisher container:

```shell
$mac docker build -t content-publisher
```

* Re-run docker with a new flag, `--privileged`, which gives the build user elevated permissions to run postgres:

```shell
$mac docker run -it --rm -v $(pwd):/app -v content-publisher-bundle:/usr/local/bundle --privileged content-publisher bash
```

#### Install Chrome for feature tests

Test will still be failing because we have one have another dependency for Chrome.

* Add the following to the Dockerfile:

```docker
RUN apt-get install -y libxss1 libappindicator1 libindicator7 && apt-get clean

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
```

* Then rebuild image and re-run the container:

```shell
$mac docker build -t content-publisher
$mac docker run -it --rm -v $(pwd):/app -v content-publisher-bundle:/usr/local/bundle --privileged content-publisher bash
```

* Run the tests again:

```shell
$dev cd /apps
$dev bundle exec rake
```

### Fixing IP with Docker Network

IP addresses will be randomly assigned each time the container starts up, which can be a pain when you want containers to talk to each other. As was the case between the [content-publisher] and PostgreSQL containers we've been using so far.

Docker has the notion of Networks which you can provide to each container as a connection that they can use.

* Create a network:

```shell
$mac docker network create content-publisher-network
```

* Run the containers with the new network:

```shell
$mac docker run -it --rm -v content-publisher-postgres:/var/lib/postgresql/data --network content-publisher-network --network-alias postgres postgres

$mac docker run -it --rm -v $PWD:/app -v content-publisher-bundle:/usr/local/bundle --privileged --network content-publisher-network -e TEST_DATABASE_URL=postgresql://postgres@postgres/content-publisher-test -e DATABASE_URL=postgresql://postgres@postgres/content-publisher-dev content-publisher:latest bash
```

### All in one line command

Run with cd-ing straight into /apps dir, with the `-w` flag:

```
docker run -it --rm -v $PWD:/app -v content-publisher-bundle:/usr/local/bundle --privileged --network content-publisher-network -e TEST_DATABASE_URL=postgresql://postgres@postgres/content-publisher-test -e DATABASE_URL=postgresql://postgres@postgres/content-publisher-dev -w /app content-publisher:latest bash
```

This is a lot to run in one command!

## Summary

In this tutorial you have been introduced to the concept of:

* the `docker run` command
* images (like a class)
* containers (like instances of a class)
* building images
* creating and adding volumes
* specifying dependencies with a Dockerfile
* creating a Network

These concepts are useful to know when you start to use [govuk-docker], which you should use from this point on with GOV.UK.

[content-publisher]: https://github.com/alphagov/content-publisher
[Fixing IP with Docker Network]: #fixing-ip-with-docker-network
[govuk-docker]: https://github.com/alphagov/govuk-docker
