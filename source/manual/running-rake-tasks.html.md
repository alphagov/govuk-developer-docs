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
