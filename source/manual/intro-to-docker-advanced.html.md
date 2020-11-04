---
owner_slack: "#govuk-dev-tools"
title: Intro to GOV.UK Docker (Advanced)
section: Docker
layout: manual_layout
type: learn
parent: "/manual.html"
---

In the [Intro to Docker tutorial](/manual/intro-to-docker.html) we began with a generic container running the `ruby` image, and finished with a powerful `docker-compose` command to run the [content-publisher][] tests against a Postgres DB.

This tutorial is going to pick up where we left off and introduce some more advanced concepts that we make use of in [govuk-docker][]. You should be able to understand the bulk of the repo after completing this tutorial.

> You will need the following from the [previous tutorial](/manual/intro-to-docker.html):
>
>   * The `docker-compose.yml` file from Step 6
>   * The Dockerfile that we wrote incrementally
>   * The `.dockerignore` file from Step 3 (optional)

## Step 1: Makefiles

We did some tidy-up work at the end of the last tutorial, but there are still some manual setup commands to run.

```shell
$mac docker-compose run content-publisher-demo bundle install
$mac docker-compose run content-publisher-demo bundle exec rake db:setup
```

To avoid having to remember these commands and type them to setup different projects, we can use a [Makefile][makefile].

```
content-publisher:
  docker-compose run content-publisher-demo bundle install
  docker-compose run content-publisher-demo bundle exec rake db:setup
```

> Makefiles use strict tabs for indentation, so you may need to adjust your editor if it's inserting spaces automatically.

Now we can run `make content-publisher` and the commands are run for us.

## Step 2: `/govuk`

At the end of the last tutorial we got some, but not all, of the tests passing. The remaining failures should be due to a missing dependency: [govuk-content-schemas][]. The tests are looking for the shemas at `../govuk-content-schemas`, which doesn't exist inside our container, since we only mapped the `content-publisher` directory to `/app`.

* Mount the whole of the `~/govuk` directory

```
volumes:
  - bundle:/usr/local/bundle
  - ~/govuk:/govuk
```

* Adjust the working directory accordingly

```
working_dir: /govuk/content-publisher
```

* Check all of the tests now pass (hopefully!)

```shell
$mac docker-compose run content-publisher-demo bundle exec rake
```

## Step 3: rbenv

In the last tutorial we used a `bundle` volume to persist the gems we installed. This works fine initially, but [Bundler][] doesn't cope well if we start using a new version of Ruby.

On GOV.UK we use [rbenv](/manual/ruby.html) to manage different Ruby versions. To support this, we need to build a lower-level base image that has rbenv and isn't tied to a version of Ruby.

* Change the `FROM` entry in our Dockerfile

```
FROM buildpack-deps
```

* Install rbenv before we create the 'build' user

```
RUN git clone https://github.com/sstephenson/rbenv.git /rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /rbenv/plugins/ruby-build
RUN /rbenv/plugins/ruby-build/install.sh
ENV PATH /rbenv/bin:$PATH
```

* Add shims for ruby, bundler, etc. to the `PATH`

```
ENV PATH /home/build/.rbenv/shims:${PATH}
```

* Tell compose to rebuild the image we're using

```shell
$mac docker-compose build content-publisher-demo
```

Rubies and gems will go into `/home/build/.rbenv` by default. We need to make sure this directory is persisted. If we persist the entire `/home/build` directory, we can also benefit from [caching for chromedriver][webdrivers].

* Replace the 'bundle' volume with a 'home' one

```
volumes:
  home:
  postgres:
```

* Change the service to use the new 'home' volume

```
volumes:
  - home:/home/build
  - ~/govuk:/govuk
```

* Change our `Makefile` to install Ruby and bundler

```
content-publisher:
  docker-compose run content-publisher-demo rbenv install -s
  docker-compose run content-publisher-demo sh -c 'gem install --conservative --no-document bundler -v $$(grep -A1 "BUNDLED WITH" Gemfile.lock | tail -1)'
  docker-compose run content-publisher-demo bundle install
  docker-compose run content-publisher-demo bundle exec rake db:setup
```

* Get the tests passing now we're running with rbenv

```shell
# it can take some time to install Ruby!
$mac make content-publisher

# run the tests
$mac docker-compose run content-publisher-demo bundle exec rake
```

## Step 4: Rails

Now the tests are passing, we're going to shift our focus and look at running Content Publisher as a web app. The aim is to get it running in our browser at `content-publisher-demo.intro-to-docker.gov.uk`.

Our host machine can't communicate with the process in the container. We need to expose the Rails port (3000) on our host machine, and tell Rails to listen for requests on all network interfaces.

* Start with a hacky bunch of command flags

```shell
$mac docker-compose run -p 80:3000 content-publisher-demo bin/rails s -b 0.0.0.0
```

> If you see a `Bind for 0.0.0.0:80 failed` error, you need to stop the process on your local machine that's using this port. This is probably GOV.UK Docker, so try doing `govuk-docker down`.
>
> If you see a `A server is already running` error, you need an additional `--restart` flag to tell Rails to cleanup its `tmp/pids` directory, which sometimes fails when containers exit too quickly.

If you visit `localhost` in your browser, you should see some Rails logs in the terminal, and the Content Publisher homepage should (eventually) be visible. Now let's tidy up.

* Move the binding flag for Rails into config

```
environment:
  BINDING: 0.0.0.0
```

* Run `rails s` as the default command

```
command: bin/rails s
```

* Re-run with a slightly shorter command

```shell
$mac docker-compose run -p 80:3000 content-publisher-demo
```

* Add a temporary entry in `/etc/hosts`

```
127.0.0.1 content-publisher-demo.intro-to-docker.gov.uk
```

You should now be able to go to this domain in your browser and see the Content Publisher homepage. After the next section we'll iterate this approach to make it more dynamic and work across multiple apps.

## Step 5: YAML

The `content-publisher-demo` service in our `docker-compose.yml` file is now serving two purposes: running tests and running the app. As we add more environment variables, dependencies, etc., it makes sense to have variants of `content-publisher-demo` that have just the right amount of config for what they need to do.

* Move common config into [an extension][yaml-extension]

```
# this needs a higher version of compose
version: '3.7'

x-content-publisher-demo: &content-publisher-demo
  build:
    context: .
  volumes:
    - home:/home/build
    - ~/govuk:/govuk
  working_dir: /govuk/content-publisher
```

* Merge the config hash into the service

```
services:
  ...

  content-publisher-demo:
    <<: *content-publisher-demo
    ...
```

* Split the 'demo' service into two 'stacks'

```
services:
  ...

  # for tests
  content-publisher-demo-lite:
    <<: *content-publisher-demo
    privileged: true
    depends_on:
      - postgres
    environment:
      DATABASE_URL: "postgresql://postgres@postgres/content-publisher"
      TEST_DATABASE_URL: "postgresql://postgres@postgres/content-publisher-test"

  # for Rails
  content-publisher-demo-app:
    <<: *content-publisher-demo
    depends_on:
      - postgres
    environment:
      DATABASE_URL: "postgresql://postgres@postgres/content-publisher"
      HOST: 0.0.0.0
    command: bin/rails s
```

> Although the `depends_on` config is the same for both stacks in this case, in general we expect it to vary between stacks.

* Update the Makefile to use the `lite` stack

Each service will have its own image by default, which is based on the name of the service. Compose will build the images automatically when we try to `run` one of the stacks. Although the build time will be fast, because Docker will re-use layers it built previously, the extra 'build' step is unnecessary and we can easily avoid it.

* Build/re-use the same image for both stacks

```
x-content-publisher-demo: &content-publisher-demo
  image: content-publisher-demo
  ...
```

* Check everything still works after the refactor

```shell
# re-run setup
$mac make content-publisher

# run the tests
$mac docker-compose run content-publisher-demo-lite bundle exec rake

# run the app
$mac docker-compose run -p 80:3000 content-publisher-demo-app
```

## Step 6: NGINX

In the previous section we used a `-p 80:3000` flag to make Rails, which runs on port 3000, available on our host machine, on port 80. This approach doesn't scale to multiple apps, since only one process can bind to port 80 at a time. We need a single app that can 'proxy' our HTTP requests... an [`nginx-proxy`][nginx-proxy]!

* Add a new service to our compose file

```
nginx-proxy:
  image: jwilder/nginx-proxy:latest
  ports:
    - "80:80"
  volumes:
    - /var/run/docker.sock:/tmp/docker.sock
```

The nginx-proxy service will act as a 'front door' for HTTP requests we make in the browser. We give it access to the Docker daemon so it can auto-detect which containers are running and scan their config for which domains they 'own'. It will then proxy HTTP requests to a matching container, on a declared port.

* Change the `app` stack to work with it

```
depends_on:
  - postgres
  - nginx-proxy
environment:
  ...
  VIRTUAL_HOST: content-publisher-demo.intro-to-docker.gov.uk
expose:
  - 3000
```

* Start the app and try it in your browser

```shell
$mac docker-compose run content-publisher-demo-app
```

## Step 7: dnsmasq

The reason `content-publisher-demo.intro-to-docker.gov.uk` works in your browser is because we added a custom entry in `/etc/hosts`. This approach doesn't scale to lots of entries, especially if we need to keep them in-sync across a team. We need something more dynamic, but that's not possible with `/etc/hosts`.

As part of [setting-up govuk-docker](https://github.com/alphagov/govuk-docker/blob/master/docs/installation.md) you will have installed [dnsmasq][]. This gives us a little DNS server running on our Mac, which we can use instead of `/etc/hosts` to resolve `*.intro-to-docker.gov.uk` to the localhost.

* Remove the temporary entry in `/etc/hosts`

* Create `/etc/resolver/intro-to-docker.gov.uk`

```
nameserver 127.0.0.1
port 53
```

* Check your Mac is aware of the new rule

```shell
$mac scutil --dns

...

resolver #9
  domain   : intro-to-docker.gov.uk
  nameserver[0] : 127.0.0.1
  port     : 53
  flags    : Request A records, Request AAAA records
  reach    : 0x00030002 (Reachable,Local Address,Directly Reachable Address)
```

* Edit `/usr/local/etc/dnsmasq.d/development.conf`

```
address=/dev.gov.uk/127.0.0.1
address=/intro-to-docker.gov.uk/127.0.0.1
```

* Restart dnsmasq and your DNS resolver

```shell
$mac sudo killall -HUP mDNSResponder
$mac sudo brew services restart dnsmasq
```

* Start the app and try it in your browser

That's it! You should now have something very similar to the repo we use to develop on GOV.UK. All that remains is for you to go forth, use it, make it work better, and develop some software :-).

## Step 8: Cleanup

During this tutorial you created or changed a lot of files and state on your system. The following indicate how to cleanup your system e.g. if you want to run through the tutorials again.

* Remove all the extra docker state

```shell
docker-compose down
docker rm $(docker ps -aq -f status=exited)
docker rm $(docker ps -aq -f status=created)
docker volume rm content-publisher-bundle
docker volume rm content-publisher-postgres
docker volume rm content-publisher_bundle
docker volume rm content-publisher_home
docker volume rm content-publisher_postgres
docker network rm content-publisher-network
docker network rm content-publisher_default
docker image rm content-publisher-demo
docker image rm content-publisher_content-publisher-demo
docker image rm content-publisher_content-publisher
docker image rm $(docker image ls -q -f dangling=true)
```

> Some of these commands may return errors if you've deviated slightly from this tutorial. This isn't a problem.

* Remove the files you created

```shell
rm .dockerignore docker-compose.yml Dockerfile Makefile
sudo rm /etc/resolver/intro-to-docker.gov.uk
```

* Re-run the setup for GOV.UK Docker

```
cd ~/govuk/govuk-docker
bin/setup
```

[Bundler]: https://bundler.io/
[content-publisher]: https://github.com/alphagov/content-publisher
[dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[govuk-content-schemas]: https://github.com/alphagov/govuk-content-schemas
[govuk-docker]: https://github.com/alphagov/govuk-docker
[makefile]: https://www.gnu.org/software/make/manual/html_node/Introduction.html
[nginx-proxy]: https://github.com/jwilder/nginx-proxy
[webdrivers]: https://github.com/titusfortner/webdrivers#download-location
[yaml-extension]: https://medium.com/@kinghuang/docker-compose-anchors-aliases-extensions-a1e4105d70bd
