---
owner_slack: "#2ndline"
title: Copying application data locally for development
section: Manual
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
