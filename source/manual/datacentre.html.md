---
title: Recovering from a datacentre failure
section: disaster-recovery
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/disaster-recovery/datacentre.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/disaster-recovery/datacentre.md)


# Recovering from a datacentre failure

In each of integration, staging and production there is a disaster recovery (DR) vCloud organisation.

## Things in the disaster recovery datacentre

### Firewall rules

The edge gateway [DR variables file][1] needs to be changed to look more like the [live variables file][2]
so that the correct firewall rules can be deployed.

[1]: https://github.gds/gds/govuk-provisioning/blob/master/vcloud-edge_gateway/vars/production_dr_carrenza_vars.yaml
[2]: https://github.gds/gds/govuk-provisioning/blob/master/vcloud-edge_gateway/vars/production_carrenza_vars.yaml

### Application snapshots

Carrenza take nightly snapshots of our application servers. If we need to use these snapshots we can
ask Carrenza to transform the snapshots into vApp templates.

### Attachments

In DR there is asset-slave-2. This is exactly the same as asset-slave-1, and receives any new uploaded attachments
at the same as the other slave. It also has a daily sync to ensure the data is consistent with the master.

### Bouncer

In the DR organisation there is:

- a second PostgreSQL slave for the Transition database
- Bouncer application servers which read from the DR database slave

### MongoDB

For each MongoDB cluster there is a hidden priority 0 MongoDB node in the disaster recovery organisation
which contains the data but does not participate in elections.

The DR node is hidden because some MongoDB drivers (eg Mongoid) will auto-discover all nodes in a cluster.
This means that applications in the live environment which are only configured to read from the live MongoDB
nodes would also read from the disaster recovery node if it was not hidden, which would cause degraded
performance or outages in publishing applications.

### MySQL

Every MySQL cluster has a slave which is in the disaster recovery organisation and contains an
up-to-date copy of the data.

### PostgreSQL

Every PostgreSQL cluster has a standby which is in the disaster recovery organisation and contains
an up-to-date copy of the data.

## In case of disaster

This section contains a very general outline of what will need to be done to turn the disaster
recovery datacentre into something that can serve real traffic.

### Step zero: notify the hosting provider

If everything is significantly messed up, hopefully Carrenza will have already noticed.

You should phone their [emergency support number][emergency-contact] and open a ticket to inform them
that GOV.UK is unavailable.

[emergency-contact]: ../../2nd-line/contact-numbers-in-case-of-incident.html

### Set up app server templates

[Open a ticket with Carrenza][carrenza-tickets] and tell them that we'd like to use the nightly
GOV.UK application server snapshots as vApp templates in the disaster recovery vCloud organisation.

You should ask Carrenza to do this as early as possible because we have no control over how long
this might take them.

[carrenza-tickets]: https://servicedesk.carrenza.com/

### Start setting up the environment

In the `govuk-provisioning` repo, set up networking and machine templates to
[build an environment][new-env]. As with any other environment, this should start with
the Puppetmaster and Jenkins machines.

[new-env]: ../howto/creating-a-new-environment.html

The vApp templates to use for the application servers will be provided by Carrenza because of
the previous request. Set the templates correctly in the provisioning repo YAML once they become
available.

### Restore data

Use the secondary, standby or slave database machines to restore data following the approach
outlined for the loss of a single database machine:

- [Assets](asset-master.html)
- [MongoDB](mongo-clusters.html)
- [MySQL](mysql-master.html)
- [PostgreSQL](postgresql-primary.html)

