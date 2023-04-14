---
owner_slack: "#govuk-2ndline-tech"
title: EKS/Kubernetes infrastructure
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
type: learn
---

> **Note** The contents of this page was originally in a [Trello card](https://trello.com/c/hGxUILgr/1871-were-now-on-kubernetes) and notes by Leena.

All front-end traffic and back-end publisher traffic is now on Kubernetes (EKS) instead of EC2 (see [status update doc](https://docs.google.com/document/d/1BzPqMT57zXg6wL5D7vYTmKu85T4ZuDcaw5twOGPP1p0/edit "‌") and [runbook](https://docs.google.com/spreadsheets/d/1TusO_GJ5Ustte6RnZ6LIwZ8N4ZILidQ77taTClbaPB8/edit "‌")). 🎉 Also useful to bookmark this document describing [what stays/goes/changes with Replatforming](https://docs.google.com/document/d/1R8C3BtvhqTXEga4C3_KxTopjWuYVbiEgKiikTyRXXiA/edit "‌"), and the [GOV.UK Kubernetes docs](https://govuk-k8s-user-docs.publishing.service.gov.uk/ "‌").

Things we used to do on EC2 now need to be done differently on EKS.

## Deployments

- You can still use the [Release](https://release.publishing.service.gov.uk/applications "‌") app to see what is deployed where. NB, release tags are going away, but will still be created for as long as we auto-deploy to both EKS and EC2.
- Continuously deployed apps will continue to be deployed post-merge, using [ArgoCD](https://argo.eks.integration.govuk.digital/applications "‌"). You can see the progress of a workflow in [Argo Workflows](https://argo-workflows.eks.integration.govuk.digital/workflows/apps?limit=50 "‌")
- Non-continuously deployed apps can be manually deployed by:
    - Go to the app’s repo in GitHub, then choose Actions, then Deploy (from the left-hand column).
    - Click “Run workflow” and enter the default branch name (usually `main`) under "Commit, tag or branch name to deploy". (Always leave the "Use workflow from" option set as `main`, unless you’re actually trying to change the workflow itself.)
- To deploy a branch, follow the manual deploy steps above, providing the branch name in "Commit, tag or branch name to deploy".
- DNS rollouts are still via Jenkins for now (so no change, e.g. `gds govuk dns -r govuk-production-admin -z service.gov.uk -a plan -p aws`)
- Fastly CDN config rollouts are also still via Jenkins for now.

## Deploy a branch to integration

1. Go here: [https://github.com/alphagov/frontend/actions/workflows/deploy.yml](https://github.com/alphagov/frontend/actions/workflows/deploy.yml)
2. Click “Run workflow”
3. Leave, “use workflow” as “main”, then enter the branch name and environment details

## Smokey results

Smokey results persist for longer only if they have failed.

## Interacting with apps

The following commands assume you have `alias k=kubectl` as per the [https://kubernetes.io/docs/reference/kubectl/cheatsheet/](https://kubernetes.io/docs/reference/kubectl/cheatsheet/ "smartCard-inline") .

## Run a rake task

[Run a Rake task on EKS](https://docs.publishing.service.gov.uk/manual/running-rake-tasks.html#run-a-rake-task-on-eks "‌")

### Other tasks

- To open a rails console:
    - `k -n apps exec -it deploy/router-api -- rails c`
- To open a shell:
    - `k -n apps exec -it deploy/government-frontend -- bash`
      \>> `curl` # (for example)
- To open a shell on Router:
    - `k -n apps exec -it deploy/router -c nginx`

Note that you can omit the `-n apps` bit of the above commands if you specify a default namespace (recommended), by:

- `k config set-context --current --namespace=apps`

#### Testing changes to a rake task.

For special router publisher as an example:

1. Deploy your branch (see above)
2. Run the following command(s):

```
BASE_PATH=whatever

kubectl run -n apps --image 172025368201.dkr.ecr.eu-west-1.amazonaws.com/special-route-publisher special-route-publisher -- rake "publish_one_special_route[${BASE_PATH?}]"

kubectl logs -fnapps special-route-publisher

kubectl -napps delete po/special-route-publisher

```

There’s also a [command in the PR](https://github.com/alphagov/special-route-publisher/pull/257) that might work.

## Dashboards and alerting

- The detailed Sidekiq dashboard is not yet available for EKS (the [old one](https://sidekiq-monitoring.integration.govuk.digital/publishing-api/queues "‌") still looks at EC2) but you can see queue lengths and age-of-oldest-job on the [Sidekiq Grafana dashboard](https://grafana.eks.production.govuk.digital/d/2Yy8PzmVk "‌").
- Dashboards are on [https://grafana.eks.production.govuk.digital/](https://grafana.eks.production.govuk.digital/?orgId=1 "‌") and no longer require VPN. Don’t get confused by the [old Grafana](https://grafana.production.govuk.digital/ "‌"), which will show mostly empty graphs about the old EC2 setup.
- Most Icinga alerts are irrelevant now, except for:
    - “scheduled publications in Whitehall not queued” / “overdue publications in Whitehall”
    - “Travel Advice email alert check” / “Medical Safety Email alert check”
    - Anything to do with crawler/mirrors
    - Anything to do with Licensify

## Testing EKS access

See [testing your eks cluster access in the GOV.UK Kubernetes platform user documentation](https://govuk-k8s-user-docs.publishing.service.gov.uk/get-started/access-eks-cluster/#test-your-access)

## Kubernetes cheat sheet

[Official k8s cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## What’s staying and going?

[Document outlining what changes are happening to GOV.UK infrastructure](https://docs.google.com/document/d/1R8C3BtvhqTXEga4C3_KxTopjWuYVbiEgKiikTyRXXiA/edit#)
