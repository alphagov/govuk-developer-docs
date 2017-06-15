---
owner_slack: "#2ndline"
title: Replicating application data locally for development
section: Databases
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-05-12
review_in: 6 months
---

Dumps are generated from production data in the early hours each day, and are
then downloaded from integration.  This process is managed by the
[replicate-data-local.sh](https://github.com/alphagov/govuk-puppet/blob/master/development-vm/replication/replicate-data-local.sh)
script within the [govuk-puppet
repository](https://github.com/alphagov/govuk-puppet).

> The Licensify and Signon databases aren't synced out of production because of
> security concerns. Mapit's database is downloaded in the Mapit repo, so won’t
> be in the backups folder.

## Pre-requisites to importing data

To get production data on to your local VM, you'll need to have either:

* access to integration; or
* database exports from someone that does.

## If you have integration access

If you have integration access, you can download and import the latest data by
running:

    dev$ cd /var/govuk/govuk-puppet/development-vm/replication dev$
    ./replicate-data-local.sh -u $USERNAME -F ../ssh_config

> Databases will take a long time to download. They'll also take up a lot of
> disk space (up to ~30GB uncompressed). The process will also take up a bunch
> of compute resource as you import the data.

## If you don't have integration access

If you don't have integration access, ask someone to give you a copy of their
dump. Then, from `govuk-puppet/development-vm/replication` run:

    dev$ ./replicate-data-local.sh -d path/to/dir -s

## Downloading data for later import

You may want to download the data while in the office and restore it overnight
to minimise disruption (or to provide to someone who doesn't have integration
access).  First, do the download on your host, as the unzipping is a lot
quicker when not run over NFS:

    mac$ ./replicate-data-local.sh -u $USERNAME -n

Then follow the instructions above for importing using the `-s` flag.

## If you're running out of disk space

After replicating data a few times, your machine might be running low on disk
space. This is because the old database dumps aren't cleaned up once newer ones
have been downloaded. To solve this, you can periodically `rm -r` older
directories in `govuk-puppet/development-vm/replication/backups`.

## Can't take a write lock while out of disk space (in MongoDB)

You may see such an error message which will prevent you from creating or even dropping collections. So you won't be able to replicate the latest data.

You will need to delete large Mongo collections to free up space before they can be re-imported. Follow this [guide on how to delete them, and ensure that Mongo honours their removal](https://caffinc.github.io/2014/07/mongodb-cant-take-a-write-lock-while-out-of-disk-space/).

Find your biggest Mongo collections by running:

```
dev$ sudo ncdu /var/lib/mongodb
```

You can re-run the replication but skip non-Mongo imports, like MySQL if it'd already succesfully imported. Use
```
replicate-data-local.sh --help
```
to see the options.

For example, to run an import but skip MySQL and Elasticsearch:

```
dev$ replicate-data-local.sh -q -e -d backups/2017-06-08 -s
```
