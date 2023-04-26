---
owner_slack: "#govuk-developers"
title: Run a rake task
section: Deployment
layout: manual_layout
parent: "/manual.html"
important: true
---

Rake is a task runner for Ruby. Here are the methods for running a rake task:

## Run a rake task on EKS

To run a rake task in Kubernetes, execute the rake command inside the application container.

For example:

```sh
kubectl -n apps exec deploy/publishing-api -- rake 'represent_downstream:published_between[2018-12-17T01:02:30, 2018-12-18T10:20:30]'
```

The output of the command will be streamed to your terminal.

## Run rake tasks from the command line

It is also possible to run the rake tasks directly on the relevant app machines.

First, SSH into the right machine class (e.g. `publishing_api`):

```
gds govuk connect ssh -e production publishing_api
```

Secondly, change directory so that the rake task is available:

```
cd /var/apps/publishing-api
```

Finally, run the rake task, e.g.:

```
govuk_setenv publishing-api bundle exec \
rake 'represent_downstream:published_between[2018-12-17T01:02:30, 2018-12-18T10:20:30]'
```
