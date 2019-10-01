---
owner_slack: "#govuk-2ndline"
title: Run an application in the VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-27
review_in: 3 months
---

> Before running an application in the VM, it's worth first checking whether
> you can use [GOV.UK Docker][docker] to run your application instead.

[docker]: https://github.com/alphagov/govuk-docker

You can use [bowler](https://github.com/JordanHatch/bowler) to run an
application, it will also run all dependent services and applications.
The applications are listed in the [Pinfile](https://github.com/alphagov/govuk-puppet/blob/master/development-vm/Pinfile).

```shell
$ cd /var/govuk/govuk-puppet/development-vm
$ bowl search-api
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
$ foreman start search-api
```

Most apps also have a `startup.sh` script in their root folder, and you can
run that directly too:

```shell
$ cd /var/govuk/search-api
$ ./startup.sh
```
