---
title: Promote Staging to Production
section: disaster-recovery
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/disaster-recovery/promote-staging-to-production.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/disaster-recovery/promote-staging-to-production.md)


# Promote Staging to Production

This document details the steps necessary to promote the Staging environment
to a fully working Production environment in the event of a disaster recovery
scenario.

## Prerequisites

Turn off Licensify. It's better to have it unavailable until
we have time to think about it properly.

Disable Puppet on all machines.

Stop all the apps from running.

Disable data sync from production Jenkins and AWS S3.

## Hieradata changes

Use the disaster recovery YAML file in the hierarchy.

Changing `app_domain` will change the hostnames of all the machines. Old machine
names will need to be purged from PuppetDB using `govuk_node_clean`.
Fabric depends on `govuk_node_list` which uses PuppetDB.

There may be later changes, for example enabling offsite backups.

## Restoring Data

Before restoring any data, ensure the apps are stopped so that they don't
interfere with the data restore.

Add a NAT rule so that you can SSH directly from the staging database
master/primary to the production disaster recovery slave/secondary.

Restores should come from the replicating slaves.

### PostgreSQL

`postgresql` and `api-postgresql` are important.

`transition-postgresql` can be done later. Bouncer will failover
automatically.

### MySQL

`mysql` and `whitehall-mysql` are important.

### MongoDB

`api-mongo`, `mongo` and `router-backend` are important.

`email-campaign-mongo` and `performance-mongo`
can be done later.

### Elasticsearch

`api-elasticsearch` is important.

`elasticsearch` can be rebuilt.

`logs-elasticsearch` is not important.

### Attachments

The whitehall and asset-manager attachments both need to be replicated,
but they are mostly already up to date so can be done last of the data stores.

## Firewall Changes

Remove the firewall rules that apply to staging using conditionals
in the `vars/` file.

## Application Deployments

Redeploy all applications once the hieradata changes have rolled out.

Core infrastructure applications are:

- router
- router-api
- publishing-api

The most important applications for publishing are:

- signon
- whitehall
- publisher

## Access to External Services

External services are accessed using public hostnames over the internet.

## DNS

DNS for `ip-nat-X` and `ip-lb-X` will need to be updated to point to
the location in the `vars/` file.

## Fastly

Repoint Fastly to the origin hostname for staging. Update the SSL certificate
that Fastly expect to receive - it will be different when connecting to this hostname.

## SSH Keys (and keys generated on the servers)

No keys should need to be changed.

## Supporting Services

HMRC webchat is not a priority during a disaster.

Other departments may be hotlinking assets (CSS and JavaScript) from GOV.UK.
These will stop working during a disaster. The mirrors may have copies.

