---
owner_slack: "#govuk-2ndline"
title: Unknown error with postgresql in mapit
layout: manual_layout
parent: "/manual.html"
section: Icinga alerts
---

We have seen an error previously where postgresql services appear to have failed
on the mapit server, yet calling a restart command for the service does not
seem to fix the issue.

This document is intended on pointing you in the right direction should this
occur again.

### Are you sure postgresql is running?

Check the status of the service with

```shell
$ sudo service --status-all
```

If `postgresql` is not running, attempt

```shell
$ sudo service postgresql start
```

Check the status again. If it's still not running...

### Using puppet to find errors

You can usually find if there is a bigger issue by running

```shell
$ sudo govuk_puppet --test
```

Previously we have found that somehow, somewhen, postgresql was uninstalled (or
perhaps not correctly initialised) on the mapit box, preventing some tests
from completing (typically those relying on the database for items such as
postcodes) with no clear reason.

If you ensure that you follow any extra steps as needed upon running the above
puppet command - such as installing dependencies manually to assist in govuk_puppet
installing the correct gems - you may find the errors will disappear upon a
subsequent run of the above command.

#### Permissions

You may find that there are permission errors on the `/var/run/postgresql/`
directory. You can solve this by calling

```shell
$ sudo chown postgres:postgres /var/run/postgresql/
```
