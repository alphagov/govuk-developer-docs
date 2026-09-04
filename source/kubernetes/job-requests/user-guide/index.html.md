---
title: Job Request User Guide
weight: 10
layout: multipage_layout
---

# Job Request User Guide

* [Terminology](#terminology)
* [What is this guide](#what-is-this-guide)
* [Prerequisites](#prerequisites)
* [Important Notes and Limitations](#important-notes-and-limitations)
* [Usage](#usage)
  * [Creating a JobRequest](#creating-a-jobrequest)
  * [Reviewing a JobRequest](#reviewing-a-jobrequest)
* [Using Kubectl to view JobRequests and JobRequestReviews](#using-kubectl-to-view-jobrequests-and-jobrequestreviews)
  * [Viewing a JobRequest or JobRequestReview](#viewing-a-jobrequest-or-jobrequestreview)
  * [Listing JobRequests or JobRequestReviews](#listing-jobrequests-or-jobrequestreviews)
  * [Showing the Job that was launched from a JobRequest](#showing-the-job-that-was-launched-from-a-jobrequest)
  * [Viewing the logs for the Job that was launched from a JobRequest](#viewing-the-logs-for-the-job-that-was-launched-from-a-jobrequest)

## Terminology

* **JobRequest**: A request to run a Job in Kubernetes is known as a JobRequest
  (with the short name of `jr` in Kubernetes)
* **JobRequestReview**: A review of a JobRequest with a decision of Approve or
  Reject is known as a JobRequestReview (with the short name of `jrr` in
  Kubernetes)

## What is this guide

This guide provides instructions and examples for creating a JobRequest, for
reviewing JobRequests, and for viewing the status of, and logs for, a
JobRequest.

For information about what the JobRequest system is, and why you might need to
use it see [Kubernetes JobRequests](/kubernetes/job-requests/).

For the technical architecture of the JobRequest system see [Kubernetes
JobRequest Technical Architecture](/kubernetes/job-requests/architecture/)

## Prerequisites

* [`govuk-cli` installed](#installing-govuk-cli)
* [gds-cli installed](/kubernetes/get-started/set-up-tools/#install-gds-cli)
* kubectl installed and set up to access the cluster you need to run a Job in

## Important notes and Limitations

* Immutability: Once you have created a JobRequest you cannot edit it. If you
  have made a mistake you will need to create a new JobRequest (and ideally have
  someone else reject the incorrect JobRequest). This is by design to ensure a
  JobRequest cannot be approved and then modified later.
* At present you cannot run a Job that requires uploading a CSV, to do that you
  will need to assume the fulladmin role and follow the instructions [in the Working
  with CSVs on
  Kubernetes](/manual/running-rake-tasks.html#working-with-csvs-on-kubernetes)
  section of the [old Running Rake Tasks page](/manual/running-rake-tasks.html)
* You cannot review your own JobRequests. This is irrespective of the AWS role
  you have assumed (so as the fulladmin role, you cannot approve your JobRequest
  created as Developer)
* You can only create JobRequests in the apps, or licensify namespaces
* JobRequests and JobRequestReviews will remain in Kubernetes for 30 days
  (720 hours) before being removed automatically

## Usage

* [Creating a JobRequest](#creating-a-jobrequest)
* [Reviewing a JobRequest](reviewing-a-jobrequest)

### Creating a JobRequest

You should create a JobRequest as below, and then ask a colleague to review it
for you. When you run the create command you will be given the review command
at the end of the output, which you can copy and paste to a colleague. They will
be shown the command you wish to run, and asked to approve or reject it.

If you don't know the name of the deployment/pod you want see [Find the name of
a deployment or pod](#find-the-name-of-a-deployment-or-pod)

Once a colleague approves your JobRequest, Kubernetes will launch a new Job
which copies the configuration of the deployment or pod you specified, and
executes the command you specified in the JobRequest. This will be executed in
the container named `app`, if you need to run a differently named container in
the pod you can change it with the `--container` flag

Usage:

```shell
govuk-cli jobrequest create <deployment_or_pod_name> \
  [--namespace=<namespace (default apps)>] [--follow] [--container=<container_name>] \
  -- \
  <command> <args...>
```

Example:

```shell
$ govuk-cli jobrequest create deployment/govuk-replatform-test-app -- rake hello
2026/09/04 11:34:09 INFO Job request created
┌─────────────────┬────────────────────────────────────────┐
│ Name            │ jr-govuk-replatform-test-app-250793236 │
│ Command         │ rake hello                             │
│ Source Workload │ deployment/govuk-replatform-test-app   │
└─────────────────┴────────────────────────────────────────┘
Review command:
 $ govuk-cli jobrequest review -n apps jr-govuk-replatform-test-app-250793236
```

Example in which the logs are printed out to you once the job starts:

```shell
$ govuk-cli jobrequest create deployment/govuk-replatform-test-app --follow -- rake hello
2026/09/04 11:50:12 INFO Job request created
┌─────────────────┬────────────────────────────────────────┐
│ Name            │ jr-govuk-replatform-test-app-243822854 │
│ Command         │ rake hello                             │
│ Source Workload │ deployment/govuk-replatform-test-app   │
└─────────────────┴────────────────────────────────────────┘
Review command:
 $ govuk-cli jobrequest review -n apps jr-govuk-replatform-test-app-243822854
2026/09/04 11:50:12 INFO Following JobRequest. Logs will stream once Job has started... jobRequestName=jr-govuk-replatform-test-app-243822854
2026/09/04 11:57:13 INFO Job created... job=jr-govuk-replatform-test-app-243822854 jobRequestState=Complete
2026/09/04 11:57:14 INFO Tailing logs from pod... pod=jr-govuk-replatform-test-app-243822854-zjlg4
INFO: with_tmpdir_for_ruby: execing rake with TMPDIR=/tmp/ruby-app-yoUXmHrb
...SNIP...
Hello World!
```

#### Find the name of a deployment or pod

First you need to decide what deployment/pod do you want the job to run in.
It's usually easiest targetting a deployment. You can get a list of the
deployments with kubectl. You can do the same for pods.

```shell
# Get all the deployments
$ kubectl get deployments -n apps
NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
account-api                        2/2     2            2           290dg
account-api-redis                  1/1     1            1           414d
...SNIP...
whitehall-admin-redis              1/1     1            1           414d
whitehall-admin-worker             2/2     2            2           290d

# Filter the list with grep
$ kubectl get deployments -n apps | grep whitehall
whitehall-admin                    2/2     2            2           290d
whitehall-admin-redis              1/1     1            1           414d
whitehall-admin-worker             2/2     2            2           290d

# Get pods instead (there will be a lot more returned than deployments)
$ kubectl get pods -n apps | grep whitehall-admin
whitehall-admin-65b6d995b4-hxnk6                                  2/2     Running            0                 98m
whitehall-admin-65b6d995b4-vp9w7                                  2/2     Running            0                 97m
...SNIP...
whitehall-admin-worker-86b9fff5db-m2m6w                           1/1     Running            0                 98m
whitehall-admin-worker-86b9fff5db-p962w                           1/1     Running            0                 98m
```

Then you can run the command to create a JobRequest with either a deployment or
pod:

```shell
# With a deployment
govuk-cli jobrequest create deployment/whitehall-admin -- rake republish_political_content

# With a pod
govuk-cli jobrequest create whitehall-admin-65b6d995b4-hxnk6 -- rake republish_political_content
```

### Reviewing a JobRequest

If a colleague asks you to review their JobRequest you should carefully review
the command they wish to run before approving or rejecting it. It is likely the
colleague will send you the command you need to run in order to review their
JobRequest. You will be prompted for your decision, running the command alone
is not enough so you cannot approve it accidentally.

Usage:

```shell
govuk-cli jobrequest review <jobrequest> [--follow] [--namespace=<namespace (default apps)>]
```

Example:

```shell
$ govuk-cli jobrequest review jfharden-jr-fail-1 --follow
┌──────────────────┬──────────────────────────────────────┐
│ Job Request Name │ jfharden-jr-fail-1                   │
│ Command          │ rake failed                          │
│ Source Workload  │ deployment/govuk-replatform-test-app │
│ Status           │ Pending                              │
│ Requested By     │ impersonated.user (platformengineer) │
└──────────────────┴──────────────────────────────────────┘
Review options: [A]pprove [R]eject
Your decision: A
Comment: Test JobRequest which will spawn a failing job
┌──────────────────┬────────────────────────────────────────────────┐
│ Job Request Name │ jfharden-jr-fail-1                             │
│ Decision         │ Approved                                       │
│ Comment          │ Test JobRequest which will spawn a failing job │
└──────────────────┴────────────────────────────────────────────────┘
Submit review? [Y/n]: Y
2026/09/04 14:02:30 INFO Reviewed job request jobRequestName=jfharden-jr-fail-1 jobRequestReviewName=jrr-jfharden-jr-fail-1
```

You can also follow the logs of the JobRequest you are approving with the
`--follow` flag:

```shell
$ govuk-cli jobrequest review jfharden-jr-fail-1 --follow
┌──────────────────┬──────────────────────────────────────┐
│ Job Request Name │ jfharden-jr-fail-1                   │
│ Command          │ rake failed                          │
│ Source Workload  │ deployment/govuk-replatform-test-app │
│ Status           │ Pending                              │
│ Requested By     │ impersonated.user (platformengineer) │
└──────────────────┴──────────────────────────────────────┘
Review options: [A]pprove [R]eject
Your decision: A
Comment: Test JobRequest which will spawn a failing job
┌──────────────────┬────────────────────────────────────────────────┐
│ Job Request Name │ jfharden-jr-fail-1                             │
│ Decision         │ Approved                                       │
│ Comment          │ Test JobRequest which will spawn a failing job │
└──────────────────┴────────────────────────────────────────────────┘
Submit review? [Y/n]: Y
2026/09/04 14:02:30 INFO Reviewed job request jobRequestName=jfharden-jr-fail-1 jobRequestReviewName=jrr-jfharden-jr-fail-1
2026/09/04 14:02:30 INFO Following JobRequest. Logs will stream once Job has started... jobRequestName=jfharden-jr-fail-1
2026/09/04 14:02:30 INFO Job created... job=jfharden-jr-fail-1 jobRequestState=Started
2026/09/04 14:02:31 INFO Tailing logs from pod... pod=jfharden-jr-fail-1-7znhf
INFO: with_tmpdir_for_ruby: execing rake with TMPDIR=/tmp/ruby-app-mWGlewoH
...SNIP...
Failed! Exiting process
```

## Using Kubectl to view JobRequests and JobRequestReviews

* [Viewing a JobRequest or JobRequestReview](#viewing-a-jobrequest-or-jobrequestreview)
* [Listing JobRequests or JobRequestReviews](#listing-jobrequests-or-jobrequestreviews)
* [Showing the Job that was launched from a JobRequest](#showing-the-job-that-was-launched-from-a-jobrequest)
* [Viewing the logs for the Job that was launched from a JobRequest](#viewing-the-logs-for-the-job-that-was-launched-from-a-jobrequest)

The process for interrogating Kubernetes for JobRequests and JobRequestReviews
is the same as any other Kubernetes resources.

* You can use either the full resource names (which are case insensitive):
  JobRequest, JobReqeustReview; or
* The short names: jr, jrr (respectively)

### Viewing a JobRequest or JobRequestReview

JobRequests

```shell
$ kubectl get jobrequest jfharden-jr-fail-1 -o yaml
apiVersion: platform.publishing.service.gov.uk/v1
kind: JobRequest
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      ...SNIP...
    platform.publishing.service.gov.uk/requested-by: arn:aws:sts::430354129336:assumed-role/impersonated.user-platformengineer/1788519275271637000
  creationTimestamp: "2026-09-04T13:01:26Z"
  generation: 1
  name: jfharden-jr-fail-1
  namespace: apps
  resourceVersion: "6044034"
  uid: 4e1df2aa-8b1e-45bd-9aeb-5aa18c57b893
spec:
  args:
  - failed
  command: rake
  containerFrom:
    containerName: app
    podSpecFrom:
      group: apps/v1
      kind: Deployment
      name: govuk-replatform-test-app
status:
  jobName: jfharden-jr-fail-1
  reviewName: jrr-jfharden-jr-fail-1
  state: Failed
```

JobRequestReviews

```shell
$ kubectl get jobrequestreview jrr-jfharden-jr-fail-1 -o yaml
apiVersion: platform.publishing.service.gov.uk/v1
kind: JobRequestReview
metadata:
  annotations:
    platform.publishing.service.gov.uk/reviewed-by: arn:aws:sts::430354129336:assumed-role/jonathan.harden-platformengineer/1788526823471185000
  creationTimestamp: "2026-09-04T13:02:30Z"
  generation: 1
  name: jrr-jfharden-jr-fail-1
  namespace: apps
  resourceVersion: "6043938"
  uid: c18e078b-1b38-447d-989a-be591937bcb1
spec:
  decision: Approved
  description: Test JobRequest which will spawn a failing job
  jobRequestName: jfharden-jr-fail-1
status:
  state: Approved
```

### Listing JobRequests or JobRequestReviews

JobRequests

```shell
$ kubectl get jobrequests
NAME                                                      COMMAND   ARGUMENTS            STATE       JOB NAME                                  AGE
jfharden-jr-fail-1                                        rake      ["failed"]           Failed      jfharden-jr-fail-1                        7m10s
jr-govuk-replatform-test-app-1520372482                   rake      ["hello"]            Complete    jr-govuk-replatform-test-app-1520372482   9d
jr-govuk-replatform-test-app-238732814                    rake      ["broken"]           Failed      jr-govuk-replatform-test-app-238732814    8d
jr-govuk-replatform-test-app-243822854                    rake      ["hello"]            Complete    jr-govuk-replatform-test-app-243822854    138m
jr-govuk-replatform-test-app-250793236                    rake      ["hello"]            Pending                                               154m
jr-govuk-replatform-test-app-383261423                    rake      ["hello"]            Pending                                               6d23h
jr-govuk-replatform-test-app-388482386                    rake      ["hello"]            Complete    jr-govuk-replatform-test-app-388482386    8d
jr-govuk-replatform-test-app-547582753                    rake      ["rejected"]         Rejected                                              8d
jr-govuk-replatform-test-app-603072327                    rake      ["hello","--help"]   Pending                                               140m
jr-govuk-replatform-test-app-f45ff4fdd-zld5s-1127513522   rake      ["hello:world"]      Malformed                                             8d
```

JobRequestReviews:

```shell
$ kubectl get jobrequestreviews
NAME                                          JOB REQUEST                               STATE      AGE
jfharden-jrr-approve-1                        jr-govuk-replatform-test-app-243822854    Approved   133m
jrr-jfharden-jr-fail-1                        jfharden-jr-fail-1                        Approved   6m35s
jrr-jr-govuk-replatform-test-app-1520372482   jr-govuk-replatform-test-app-1520372482   Approved   8d
jrr-jr-govuk-replatform-test-app-1520372489   jr-govuk-replatform-test-app-388482386    Approved   8d
jrr-jr-govuk-replatform-test-app-1520372999   jr-govuk-replatform-test-app-238732814    Approved   8d
jrr-jr-govuk-replatform-test-app-547582753    jr-govuk-replatform-test-app-547582753    Rejected   6d23h
```

### Showing the Job that was launched from a JobRequest

Note: Kubernetes cleans up Jobs after they have run in a much shorter time
scale than we clear up JobRequests and JobRequestReviews, so the Job may not be
present anymore and you will need to look in Logit for the Jobs logs. If you
run `govuk-cli jobrequest get <jobrequest>` it will give you a pre-populated
link to the logs in logit.

The name of the Kubernetes Job that a JobRequest caused to be launched is
available in the `status.jobName` field of the JobRequest, so you first need to
get that Job name, then you can query for the Job (it will usually have the
same name as the JobRequest):

```shell
$ kubectl get jr jfharden-jr-fail-1 -o=jsonpath='{.status.jobName}{"\n"}'
jfharden-jr-fail-1

$ kubectl get job jfharden-jr-fail-1 -o yaml
apiVersion: batch/v1
kind: Job
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
    kubectl.kubernetes.io/last-applied-configuration: |
      ...SNIP...
    reloader.stakater.com/auto: "true"
  creationTimestamp: "2026-09-04T13:02:30Z"
  generation: 1
  labels:
    app: govuk-replatform-test-app
    app.kubernetes.io/arch: arm64
    app.kubernetes.io/name: govuk-replatform-test-app
  name: jfharden-jr-fail-1
  namespace: apps
  ownerReferences:
  - apiVersion: platform.publishing.service.gov.uk/v1
    blockOwnerDeletion: true
    controller: true
    kind: JobRequest
    name: jfharden-jr-fail-1
    uid: 4e1df2aa-8b1e-45bd-9aeb-5aa18c57b893
  resourceVersion: "6044032"
  uid: b7c1b3fe-b7a1-485f-9a3e-02d4d22a1eb2
spec:
  ...SNIP...
status:
  conditions:
    ...SNIP...
  failed: 1
  ready: 0
  startTime: "2026-09-04T13:02:30Z"
  terminating: 0
  uncountedTerminatedPods: {}
```

### Viewing the logs for the Job that was launched from a JobRequest

You will need to find the Job name as described in [Showing the Job that was
launched from a
JobRequest](#showing-the-job-that-was-launched-from-a-jobrequest), then you can
query kubernetes for the logs:

```shell
$ kubectl logs job/jfharden-jr-fail-1
INFO: with_tmpdir_for_ruby: execing rake with TMPDIR=/tmp/ruby-app-mWGlewoH
...SNIP...
Failed! Exiting process
```

If the logs are no longer available in Kubernetes you will need to look in
Logit for the Jobs logs (if you run `govuk-cli jobrequest get <jobrequest>` it
will give you a pre-populated link to the logs in logit).

## Installing govuk-cli

You should install `govuk-cli` using [Homebrew](https://brew.sh). Run the
following command line:

```shell
brew install alphagov/gds/govuk-cli
```

You can test that govuk-cli is working by running `govuk-cli --version`:

```shell
$ govuk-cli --version
govuk-cli version 0.0.8
```
