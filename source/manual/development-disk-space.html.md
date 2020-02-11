---
owner_slack: "#govuk-dev-tools"
title: Fix low disk space in development
parent: "/manual.html"
layout: manual_layout
section: Development VM
last_reviewed_on: 2019-10-08
review_in: 6 months
---

You may run out of disk space when replicating data into your development
environment. The default VM disk size is 150GB.

First check if you are out of disk space on your host machine (`df -h`).
If your host machine has plenty of available space, then the problem may be
the space allocated to the VM for its root partition.

You can run `ncdu /` from the command line to browse the filesystem and
identify large directories and files. On your host machine you could also use
graphical tools like [Disk Inventory X](http://www.derlien.com/).

## What to delete on your host machine

On the host machine, you can safely delete:

- Old backups from `~/govuk/govuk-puppet/development-vm/replication/backups/`
- Old log files from `~/govuk/*/logs`

## What to delete on the VM

On the VM, you can safely delete old Elasticsearch indexes:

```shell
$ cd /var/govuk/govuk-puppet/development-vm/replication
$ bundle exec ruby close_and_delete_old_indices.rb
```

If you plan on replicating all your data again, you can also delete big mongodb
databases to clear space.

```shell
$ mongo
> show databases
> use draft_content_store_development
> db.dropDatabase()
```

Similarly, you can find large postgres databases with:

```shell
$ sudo -u postgres psql
> \l+
```

You can also remove dependencies that were installed with applications but are no longer needed by running:

```
$ sudo apt-get autoremove
```
