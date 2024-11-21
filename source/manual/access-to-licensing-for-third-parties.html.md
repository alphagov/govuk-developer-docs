---
owner_slack: "#govuk-licensing"
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

Logs can be found in the stacks named "GOV.UK <environment> EKS". For example, "GOV.UK Integration EKS" for integration logs.

You can search using the "kubernetes.labels.app_kubernetes_io/name" field to filter for logs relevant to licensify. For example, `kubernetes.labels.app_kubernetes_io/name: "licensify-frontend"`.

## Testing

The GitHub Actions [`CI` workflow](https://github.com/alphagov/licensify/actions/workflows/ci.yml) runs unit and integration tests for Licensify. This runs automatically on every commit pushed to GitHub and when PRs are merged in to the main branch.

## Releases

When a PR is merged into main and that merge commit sucessful passes, the GitHub Actions [`Release` workflow](https://github.com/alphagov/licensify/actions/workflows/release.yml) runs and creates a new release for that merge commit. The name scheme for release follows the `v<number>` format, where <number> is incremented for each release.

## Building an image and deployment

When a new Release is created, the GitHub Actions [`Deploy` workflow](https://github.com/alphagov/licensify/actions/workflows/deploy.yml) builds a new container image, pushes the image to GitHub Packages and triggers a deployment in the Kubernetes cluster.

Every new release is automatically deployed to integration.

To deploy to staging or production, you need to manually trigger the [`Deploy` workflow](https://github.com/alphagov/licensify/actions/workflows/deploy.yml). This can be done via the GitHub Web UI by selecting "Run workflow" in the top right corner above the list of workflow runs. Enter the release name you wish to deploy e.g. `v24` into the field labelled "Commit, tag or branch name to deploy", then select the "Environment to deploy to" and then select "Run workflow".

## Using Kubernetes

The licensing application stack is now orchestrated on Kubernetes clusters (running on AWS EKS).

### Getting Accesss

To interact with the Kubernetes cluster, you will need to authenticate via the AWS CLI. For more help on how to set up the necessary CLI tools, read [Set up tools to use the GOV.UK Kubernetes platform
](https://docs.publishing.service.gov.uk/kubernetes/get-started/set-up-tools/).

Access to GDS AWS accounts is managed via GDS Users. You can request a user via the [self-service tool](https://request-an-aws-account.gds-reliability.engineering/) if you have a `@digital-cabinet-office.gov.uk` email address. Once you have a user, ask a GOV.UK Tech Lead to be given the necessary roles in [govuk-user-reviewer](https://github.com/alphagov/govuk-user-reviewer).

Once you have the necessary permissions and access, you can continue.

The easiest way to do this is with the GDS CLI. You can either chain your commands onto the GDS CLI:

```sh
gds aws govuk-integration-licensinguser -- aws sts get-caller-identity
```

...or you can use the `-e` flag with the GDS CLI to export an AWS session into your terminal:

```sh
eval $(gds aws govuk-integration-licensinguser -e --art 8h)
```

If you can't use the GDS CLI, you can use the `aws-vault exec` command with your manually-created AWS tokens instead:

```sh
aws-vault exec govuk-integration -- aws sts get-caller-identity
```

### Accessing the cluster for the first time

1. Set your AWS credentials as environment variables:

    ```sh
    eval $(gds aws govuk-integration-licensinguser -e --art 8h)
    ```

1. Setup the new context for `kubectl`:

    ```sh
    aws eks update-kubeconfig --name govuk --alias govuk-integration
    ```

1. Set `kubectl` to use that context:

    ```sh
    kubectl config use-context govuk-integration
    ```

Once you're authenticated with AWS, you can check your connection to Kubernetes:

```sh
kubectl -n licensify get deploy
```

You will need to do this setup for each environment (`staging` and `production`). Make sure to replace references to "integration" in the command above with the relevant environment name.

If this works, you can now use `kubectl` to manage the apps in the cluster. We'll assume from this point on that you're authenticated in your shell or are piping the subsequent commands onto the GDS CLI as demonstrated above.

### Observing Apps on Kubernetes

The licensing resources all exist in their own `licensify` namespace, but also carry a set of labels to identify them. You can use these as filters for most commands to find certain deployments, pods or services running within the same namespace:

```txt
app.kubernetes.io/name=licensify-admin
app.kubernetes.io/part-of=licensify
```

To observe all the licensing deployments on the cluster:

```sh
kubectl -n licensify get deploy
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
kubectl -n licensify describe deploy/licensify-admin
````

To view the logs from a deployment:

```sh
kubectl -n licensify logs deploy/licensify-admin
```

You can reuse most of the above commands to view information about the individual pods, for example:

```sh
kubectl -n licensify get pods
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

## Accessing MongoDB

> **Note: This section may need updating**  
> Since the change to Kubernetes, this procedure may no longer work or be a reliable means for accessing the Database.

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
