---
owner_slack: "#govuk-2ndline"
title: Replicate application data locally for development
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-10
review_in: 6 months
---

Dumps are generated from production data in the early hours each day, and can
then be downloaded.  You'll use the
[replicate-data-local.sh script](https://github.com/alphagov/govuk-puppet/blob/master/development-vm/replication/replicate-data-local.sh)
script in the [govuk-puppet repository](https://github.com/alphagov/govuk-puppet).

> The Licensify and Signon databases aren't synced from production because of
> security concerns. Mapit's database is downloaded in the Mapit repo, so won’t
> be in the backups folder.

## Pre-requisites to importing data

👉 First, [set up your AWS account](/manual/set-up-aws-account.html)
👉 Then, [set up your CLI access for AWS](/manual/aws-cli-access.html)

## Replication

When you have AWS access, you can download and import the latest data by running:

    mac$ cd ~/govuk/govuk-puppet/development-vm/replication
    mac$ ./replicate-data-local.sh -n

The data will download to a folder named with today's date in `./backups`, for example `./backups/2018-01-01`.

then

    dev$ cd /var/govuk/govuk-puppet/development-vm/replication
    dev$ ./replicate-data-local.sh -d backups/YYYY-MM-DD/ -s

Databases take a long time to download and use a lot of disk space (up to ~30GB uncompressed). The process also uses a lot of compute resource as you import the data.

The downloaded backups will automatically be deleted after import (whether successful or not) unless the `-k` flag is specified.

## If you don't have AWS access

If you don't have AWS access, ask someone to give you a copy of their
dump. Then, from `govuk-puppet/development-vm/replication` run:

    dev$ ./replicate-data-local.sh -d path/to/dir -s

## If you're running out of disk space

See [running out of disk space in development](/manual/development-disk-space.html).

## If you get a curl error when restoring Elasticsearch data

Check the service is running:

    dev$ sudo service elasticsearch-development.development start

If you get an error saying Elasticsearch is not installed, you may need to reprovision the VM from your host machine:

    mac$ vagrant provision

## Can't take a write lock while out of disk space (in MongoDB)

You may see such an error message which will prevent you from creating or even dropping collections. So you won't be able to replicate the latest data.

You will need to delete large Mongo collections to free up space before they can be re-imported. Follow this [guide on how to delete them, and ensure that Mongo honours their removal](https://caffinc.github.io/2014/07/mongodb-cant-take-a-write-lock-while-out-of-disk-space/).

Find your biggest Mongo collections by running:

```
dev$ sudo ncdu /var/lib/mongodb
```

You can re-run the replication but skip non-Mongo imports like MySQL if it's already successfully imported. Use `replicate-data-local.sh --help `to see the options.

For example, to run an import but skip MySQL and Elasticsearch:

```
dev$ replicate-data-local.sh -q -e -d backups/2017-06-08 -s
```

## Broken AWS connection

If you get an error saying download failed `"Connection broken: error(54, 'Connection reset by peer')", error(54, 'Connection reset by peer')` you may need to update the AWS CLI by running:
```
mac$ pip3 install awscli --upgrade --user
```
You may need to install Python3 and upgrade pip first.
