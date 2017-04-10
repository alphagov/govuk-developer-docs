---
title: Recovering from the loss of MongoDB machines
section: disaster-recovery
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/disaster-recovery/mongo-clusters.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/disaster-recovery/mongo-clusters.md)


# Recovering from the loss of MongoDB machines

If we lose all the MongoDB machines with the live environment, applications
that rely on MongoDB will no longer be able to read or write to the cluster.

## MongoDB clusters

Each Mongo cluster has four machines, three which are available for
reads/writes, and one which is a [Priority
0](https://docs.mongodb.org/v2.4/core/replica-set-priority-0-member/) machine
in the DR environment. This machine is part of the cluster, although it is
hidden so does not take reads/writes from the application.

## Multiple MongoDB machine outage

If the non-priority 0 machines are lost, the current priority 0 machine should
be updated to be a full member of the cluster and no longer hidden.  [These
settings are configured in machine class
hieradata](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/class/mongo.yaml#L27-L33).

Additional (at least two) further machines should be brought up and added to
the cluster. In theory, these machines should be able to automatically connect
and become part of the cluster without any further manual configuration.

In the instance that they do not automatically connect to the cluster, [you may
have to add them to the cluster via the primary as detailed in the
documentation](https://docs.mongodb.org/v2.4/tutorial/deploy-replica-set/).

