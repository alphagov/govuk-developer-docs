---
owner_slack: "#govuk-2ndline-tech"
title: Access to Licensify for Third Parties
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

[Licensify](/manual/licensing.html) is a GOV.UK application which is usually supported by third parties.

Once staff at third parties have familiarity with the system and at least BPSS level clearance, a GOV.UK lead developer will request that they're granted [Production Deploy Access](/manual/rules-for-getting-production-access.html#production-deploy-access).

This document explains how to access the Licensify infrastructure as a third party, to perform various maintenance tasks.

## Accessing the source code

The source code is hosted on GitHub at [alphagov/licensify](https://github.com/alphagov/licensify).

## Accessing the logs

Licensify uses an Elasticsearch / Logstash / Kibana system hosted by Logit.io for its logs.

If you haven't already got access to the GDS Logit account, you'll need to [follow the instructions in the Reliability Engineering documentation to create an account in Logit](https://reliability-engineering.cloudapps.digital/logging.html#get-started-with-logit).

## Creating new Builds

Licensify is built into Docker container images with Github Actions Workflows.

If you have access to merge code into main, you will have access to start builds that, once completed, will push container images into AWS ECR (Elastic Container Registry) and then trigger ArgoCD to start a deployment.

Merges to the `main` branch will automatically trigger a build that deploys into Integration. In order to deploy into Staging or Production, you will need to trigger those deploys manually.

## Deploying builds with ArgoCD

Licensify is deployed by ArgoCD. In GOV.UK, we have an ArgoCD instance for each environment.

* [Licensify in ArgoCD for Integration](https://argo.eks.integration.govuk.digital/applications/licensify)
* [icensify in ArgoCD for Staging](https://argo.eks.staging.govuk.digital/applications/licensify)
* [icensify in ArgoCD for Production](https://argo.eks.production.govuk.digital/applications/licensify)

Authentication is with Github SSO, and Access is granted via membership of the following Github groups:

* alphagov:gov-uk
* alphagov:gov-uk-production-deploy

To manage deployments in Production, you need to be a member of `alphagov:gov-uk-production-deploy`.

By default, a successful build on the main branch in Github will notify Argo to start a new deployment. From Argo, you can see an overview of the Kubernetes resources and their current state.

## Using Kubernetes

The licensing application stack is now orchestrated on Kubernetes clusters (running on AWS EKS). 

### Getting Accesss
To interact with the Kubernetes cluster, you will need to authenticate via the AWS CLI. For more help on how to set up the necessary CLI tools, read [Set up tools to use the GOV.UK Kubernetes platform
](https://docs.publishing.service.gov.uk/kubernetes/get-started/set-up-tools/).

Access to GDS AWS accounts is managed via GDS Users. You can request a user via the [self-service tool](https://gds-request-an-aws-account.cloudapps.digital/) if you have a @digital-cabinet-office.gov.uk email address. Once you have a user, ask a GOV.UK Tech Lead to be given the necessary roles in [govuk-user-reviewer](https://github.com/alphagov/govuk-user-reviewer).

Once you have the necessary permissions and access, you can continue.

The easiest way to do this is with the GDS CLI. You can either chain your commands onto the GDS CLI:
```sh
gds aws govuk-integration-admin -- aws sts get-caller-identity
```

...or you can use the `-e` flag with the GDS CLI to export an AWS session into your terminal:
```sh
gds aws govuk-integration-admin -e
```

If you can't use the GDS CLI, you can use the `aws-vault exec` command with your manually-created AWS tokens instead:
```sh
aws-vault exec govuk-integration -- aws sts get-caller-identity
```

Once you're authenticated with AWS, you can check your connection to Kubernetes:
```sh
gds aws govuk-integration-admin --  kubectl cluster-info
```

If this works, you can now use `kubectl` to manage the apps in the cluster. We'll assume from this point on that you're authenticated in your shell or are piping the subsequent commands onto the GDS CLI as demonstrated above.

### Observing Apps on Kubernetes

The licensing resources all exist in their own `licensify` namespace, but also carry a set of labels to identify them. You can use these as filters for most commands to find certain deployments, pods or services running within the same namespace:
```txt
app.kubernetes.io/name=licensify-admin
app.kubernetes.io/part-of=licensify
```

To observe all the licensing deployments on the cluster: 
```sh
kubectl -n licensify get deploy -l app.kubernetes.io/part-of=licensify
```

You should receive a response like: 
```
NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
clamav               1/1     1            1           11d
licensify-admin      1/1     1            1           11d
licensify-feed       1/1     1            1           11d
licensify-frontend   1/1     1            1           11d
```

To view more details about one of the deployments:
```sh
kubectl -n licensify describe deploy licensify-admin
````

To view the logs from a deployment:
```sh
kubectl -n licensify logs deploy/licensify-admin
```

You can reuse most of the above commands to view information about the individual pods, for example:

```sh
kubectl -n licensify get pods -l app.kubernetes.io/part-of=licensify
```

### Accessing live containers

Since the application has been migrated onto Kubernetes, we no longer have a concept of SSH access. Instead, you can exec commands directly on the relevant containers, including an interactive Bash or Shell session:

```sh
kubectl -n licensify exec -it deploy/licensify-admin -- bash
```

If you want to access a specific pod, substitute the deployment for one of the pod names:

```sh
kubectl -n licensify exec -it pod/licensify-admin-5dcf84545-58b9k -- bash
```

The files most relevant to the Licensify applications can be found in:

* Application: `/data/vhost/licensify`
* Logs: `/var/log/licensify`
* Config: `/etc/licensify`

### Relaunching containers

If you want to relaunch an existing deployment, you can either kill the pods (so Kubernetes will replace them), or for more predictable behaviour, you should use the rollout restart command:

```sh
kubectl -n licensify rollout restart deployment/licensify-admin
```

## Accessing MongoDB

**(This section needs updating)**

Licensify uses a MongoDB cluster hosted by AWS (DocumentDB). The database hosts in use by a particular Licensify instance can be found in `/etc/licensing/gds-licensing-config.properties` on the `licensing_backend` machines, in the `mongo.database.*` keys.

```sh
$ grep mongo.database /etc/licensing/gds-licensing-config.properties
# …
mongo.database.hosts=licensify-documentdb-0.abcd1234wxyz.eu-west-1.docdb.amazonaws.com,licensify-documentdb-1.abcd1234wxyz.eu-west-1.docdb.amazonaws.com,licensify-documentdb-2.abcd1234wxyz.eu-west-1.docdb.amazonaws.com
mongo.database.reference.name=licensify-refdata
# …
mongo.database.auth.username=master
mongo.database.auth.password=REDACTED
# …
$ mongo licensify-documentdb-0.abcd1234wxyz.eu-west-1.docdb.amazonaws.com/licensify-refdata -u master
MongoDB shell version v3.6.14
Enter password: REDACTED

…
```
