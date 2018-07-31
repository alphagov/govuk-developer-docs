---
owner_slack: "#govuk-2ndline"
title: Replicate application data locally for development
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-31
review_in: 6 months
---

Dumps are generated from production data in the early hours each day, and can
then be downloaded from integration (AWS).  The process is managed by the
[replicate-data-local.sh](https://github.com/alphagov/govuk-puppet/blob/master/development-vm/replication/replicate-data-local.sh)
script within the [govuk-puppet
repository](https://github.com/alphagov/govuk-puppet).

> The Licensify and Signon databases aren't synced out of production because of
> security concerns. Mapit's database is downloaded in the Mapit repo, so won’t
> be in the backups folder.

## Pre-requisites to importing data

To get production data on to your local VM, you'll need to have either:

* access to Integration via AWS; or
* database exports from someone that does.

## AWS access

Follow the [AWS setup guide](/manual/user-management-in-aws.html) to get your user set up in AWS. You'll
need at least the Integration environment set up.

## Replication

When you have integration access, you can download and import the latest data by running:

    mac$ cd ~/govuk/govuk-puppet/development-vm/replication
    mac$ ./replicate-data-local.sh -u $USERNAME -F ../ssh_config -n

> You may be able to skip the -u and -F flags depending on your setup

The data will download to a folder named with today's date in `./backups`, for example `./backups/2018-01-01`.

then

    dev$ cd /var/govuk/govuk-puppet/development-vm/replication
    dev$ ./replicate-data-local.sh -d path/to/dir -s

> You can skip the -d flag if you do this on the say day as the download

> Databases will take a long time to download. They'll also take up a lot of
> disk space (up to ~30GB uncompressed). The process will also take up a bunch
> of compute resource as you import the data.

## If you don't have integration access

If you don't have integration access, ask someone to give you a copy of their
dump. Then, from `govuk-puppet/development-vm/replication` run:

    dev$ ./replicate-data-local.sh -d path/to/dir -s

## If you're running out of disk space

See [running out of disk space in development](/manual/development-disk-space.html).

## If you get a curl error when restoring Elasticsearch data

Check the service is running:

    dev$ sudo service elasticsearch-development.development start

## Can't take a write lock while out of disk space (in MongoDB)

You may see such an error message which will prevent you from creating or even dropping collections. So you won't be able to replicate the latest data.

You will need to delete large Mongo collections to free up space before they can be re-imported. Follow this [guide on how to delete them, and ensure that Mongo honours their removal](https://caffinc.github.io/2014/07/mongodb-cant-take-a-write-lock-while-out-of-disk-space/).

Find your biggest Mongo collections by running:

```
dev$ sudo ncdu /var/lib/mongodb
```

You can re-run the replication but skip non-Mongo imports like MySQL if it's already succesfully imported. Use
```
replicate-data-local.sh --help
```
to see the options.

For example, to run an import but skip MySQL and Elasticsearch:

```
dev$ replicate-data-local.sh -q -e -d backups/2017-06-08 -s
```
