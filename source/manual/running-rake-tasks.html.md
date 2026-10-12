---
owner_slack: "#govuk-developers"
title: Run a rake task
section: Deployment
layout: manual_layout
parent: "/manual.html"
important: true
---

## Run a Rake task on EKS

To run a [rake](https://ruby.github.io/rake/) task in Kubernetes, create a job request which specifies  the deployment in which to run the task,
and the task you want to run.

For more on how to use job requests, refer to [the job request user guide](/kubernetes/job-requests/user-guide/)

## Working with CSVs on Kubernetes

Some of our legacy rake tasks require uploading a CSV file. This is a throwback to our previous Puppet-based
infrastructure and should be phased out now that we're on Kubernetes, as containers are meant to be immutable and
ephemeral.

Running rake tasks that require a CSV is not supported in job requests. The correct workaround is to [get temporarily
elevated privileges](/manual/rules-for-getting-production-access.html#temporary-production-admin-access) and
use `kubectl exec` to upload the file and then run the task.

It is not possible to use the job request system to run the job once the file is uploaded because jobs are not run in
the same pods.

```sh
kubectl cp foo.csv $somepod:/tmp && kubectl exec $somepod -- rake name_of_task

$ kubectl get pods
# returns list of pods, including
# whitehall-admin-c4c7c957c-9q966

$ kubectl cp ~/Downloads/tag.csv whitehall-admin-c4c7c957c-9q966:/tmp
# copies the file

$ kubectl exec whitehall-admin-c4c7c957c-9q966 -- rake data_hygiene:bulk_update_organisation[/tmp/tag.csv]
# runs the rake task
```
