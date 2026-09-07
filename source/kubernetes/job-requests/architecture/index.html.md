---
title: JobRequest Architecture
weight: 10
layout: multipage_layout
---

# JobRequest Architecture

## System Components

* [govuk-job-request-operator](/repos/govuk-job-request-operator.html):
  This includes:
  * [Custom Resource Defitinitions
    (CRDs)](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
    for JobRequest (short name `jr`) and JobRequestReview (short name `jrr`)
    resources
  * [Kubernetes
    Operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)
    which is responsible for reconcilling the JobRequest and JobRequestReview
    resources
  * [Kubernetes Mutating Admission
  Policy](https://kubernetes.io/docs/reference/access-authn-authz/mutating-admission-policy/)
    which is responsible for validating, and adding the AWS ARN of the
    requesting user into annotations on the JobRequest and JobRequestReview
    during admission
  * [Garbage
    collection](https://kubernetes.io/docs/concepts/architecture/garbage-collection/)
    to clean up JobRequest and JobRequestReview resoureces more than 30 days old
* [OPA
  Gatekeeper](https://kubernetes.io/blog/2019/08/06/opa-gatekeeper-policy-and-governance-for-kubernetes/)
  [policies](https://github.com/alphagov/govuk-infrastructure/tree/main/terraform/deployments/cluster-services/modules/gatekeeper)
  responsible for validating API requests to create/update JobRequest and
  JobRequestReview resources, and providing useful error messages to the end user
  if the request is denied.
* [govuk-cli](/repos/govuk-job-request-operator.html): A command line interface
  with a jobrequest subcommand which is the primary interface developers are
  expected to use to create and review JobRequests. This also does validation
  prior to making create requests to the Kubernetes API to give the most friendly
  error messages possible.

## Expected usage

The following describes the intended happy path from creation of a JobRequest to Job completion.

1. User A uses `govuk-cli` to create a JobRequest, it prints out the CLI command which can be used to review the JobRequest, and waits to show the logs from the Job that will be created later.
2. User A sends User B the printed out CLI command to run in order to review the request.
3. User B runs the CLI command, reads and reviews the command intended to run, chooses to approve or reject it, then `govuk-cli` creates a JobRequestReview.
4. Review outcome:
    a. If user B rejects the JobRequest, assuming user A is still following the logs, user A will see a message telling them the request was rejected. This flow ends here.
    b. If user B approves the JobRequest then continue this process
5. The JobRequest operator will change the Status of the JobRequest to approved.
6. The JobRequest operator will read the pod spec it needs to create from the target resource specified in the JobRequest
7. The JobRequest operator will create a Kubernetes Job from the pod spec retrieved in the previous step, overriding the command to be the one approved in the JobRequest
8. The JobRequest operator will update the Status of the JobRequest to include the name of the Job that was created
9. The govuk-cli command that was run in step 1. will see the Job has been created, inform user A, and start printing out the logs of the Job as they are produced.
9. The JobRequest operator will watch for the status of the Job and update the JobRequest status to include the current state of the Job.
10. When the status of the Job reaches a terminal state, the govuk-cli will stop following the logs and inform User A the Job has completed.

### Sequence Diagram for an Approved JobRequest

<pre lang="mermaid">

<code>
sequenceDiagram
    participant Requester
    participant Reviewer
    participant requesters-govuk-cli
    participant reviewers-govuk-cli
    participant Operator

    Requester->>requesters-govuk-cli: `govuk-cli create jobrequest... --follow`
    requesters-govuk-cli->>Operator: Create JobRequest
    Requester->>Reviewer: Please review my request
    Reviewer->>reviewers-govuk-cli: `govuk-cli jobrequest review...` Approved
    reviewers-govuk-cli->>Operator: Create Approved JobRequestReview
    Operator->>Kubernetes: Create Job
    Operator->>requesters-govuk-cli: Job has started
    Operator->>requesters-govuk-cli: Logs
    requesters-govuk-cli->>Requester: Logs
    Operator->>requesters-govuk-cli: More Logs
    requesters-govuk-cli->>Requester: More Logs
    Operator->>requesters-govuk-cli: Job Complete
    requesters-govuk-cli->>Requester: Job Complete
</code>
</pre>

### Sequence Diagram for a Rejected JobRequest

<pre lang="mermaid">

<code>
sequenceDiagram
    participant Requester
    participant Reviewer
    participant requesters-govuk-cli
    participant reviewers-govuk-cli
    participant Operator

    Requester->>requesters-govuk-cli: `govuk-cli create jobrequest... --follow`
    requesters-govuk-cli->>Operator: Create JobRequest
    Requester->>Reviewer: Please review my request
    Reviewer->>reviewers-govuk-cli: `govuk-cli jobrequest review...` Rejected
    reviewers-govuk-cli->>Operator: Create Rejected JobRequestReview
    Operator->>requesters-govuk-cli: JobRequest Rejected
    requesters-govuk-cli->>Requester: JobRequest Rejected
</code>
</pre>

## Garbage Collection

Any time a JobRequest or JobRequestReview resource is presented for
reconcilliation, if it was created longer than the TTL duration (which is set
for 720 hours (30 days)), it will be deleted.

The [Kubernetes Controller Runtime
configuration](https://pkg.go.dev/sigs.k8s.io/controller-runtime/pkg/cache#Config)
includes a SyncPeriod, any resources managed by the controller runtime will be
presented to the operator every time the `SyncPeriod` has elapsed.

The SyncPeriod in the [is configurable in the
govuk-job-request-operator](https://github.com/alphagov/govuk-job-request-operator#configuration)
by setting the `--resource-ttl` flag.

## Architecture Diagrams

### JobRequest state diagram

<pre lang="mermaid">

<code>
stateDiagram
    state "''" as NoState

    [*] --> NoState
    NoState --> Malformed
    NoState --> Pending
    Pending --> Rejected
    Pending --> Approved
    Approved --> Started
    Started --> Complete
    Started --> Failed
    Complete --> [*]
    Failed --> [*]
</code>
</pre>

### JobRequestReview state diagram

<pre lang="mermaid">

<code>
stateDiagram
    [*] --> Approved
    [*] --> Rejected

    Approved --> JobRequestNotFound
    Approved --> JobRequestMalformed
    Approved --> Conflict

    Rejected --> JobRequestNotFound
    Rejected --> JobRequestMalformed
    Rejected --> Conflict

    Approved --> [*]
    Rejected --> [*]
    JobRequestNotFound --> [*]
    JobRequestMalformed --> [*]
    Conflict --> [*]
</code>
</pre>

### Creating a JobRequest Flowchart

<pre lang="mermaid">

<code>
flowchart TD
    RequesterA@{ shape: person }
    RequesterB@{ shape: person }
    govuk-cli

    RequesterA--govuk-cli jobrequest create ...-->govuk-cli
    govuk-cli--Create JobRequest-->k8sAPI

    RequesterB--Create JobRequest-->k8sAPI

    subgraph k8s[Kubernetes]
        direction TD

        k8sAPI[Kubernetes API]
        MutatingAdmissionPolicy
        gatekeeper[OPA Gatekeeper]
        govuk-job-request-operator[Operator JobRequest controller]
        etcd[(Etcd)]

        k8sAPI-- Create JobRequest -->MutatingAdmissionPolicy
        MutatingAdmissionPolicy--Create JobRequest-->gatekeeper
        gatekeeper--Create JobRequest-->etcd

        etcd--Created JobRequest-->govuk-job-request-operator

        govuk-job-request-operator-->validateJobRequest{Validate}
        validateJobRequest--valid\n\nSet JobRequest Pending-->k8sAPI
        validateJobRequest--invalid\n\nSet JobRequest Malformed-->k8sAPI
    end
</code>
</pre>

### Reviewing a JobRequest Flowchart

<pre lang="mermaid">

<code>
flowchart TD
    RequesterA@{ shape: person }
    RequesterB@{ shape: person }
    govuk-cli

    RequesterA--govuk-cli jobrequest review ...-->govuk-cli
    govuk-cli--Create JobRequestReview-->k8sAPI

    RequesterB--Create JobRequestReview-->k8sAPI

    subgraph k8s[Kubernetes]
        direction TD

        k8sAPI[Kubernetes API]
        MutatingAdmissionPolicy
        gatekeeper[OPA Gatekeeper]
        govuk-job-request-operator[Operator JobRequestReview controller]
        etcd[(Etcd)]

        k8sAPI-- Create JobRequestReview -->MutatingAdmissionPolicy
        MutatingAdmissionPolicy-- Create JobRequestReview -->gatekeeper
        gatekeeper-- Create JobRequestReview -->etcd

        etcd-- Created JobRequestReview -->govuk-job-request-operator

        govuk-job-request-operator-->validateJobRequestReview{Validate}
        validateJobRequestReview-- invalid\n\nSet JobRequestReview Malformed -->k8sAPI

        validateJobRequestReview-- valid -->jobRequestFound{JobRequest Exists?}
        jobRequestFound-- found\n\nSet state of JobRequestReview to Approved/Rejected\n\nSet state of JobRequest to Approved/Rejected -->k8sAPI
        jobRequestFound-- not-found\n\nSet state of JobRequestReview toJobRequestNotFound -->k8sAPI
    end
</code>
</pre>

### After a JobRequest has been Approved Flowchart

<pre lang="mermaid">

<code>
flowchart TD
    subgraph k8s[Kubernetes]
        direction TD

        k8sAPI[Kubernetes API]
        MutatingAdmissionPolicy
        gatekeeper[OPA Gatekeeper]
        govuk-job-request-operator[Operator JobRequest controller]
        etcd[(Etcd)]

        etcd-- 1. JobRequest Updated -->govuk-job-request-operator
        govuk-job-request-operator<-- 2. Get Pod/Deployment -->k8sAPI

        govuk-job-request-operator-- 3. Create Job -->k8sAPI
        k8sAPI-- 3. Create Job -->etcd

        govuk-job-request-operator-- 4. Watch Job -->k8sAPI

        etcd-- 5. Job State Change --> govuk-job-request-operator
        govuk-job-request-operator-- 5. Update JobRequest with Job State -->k8sAPI
        k8sAPI-- 5. Update JobRequest -->MutatingAdmissionPolicy
        MutatingAdmissionPolicy-- 5. Update JobRequest -->gatekeeper
        gatekeeper-- 5. Update JobRequest -->etcd

    end

</code>
</pre>
