---
owner_slack: "#govuk-2ndline"
title: Run an application in the VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-15
review_in: 6 months
---

You can use [bowler](https://github.com/JordanHatch/bowler) to run an
application, it will also run all dependent services and applications.
The applications are listed in the [Pinfile](https://github.com/alphagov/govuk-puppet/blob/master/development-vm/Pinfile).

```shell
$ cd /var/govuk/govuk-puppet/development-vm
$ bowl rummager
```

If you want to run an application in development mode with the static assets
served from your local copy, run bowler with the `STATIC_DEV` variable defined
and make sure you're not setting `static=0`:

```shell
$ STATIC_DEV="http://static.dev.gov.uk" bowl planner static
```

To run a single application without the dependencies you can use
[foreman](http://ddollar.github.io/foreman/). The available apps are defined in
the [Procfile](https://github.com/alphagov/govuk-puppet/blob/master/development-vm/Procfile).

```shell
$ cd /var/govuk/govuk-puppet/development-vm
$ foreman start rummager
```

Most apps also have a `startup.sh` script in their root folder, and you can
run that directly too:

```shell
$ cd /var/govuk/rummager
$ ./startup.sh
```
