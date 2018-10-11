---
owner_slack: "#govuk-platform-health"
title: Use Terraboard to monitor Terraform state
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-27
review_in: 3 months
---

We use [Terraboard](https://camptocamp.github.io/terraboard/) for monitoring
Terraform state across all environments in AWS.

## Using Terraboard

* [Integration](https://terraboard.integration.govuk.digital/)
* [Staging](https://terraboard.staging.govuk.digital/)
* [Production](https://terraboard.production.govuk.digital/)

Terraboard displays both summary and detailed information about Terraform
state, when each state file was last modified, the version of Terraform used
to modify it and its history.

## Technical details

Terraboard runs on each environment's `monitoring` machine, in AWS only.

### Docker containers and networking

The Terraboard suite of apps consists of three Docker containers. One runs
Terraboard itself, one runs a PostgreSQL database instance used to cache
Terraform state, and one runs OAuth2 Proxy, an app that authenticates users
using GitHub before proxying requests to Terraboard. Only this last Docker
container is exposed outside of the host machine. The three containers
communicate with each other over a private bridge network named `terranet`.

### Configuration

Terraboard and the PostgreSQL database instance are configured using
environment variables, whereas OAuth2 Proxy uses a config file located in
`/opt/terraboard/conf` on the host machine, which is mounted inside the
container as `/conf`.

### Terraform state file caching

Terraboard runs a task every minute which fetches all Terraform state files
from the configured S3 bucket (`govuk-terraform-steppingstone-<environment>`)
and caches their content in the PostgreSQL database. This decreases the amount
of S3 traffic and makes the app faster.

### Authentication

OAuth2 Proxy is configured to authenticate users using GitHub. A GitHub OAuth
app for each environment exists and is owned by `alphagov`, which provides the
OAuth credentials required for authentication.

Only users who are members of the `alphagov` organisation and the `GOV.UK Production`
team are granted access. Access checks are refreshed after an hour.

### Proxying

nginx proxies all requests to OAuth2 Proxy, which is exposed on port 4180 on the
host machine. This port corresponds to port 7920 in the container. OAuth2 Proxy
then proxies all authenticated requests on to port 8080 of the Terraboard
container.

### Docker image for OAuth2 Proxy

Since there is no official Docker image for OAuth2 Proxy, the
[govuk-oauth2-proxy-docker](https://github.com/alphagov/govuk-oauth2-proxy-docker)
repository contains a `Dockerfile` used to build a custom image from the original
source. This image is then pushed to Docker Hub, from where it is downloaded and run.

There are instructions on how to update, build and push new versions of the image
in the [README](https://github.com/alphagov/govuk-oauth2-proxy-docker/blob/master/README.md).
