---
owner_slack: "#govuk-dev-tools"
title: Intro to GOV.UK Docker
section: Docker
layout: manual_layout
type: learn
parent: "/manual.html"
---

We use [govuk-docker] to help us develop stuff on GOV.UK. If you're new to Docker, this will provide useful insights into how we use it in the context of the GOV.UK stack.

We're going to be doing stuff from first-principles, so what follows is a bit convoluted but it will help to explain and familiarise the concepts involved.

Before you start, make sure you:

* [Download Docker](https://www.docker.com/get-started)
* [Clone the content-publisher repo][content-publisher]
* [Take a quick look at the Docker for Mac intro](https://docs.docker.com/docker-for-mac/)
* [Take a look at this video: Docker, FROM scratch](https://www.youtube.com/watch?v=i7yoXqlg48M) - first 30 minutes

> Note: in the examples to run shell commands:
>
> * `$mac` shell prompt denotes running the command in a terminal on your Mac
> * `$dev` shell prompt denotes running the command in the docker container

## Step 1: Docker "run"

* Make sure you have docker running:

```shell
$mac docker --version
Docker version 18.09.2, build 6247962
```

### Images and containers

* Run from the root of the [content-publisher] project:

```shell
$mac docker run -it ruby:2.6.3 bash
```

`ruby:2.6.3` is the "image" that we specify. Using object oriented programming as an analogy, an image is like a "class". When we "instantiate" an instance of a class, these are called "containers".

The `ruby:2.6.3` image we are using is a debian system with Ruby pre-installed. Images are downloaded from the [Docker Registry][docker-registry]. The `bash` argument at the end will execute this inside the container, which means we get a bash shell.

What are the flags?

```shell
$mac docker run --help
...
-i, --interactive                    Keep STDIN open even if not attached
...
-t, --tty                            Allocate a pseudo-TTY
```

## Step 2: Volumes

* Mount your current directory as a volume to the container by running:

```shell
$mac docker run -it -v $(pwd):/app ruby:2.6.3 bash
```

This will map your current directory (the root of the [content-publisher] project) to `/app` inside of the container. So now the files on your `$mac` for [content-publisher] are now also available inside of the container.

* If you were to run bundle install for the app:

```shell
$dev cd /app
$dev bundle install
```

> Note: you may need to use a different image (e.g. `ruby:2.6.5`) depending on the version specified in [`.ruby-version`][content-publisher-ruby] in [content-publisher].
>
> Note: this may take a while, so feel free to stop it by pressing Ctrl+c as the next step will show why it doesn't matter at this point.

You can see that the gems required for content-publisher are installed! However, anything you do here won't persist - if you were to quit the container and then go back in exactly the same way, all the gems would need to be re-installed again.

By default gems are saved to `/usr/local/bundle` within the container. But everything in the container is destroyed and reset to the image when it's shut down, just like how objects are destroyed when we stop using them in a program.

To make sure our gems stick around, we could mount `/usr/local/bundle` to the directory on your `$mac`. But there is a Docker way of providing storage which is also [faster](https://docs.docker.com/docker-for-mac/osxfs-caching/).

### Persistent volumes

We don't want to be re-installing and doing setup every time we quit and re-enter a container. Docker allows you to create named volumes for persistent data, which it stores and optimises in its own, special way.

* Create a persistent volume for our gems:

```shell
$mac docker volume create content-publisher-bundle
```

* Run docker with that volume by using the `-v` flag and passing it the name of the volume:

```shell
$mac docker run -it -v $(pwd):/app -v content-publisher-bundle:/usr/local/bundle ruby:2.6.3 bash
```

* Then install the gems again:

```shell
$dev cd /app
$dev bundle install
```

This time the gems will install in the `content-publisher-bundle` volume, which is available in the container under `/usr/local/bundle`. The gems will now be around if you shut down the container and restarted it.

## Step 3: Dockerfiles

Now we have our gems installed, we can try and run the content-publisher tests:

```shell
$dev bundle exec rake
```

We get an error: “could not find javascript runtime” - we need Node installed on our container. We can try to install Node here, but this won't persist and we'll have the same problem that we had above with installing gems.

Unlike gems, our install of Node won't need to change in the foreseeable future. It would be nice if our `ruby:2.6.3` image had it as well. We can't change the `ruby:2.6.3` image, but we can create our own image based off it.

### Create ruby + node image

We are going to create our own Docker image based off of the ruby one, and add in other dependencies such as `nodejs`, which includes a JavaScript runtime, and `yarn`, which is the JS package manager used by Content Publisher.

To create our own image, we need a Dockerfile. A Dockerfile normally starts with a `FROM [image]` which bases your new image off an existing image. We can then execute other commands by prefixing them with `RUN`.

Each RUN command adds a new "layer". You can think of it as each step creating a new image, but we only care about the final image to come out of the last step.

Create a Dockerfile in the content-publisher project:

> Note: there will likely already be a Dockerfile, so just remove it for the tutorial.

* Create a `Dockerfile` in the root of the [content-publisher] project:

```docker
FROM ruby:2.6.3

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn nodejs
```

* Build our new image:

```shell
$mac docker build -t content-publisher-demo .
```

> Note: this might be a bit slow as part of the build process involves copying all the files in the current directory (`.`). For now, we can add a [`.dockerignore`][dockerignore] file in the content-publisher directory, to speed it up a bit:
>
> ```
> node_modules
> tmp
> log
> ```

This creates an image based on the Dockerfile we just added. `-t` tags, or names it, as `content-publisher`.

* Now we can start a container with our new image:

```shell
$mac docker run -it -v $(pwd):/app -v content-publisher-bundle:/usr/local/bundle content-publisher-demo bash
$mac cd /app
$mac yarn
```

If we try and run the tests again (`bundle exec rake`), they will still be failing because we have another dependency for Chrome. Like with Node, we can extend our image to fix that.

* Add the following to the Dockerfile:

```docker
RUN apt-get install -y libxss1 libappindicator1 libindicator7 && apt-get clean
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
```

* Then rebuild image and re-run the container:

```shell
$mac docker build -t content-publisher-demo .
$mac docker run -it -v $(pwd):/app -v content-publisher-bundle:/usr/local/bundle content-publisher-demo bash
```

> Note: Each time you change the Dockerfile, you need to remember to rebuild the docker image.

* Run the tests again:

```shell
$dev cd /app
$dev bundle exec rake
```

## Step 4: Networking

If we run the tests again, this time we see another problem about no database. That's because we haven't got PostgreSQL installed. Let's set up a separate container for postgres.

Docker containers are quick to start and it's possible for them to talk to each other with internal IPs. This approach also follows the Docker way, which is to have one container per process.

* In another terminal, run the following to start a new container based on the `postgres` image:

```shell
$mac docker run -it postgres
```

* Now to see what containers you have, in another terminal run:

```shell
$mac docker ps

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
a7b87be3e1bc        postgres            "docker-entrypoint.s…"   21 minutes ago      Up 21 minutes       5432/tcp            jovial_matsumoto
...
```

This shows us that `a7b87be3e1bc` or "jovial_matsumoto" is up and running. We can "inspect" the configuration of the container and get its IP, which we can use in the content-publisher container.

* Find the ID for the postgres container, and with it run:

```shell
$mac docker inspect [container ID for postgres]
...
            "IPAddress": "172.17.0.3"
...
```

* Set these environment variables in the content-publisher container:

```shell
$dev export DATABASE_URL=postgres://postgres@172.17.0.3/content-publisher
$dev export TEST_DATABASE_URL=postgres://postgres@172.17.0.3/content-publisher-test
```

> The IP address can change randomly so you may need to update the IP address above each time you restart the postgres container. This is pretty fiddly, and we'll look at how to automate it soon!

* We can now setup the database from the content-publisher container:

```shell
$dev bundle exec rake db:setup
```

We now have a database, but it's not permanent! Just like with the gems, we'll have to do `rake db:setup` every time we restart the postgres container. We can use the same technique to fix that.

* Create a volume to persist to for the data:

```shell
$mac docker volume create content-publisher-postgres
```

* Restart the postgres container in your other terminal window/tab:

```shell
$mac docker run -it -v content-publisher-postgres:/var/lib/postgresql/data postgres
```

## Step 5: (Mostly) passing tests!

We're nearly there! If we run the tests again, we'll get a somewhat unintuitive error about Chrome. Debugging this error is quite hard - a simple Google search won't turn up much - so let's skip to the solution:

* Run our tests (and thus Chrome) as a non-root user

```docker
# In the Dockerfile
RUN useradd -m build
USER build
```

* Re-build content-publisher container (Dockerfile changed)

```shell
$mac docker build -t content-publisher-demo .
```

* Give the content-publisher container [low-level privileges](privileged)

```shell
$mac docker run -it -v $(pwd):/app -v content-publisher-bundle:/usr/local/bundle --privileged content-publisher-demo bash
```

* Run the tests and watch (most of) them pass!

```shell
$dev export DATABASE_URL=postgres://postgres@172.17.0.3/content-publisher
$dev export TEST_DATABASE_URL=postgres://postgres@172.17.0.3/content-publisher-test

$dev cd /app
$dev bundle exec rake
```

## Step 6: Tidying up

There's more we can do to get the tests passing, but now let's focus on making things a bit simpler.

### Fixing IP with Docker Network

In a previous section we noted that IP addresses will be randomly assigned each time the postgres container starts up. We also need to set those `DATABASE_URL` environment variables every time we start the content-publisher container.

Docker has the notion of Networks which you can provide to each container as a connection that they can use.

* Create a network:

```shell
$mac docker network create content-publisher-network
```

* Run the containers with the new network:

```shell
$mac docker run -it -v content-publisher-postgres:/var/lib/postgresql/data --network content-publisher-network --network-alias postgres postgres

$mac docker run -it -v $PWD:/app -v content-publisher-bundle:/usr/local/bundle --privileged --network content-publisher-network -e TEST_DATABASE_URL=postgresql://postgres@postgres/content-publisher-test -e DATABASE_URL=postgresql://postgres@postgres/content-publisher content-publisher-demo bash
```

This is a lot to run in one command! Luckily, other people have had this exact problem, and came up with [docker-compose]. With 'compose', we can convert our long commands into a YAML configuration file called `docker-compose.yml`.

```docker
version: '3'

volumes:
  bundle:
  postgres:

services:
  postgres:
    image: postgres
    volumes:
      - postgres:/var/lib/postgresql/data

  content-publisher-demo:
    privileged: true
    build:
      context: .
    volumes:
      - bundle:/usr/local/bundle
      - ~/govuk/content-publisher:/app
    depends_on:
      - postgres
    environment:
      DATABASE_URL: "postgresql://postgres@postgres/content-publisher"
      TEST_DATABASE_URL: "postgresql://postgres@postgres/content-publisher-test"
    working_dir: /app
```

```shell
$mac docker-compose run content-publisher-demo bundle install
$mac docker-compose run content-publisher-demo bundle exec rake db:setup
$mac docker-compose run content-publisher-demo bundle exec rake
```

If we continue this iterative process add keep tidying up, adding more services, and consolidating the commands we have to run, like `bundle install` and `rake db:setup`, we end up [govuk-docker][govuk-docker] :-).

## What now?

In this tutorial we used Docker to create an environment for running tests against the Content Publisher repo. We started with a simple `docker run` command and added various flags to give us:

* **volumes** the repo and gems
* a **network** to communicate with Postgres
* **environment variables** for Postgres
* a **working directory** to reduce typing

We also explored how to write and build an **image** that has the essential libraries and presets, using a **Dockerfile**. The end result is a single, relatively short command that we can use for day-to-day tasks, such as `bundle exec rake`.

But there's more! Check out the [next tutorial in this series](/manual/intro-to-docker-advanced.html).

[content-publisher]: https://github.com/alphagov/content-publisher
[Fixing IP with Docker Network]: #fixing-ip-with-docker-network
[govuk-docker]: https://github.com/alphagov/govuk-docker
[docker-registry]: https://hub.docker.com/_/ruby
[dockerignore]: https://docs.docker.com/engine/reference/builder/#dockerignore-file
[privileged]: https://github.com/jessfraz/dockerfiles/issues/350#issuecomment-477342782
[docker-compose]: https://docs.docker.com/compose/
[content-publisher-ruby]: https://github.com/alphagov/content-publisher/blob/master/.ruby-version
