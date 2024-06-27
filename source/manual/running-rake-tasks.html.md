---
owner_slack: "#govuk-developers"
title: Run a rake task
section: Deployment
layout: manual_layout
parent: "/manual.html"
important: true
---

## Run a Rake task on EKS

To run a [rake](https://ruby.github.io/rake/) task in Kubernetes, execute the rake command inside the application container.

For example:

```sh
kubectl exec deploy/publishing-api -- rake 'represent_downstream:published_between[2018-12-17T01:02:30, 2018-12-18T10:20:30]'
```

The output of the command will be streamed to your terminal.

## Working with CSVs on Kubernetes

Some of our legacy rake tasks require uploading a CSV file. This is a throwback to our previous Puppet-based infrastructure and should be phased out now that we're on Kubernetes, as containers are meant to be immutable and ephemeral.

Nevertheless, it is possible to copy a local CSV file into a pod and reference the file in the rake task, doing something like:

```sh
kubectl cp foo.csv $somepod:/tmp && kubectl exec $somepod -- rake name_of_task
```
