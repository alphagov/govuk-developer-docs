---
owner_slack: "#govuk-developers"
title: Run a rake task
section: Deployment
layout: manual_layout
parent: "/manual.html"
important: true
---

Rake is a task runner for Ruby. There are several different methods of running a rake task:

## Run a rake task on EC2

There is a Jenkins job that can be used to run any rake task:

- Integration:
  <https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/>
- Staging:
  <https://deploy.blue.staging.govuk.digital/job/run-rake-task/>
- Production:
  <https://deploy.blue.production.govuk.digital/job/run-rake-task/>

Jenkins jobs are also linkable. For example:

<https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE_CLASS=backend-1.backend&RAKE_TASK=routes>

### Run rake tasks from the command line

It is possible to bypass Jenkins and run the rake tasks directly on the relevant app machines.

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

## Run a rake task on EKS

To run a rake task in Kubernetes, you execute the rake command inside the relevant application container.

1. Find the name of a pod running the application with the rake task defined:

    ```bash
    APP_NAME=government-frontend # Change to relevant application name

    POD_NAME=$(kubectl -n apps get pods -l=app=$APP_NAME -o go-template --template '{{ (index .items 0).metadata.name }}')

    echo $POD_NAME # Check you've correctly set a pod name
    ```

1. Execute the rake task in the application container:

    ```bash
    kubectl -n apps exec -i -t $POD_NAME -- rake 'some_namespace:task_name[arg1,arg2,arg3]'
    ```

> **Note**
>
> You may need to escape certain characters in argument strings (including `,` and `"`) with a
> backslash. For example `\,` or `\"`.
