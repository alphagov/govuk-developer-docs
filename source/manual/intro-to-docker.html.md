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

*   [Download Docker](https://www.docker.com/get-started)
*   [Docker for Mac intro](https://docs.docker.com/docker-for-mac/)

## Video explaining the concepts in Docker

[Docker, FROM scratch - Aaron Powell](https://www.youtube.com/watch?v=i7yoXqlg48M) - first 30 minutes

## Learn docker with content-publisher
This is a tutorial where we run a few things to get [content-publisher] up and running in Docker. This is a convoluted example but it will help to explain and familiarise the concepts involved.

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

#### What are Docker images and a container?

* Run from the root of the [content-publisher] project:

```shell
$mac docker run -it --rm ruby:2.6.3 bash
```

`ruby` is the "image" that we specify. Using object oriented programming as an analogy, an image is like a "class". When we "instantiate" an instance of a class, these are called "containers".

The `ruby` image we are using is an ubuntu system with Ruby pre-installed. Images are downloaded from the Docker Registry. We are also specifying that we want the image that provides Ruby 2.6.3.

The `bash` argument at the end is passed to the docker run command. It will execute this inside the container, which means we get a bash shell.

What are the flags?

```shell
$mac docker run --help
...
-i, --interactive                    Keep STDIN open even if not attached
...
-t, --tty                            Allocate a pseudo-TTY
...
    --rm                             Automatically remove the container when it exits
```

### Volumes

* Mount your current directory as a volume to the container by running:

```shell
$mac docker run -it --rm -v $(pwd):/app ruby:2.6.3 bash
```

This will map your current directory (the root of the [content-publisher] project) to `/app` inside of the container. So now the files on your `$mac` for the [content-publisher] are now also available inside of the container.

* If you were to run bundle install for the app:

```shell
$dev cd /app
$dev bundle install
```

You can see that the gems required for content-publisher are installed! However, anything you do here won't persist - if you were to quit the container and then go back in exactly the same way, all the gems would need to be re-installed again.

By default gems are saved to `/usr/local/bundle` within the container. But everything in the container is destroyed and reset to the image when it's shut down.

We could mount that path to the same on your `$mac` but there is a Docker way of providing storage.

#### Persistent volumes

We don't want to be re-installing and doing setup every time we quit and re-enter a container. Docker allows you to create separate volumes for persistent data.

* Create a persistent volume for our gems:

```shell
$mac docker volume create content-publisher-bundle
```

*   Run docker with that volume by using the `-v` flag and passing it the name of the volume:

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

Now we have our gems installed, we can try and run the content-publisher tests:

```shell
$dev cd /app
$dev bundle exec rake
```

We get an error: “could not find javascript runtime” - we need Node installed on our container. We can follow standard commands to install Node, but this won't persist and we'll have the same problem that we had above with installing gems.

It seems like our Ruby image isn’t doing quite what we need, so we’re going to create our own image based off it.

#### Create ruby + node image

 We are going to create our own Docker image based off of the ruby one, and add in other dependencies such as node.

To create our own image, we need a Dockerfile. A Dockerfile normally starts with a `FROM [image]` which bases your new image off an existing image. We can then execute other commands by prefixing them with `RUN`. Each RUN command adds a new layer. You can think of it as each step creating a new image, but we only care about the final image to come out of the last step.
Create a Dockerfile in the content-publisher project:

> Note: there will likely already be a Dockerfile, so just remove it for the tutorial.

*   Create a `Dockerfile` in the root of the [content-publisher] project:

```docker
FROM ruby:2.6.3

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash

RUN apt-get install nodejs && apt-get clean
```

*   Build our new image:

```shell
$mac docker build -t content-publisher
```

This creates an image based on the Dockerfile we just added.

`-t` tags, or names it, as `content-publisher`.

*   Now we can start a container with our new image:

```shell
$mac docker run -it --rm -v $(pwd):/app -v content-publisher-bundle:/usr/local/bundle content-publisher bash
```

Each time you change the Dockerfile, you need to remember to rebuild the docker image.

If we run the tests again, this time we see another problem about no database. That's because we haven't got PostgreSQL installed.

#### Use PostgreSQL image/container

Docker containers are quick to start and it's possible for them to talk to each other, so let's set up a separate container for postgres.

*  In another terminal, if we run the following to start a new container based on the postgres image:

```shell
$mac docker run -it --rm postgres
```

* Now to see what containers you have, run:

```shell
$mac docker ps
```

And you should see (ignore any other containers you've got running):

```shell
$mac
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
a7b87be3e1bc        postgres            "docker-entrypoint.s…"   21 minutes ago      Up 21 minutes       5432/tcp            jovial_matsumoto
```

* Find the ID for the postgres container, and with it run:

```shell
$mac docker inspect [container ID for postgres]
```

Grab the IP address from the output. We will use that IP address to point the content-publisher container to the one running postgres. Rails will use this to run its tests against.


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

We have a database, but nowhere for the database to store data!

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

Combining all of the above into a single line to execute:

```
docker run -it --rm -v $PWD:/app -v content-publisher-bundle:/usr/local/bundle --privileged --network content-publisher-network -e TEST_DATABASE_URL=postgresql://postgres@postgres/content-publisher-test -e DATABASE_URL=postgresql://postgres@postgres/content-publisher-dev -w /app content-publisher:latest bash
```

This is a lot to run in one command!

Luckily, we can convert this long command into some YAML configuration which defines all the volumes and dependencies. We can then run that YAML file use [docker-compose](https://docs.docker.com/compose/), for example:

`docker-compose run —rm content-publisher bundle exec rake`

We can even run the above command as a CLI script to make it shorter and more reusable between our repos. This is what [govuk-docker][govuk-docker] does.

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
