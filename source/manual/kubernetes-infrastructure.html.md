---
owner_slack: "#govuk-2ndline-tech"
title: EKS/Kubernetes infrastructure
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
type: learn
---

This is a temporary page to tide us over as we get used to the new EKS platform.
It will eventually be consolidated when the [GOV.UK Kubernetes docs](https://govuk-k8s-user-docs.publishing.service.gov.uk/) are absorbed into the Developer Docs.

## Quick reference

You need to have completed the [set up instructions](https://govuk-k8s-user-docs.publishing.service.gov.uk/get-started/set-up-tools/) and [tested your access](https://govuk-k8s-user-docs.publishing.service.gov.uk/get-started/access-eks-cluster/#test-your-access).

The following commands assume you have `alias k=kubectl` as per the [kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/), and also set the `apps` namespace as your default (`k config set-context --current --namespace=apps`).

You'll need to [set your region and context](https://govuk-k8s-user-docs.publishing.service.gov.uk/get-started/access-eks-cluster/#select-a-role-and-environment) as below (swapping out the environment as appropriate. Note that the `poweruser` role is required as a minimum when opening shell or rails console. `readonly` can be used for accessing logs):

```sh
export AWS_REGION=eu-west-1
eval $(gds aws govuk-integration-poweruser -e --art 8h)
```

- To access logs for an app:
    - `k logs deploy/account-api`
- To open a rails console:
    - `k -n apps exec -it deploy/router-api -- rails c`
- To open a shell:
    - `k -n apps exec -it deploy/government-frontend -- bash`
      \>> `curl` # (for example)
- To open a shell on Router:
    - `k -n apps exec -it deploy/router -c nginx`

Read more about each command further on in the document.

## What’s staying and going?

All front-end traffic and back-end publisher traffic is now on Kubernetes (EKS) instead of EC2.

Some things haven't yet been replatformed, and some things will remain unchanged - see [what stays/goes/changes with Replatforming](https://docs.google.com/document/d/1R8C3BtvhqTXEga4C3_KxTopjWuYVbiEgKiikTyRXXiA/edit).

## App deployments

- To see *what's deployed where*, use the [Release](https://release.publishing.service.gov.uk/applications) app.
- Continuously deployed apps will continue to be deployed post-merge, using [ArgoCD](https://argo.eks.integration.govuk.digital/applications). You can see the progress of a workflow in [Argo Workflows](https://argo-workflows.eks.integration.govuk.digital/workflows/apps?limit=50)
- To deploy a branch (or for non-continuously deployed apps):
  - Go to the app’s repo in GitHub
  - Choose Actions
  - Choose Deploy (from the left-hand column).
  - Click “Run workflow”
  - Enter the name of the branch to deploy under "Commit, tag or branch name to deploy".
  - (Always leave the "Use workflow from" option set as `main`, unless you’re actually trying to change the workflow itself)

## CDN and DNS deployments

- DNS rollouts are [via Terraform Cloud](/manual/dns.html)
- Fastly CDN config rollouts are still via Jenkins for now.

## Smokey

Smokey results persist for longer only if they have failed.

## Dashboards, alerting and Icinga

- The Technical 2nd Line Dashboard will be kept up to date as we improve our dashboards. It's worth bookmarking <https://govuk-2ndline-dashboard.herokuapp.com/>
- The detailed Sidekiq dashboard is not yet available for EKS (the [old one](https://sidekiq-monitoring.integration.govuk.digital/publishing-api/queues) still looks at EC2) but you can see queue lengths and age-of-oldest-job on the [Sidekiq Grafana dashboard](https://grafana.eks.production.govuk.digital/d/2Yy8PzmVk).
- Dashboards are on <https://grafana.eks.production.govuk.digital/> and no longer require VPN. Don’t get confused by the [old Grafana](https://grafana.production.govuk.digital/), which will show mostly empty graphs about the old EC2 setup.
- Most Icinga alerts are irrelevant now, **except for**:
    - “scheduled publications in Whitehall not queued” / “overdue publications in Whitehall”
    - “Travel Advice email alert check” / “Medical Safety Email alert check”
    - Anything to do with crawler/mirrors
    - Anything to do with Licensify

## Fetch logs

You can fetch the list of pods:

```sh
k get pods
```

This will return a list, including output like:

```
NAME                                                              READY   STATUS             RESTARTS           AGE
account-api-568d46d6f7-4pnld                                      2/2     Running            0                  34m
account-api-568d46d6f7-txwsx                                      2/2     Running            0                  34m
account-api-dbmigrate-6n5mp                                       0/1     Completed          0                  35m
account-api-worker-54597b666c-jlcfn                               1/1     Running            0                  34m
asset-manager-7bd745d655-tzlgz                                    2/2     Running            0                  15h
...
```

As you can see above, each pod either runs the application (we can see two pods running Account API, for example) or runs a worker or cron job for the application (we can see one pod running the Account API application worker).

You can fetch the logs for all running containers in a pod. Take one of the pods from the output above:

```sh
k logs account-api-568d46d6f7-4pnld
```

Or you can fetch the logs using its 'app deployment' name. This will choose one of the Account API pods at random, much like the old jumpbox methods:

```sh
k logs deploy/account-api
```

## Open a rails console

Open a rails console with:

```sh
k exec -it deploy/whitehall-admin -- rails c
```

If you try doing this having assumed a `readonly` role when setting context, you'll see a permissions error:

```sh
Defaulted container "app" out of: app, nginx
Error from server (Forbidden): pods "whitehall-admin-6bb47c48d-wkkxk" is forbidden: User "christopher.ashton-user" cannot create resource "pods/exec" in API group "" in the namespace "apps"
```

You need write permissions to be able to open a console (`poweruser` or above).

## Open a shell

Open a shell (requires `poweruser` or above):

```sh
k exec -it deploy/whitehall-admin -- bash
```

Note that the prompt will have prefix that may feel a little unfamiliar: `I have no name!@whitehall-admin-6bb47c48d-wkkxk:/app$`.
This only happens for asset-manager and whitehall-admin, because those have to run as a specific user ID that matches what's on NFS (due to how NFS was set up on the old system).

To open a shell on Router, you'll need to exec into the nginx container:

```sh
k exec -it deploy/router -c nginx -- bash
```

This is because [Router's image is `FROM scratch`](https://github.com/alphagov/router/blob/9797473edbbcbb5085fdca006bec7f6b1552f4e6/Dockerfile#L7), so bash isn't available.

## Run a rake task

See [Run a Rake task on EKS](/manual/running-rake-tasks.html#run-a-rake-task-on-eks)

Here's an idempotent rake task you can run to try one out:

```sh
k exec deploy/email-alert-api -- rake 'support:view_emails[your.email@digital.cabinet-office.gov.uk]'
```

Note that we haven't specified the `-it` flags in the command above because we don't need to interact with the task.
To find out what they do, run `k exec --help`.

### Testing changes to a rake task

For special router publisher as an example:

1. Deploy your branch (see above)
2. Run the following command(s):

```sh
BASE_PATH=whatever

kubectl run -n apps --image 172025368201.dkr.ecr.eu-west-1.amazonaws.com/special-route-publisher special-route-publisher -- rake "publish_one_special_route[${BASE_PATH?}]"

kubectl logs -fnapps special-route-publisher

kubectl -napps delete po/special-route-publisher
```

There’s also a [command in the PR](https://github.com/alphagov/special-route-publisher/pull/257) that might work.
