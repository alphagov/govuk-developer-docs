---
owner_slack: "#govuk-2ndline"
title: Locally replicating Whitehall data with Docker
section: Docker
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 
review_in: 6 months
---

When using Docker for the development environment you may wish to replicate
Whitehall data locally. We have found that a different approach is needed to
load this data into Docker containers than the previous VM implementation would
allow.

### Requirements

1. It goes without saying that you require
[govuk-docker][govuk_docker] to be ready to go for
this, as well as have already built and run Whitehall via `govuk-docker build`
followed by `govuk-docker startup` in the `/whitehall` directory.

2. Follow the steps found in the
[replicate local data][replicate_local] page to download
a copy of the backup from the AWS servers. You should not attempt to run the
script to install the backup, simply to download. Alternatively, you may
download the backup directly off of s3.

3. You require [Pipe Viewer][pipe_viewer]
to be installed. Assuming you have homebrew setup, you can do so with
`brew install pv`

### Docker setup

In order to ensure that Whitehall runs smoothly, your Docker settings may need
to be changed in order to handle the weight of the tool. By default, Docker
defaults to using 2 CPU cores and 2GB of RAM, and this is simply not enough
to render Whitehall in a Docker container.

Ideally, you should set it to use at least 4 CPU cores and 8GB of RAM - the more
the better. You can do this by opening the Docker dropdown via the whale icon in
the OSX menu bar and selecting the `Advanced` option.

You may feel it beneficial to increase swap space size, though we have found no
tangible improvement in doing so compared to CPU and RAM allocation.

**Be aware that Whitehall is still large and will still time out on first load.**
 We have found that performance in Docker is faster than on the old development
 VM, but some things simply can't be sorted with the current size of it. You
 may have more luck for quick turn around if you kill your Whitehall container
 after import with ctrl+c then relaunch it, but best option is to let it "warm
 up" a little before attempting to use it.

### How to import the data

#### 1. Set up the database

Start off by running `docker ps` in your terminal and make note of the
`$container_id` of your MySQL instance. It should be a random string similar to
`4126b9858c5c`

Run the following in your shell to access the
command line for the MySQL docker container:

```shell
$ docker exec -it $mysql_container_id mysql --password=root
```

Then input `SHOW DATABASES` to make
sure you have `whitehall_development` available. If it is not present, run the
following command to create it: `CREATE DATABASE whitehall_development;` then `exit`

#### 2. Import the data

Once complete, run the following command to import the downloaded database
backup to your SQL server:

```shell
$ pv $backup_location | gunzip | docker exec -i $mysql_container_id mysql -u root --password=root whitehall_development
```

This will take a while (half an hour or more), but when complete you should be
able to visit your
[local Whitehall instance][local_whitehall] and see your
imported data available.

#### Migration error
If you have an error about migration, run the following in the Whitehall folder:

```shell
$ govuk-docker be rake db:migrate
```

All tasks that involve the environment need to be performed on the Docker
container, including bundling and testing. Bare this in mind and read the
[govuk-docker][govuk_docker] readme for more information.

[govuk_docker]: https://github.com/alphagov/govuk-docker
[replicate_local]: /manual/replicate-app-data-locally.html
[pipe_viewer]: https://www.ivarch.com/programs/pv.shtml
[local_whitehall]: http://whitehall-admin.dev.gov.uk
