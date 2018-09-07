---
owner_slack: "#govuk-2ndline"
title: Reboot a machine
section: Environments
layout: manual_layout
parent: "/manual.html"
important: true
last_reviewed_on: 2018-09-03
review_in: 6 months
next_review_notes: |
    We may be on AWS entirely by the next review. Lots of this is Carrenza specific.
---

## Rules of rebooting

-   *Read this page first* to see if any special cases apply to the type of
    machine you need to reboot.
-   Do not reboot more than one machine of the same class at the
    same time.
-   When rebooting clustered applications (such as Elasticsearch) wait
    for the cluster to recover fully before rebooting the next machine.

## Unattended upgrades

Machines are configured with automatic security updates which install
security updates overnight. Sometimes these require a reboot in order to
become active.

You can review the list of packages on machines (or classes of machines)
with the following command. If you have not done so, you will need to
[set up your fabric scripts first](emergency-publishing.html#set-up-your-fabric-scripts).

    fab $environment all apt.packages_with_reboots

You will then need to decide whether to:

-   Reboot the machine
-   Silence the check until the next package requires update
    (`fab $environment all apt.reset_reboot_needed`)

### Deciding whether to reboot or silence

This can be quite nuanced, before you go ahead with any course of action
gather evidence and then ask in the \#reliability-eng slack room.

Find details of the update from the [Ubuntu Security
Notices](http://www.ubuntu.com/usn/).

-   Is it a remote or local exploit?
-   Is it a kernel update?
-   If it's a shared library, are we using it (see below)?

There is a Fabric task to find all processes using a deprecated library:

    fab $environment all vm.deprecated_library:dbus

## Rebooting one machine

First check whether the machine is safe to reboot. This is stored in
puppet in hieradata. For example,
[here](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/class/mysql_master.yaml)
is an example of a machine that cannot be safely rebooted. The
[default](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_safe_to_reboot/manifests/init.pp)
is `safe_to_reboot::can_reboot: 'yes'`, so if it does not say it is
unsafe, or does not have a class in hieradata at all, then it is safe.

There is a Fabric task to schedule a machine for downtime in Nagios for
20 minutes and then reboot it:

    fab $environment -H graphite-1.management vm.reboot

> **Note (Carrenza only)**
>
> There is a known issue whereby adding an extra disk using the LSI
> Logic Parallel (SCSI) controller to a VM causes the BIOS boot order to
> change, meaning that the system disk cannot be found and the OS does
> not boot when the affected VM is restarted. See the
> manual entry on [adding disks](/manual/adding-disks-in-vcloud.html) for
> more info.

## Rebooting MongoDB machines

You can see our MongoDB machines by running:

    $ fab $environment puppet_class:mongodb::server hosts

All secondary Mongo machines will reboot overnight. If you don't need to
reboot the cluster right now, step the current primary down and allow it
to reboot overnight:

    $ fab $environment -H $hostname mongo.step_down_primary

The general approach for rebooting machines in a MongoDB cluster is:

-   Check cluster status with `fab $environment -H $hostname mongo.status`
-   Using `fab $environment -H $hostname mongo.safe_reboot`
    - reboot the secondaries
    - reboot the primary waiting for the cluster to recover after
    each reboot. The `mongo.safe_reboot` Fabric task automates stepping
    down the primary and waiting for the cluster to recover
    before rebooting.

## Rebooting Elasticsearch machines

To reboot an Elasticsearch machine, run the following command:

    fab $environment -H $hostname elasticsearch.safe_reboot

This will prevent you from rebooting a machine in a cluster which
doesn't have a green cluster health status.

## Rebooting Redis machines

Unless there are urgent updates to apply, these machines should not be
rebooted during working hours in production. Other services rely directly on
particular Redis hosts and may error if they are unvailable.

Reboots of these machines, in the production environment, should be organised
with Platform Health.

They may be rebooted in working hours in other environments, however you
should notify colleagues before doing so as this may remove in-flight jobs
that Sidekiq has added to the Redis queues but not yet processed.

## Rebooting RabbitMQ machines

There's a Fabric task to reboot all nodes in the RabbitMQ cluster,
waiting for the cluster to recover before rebooting the next node.

If there are problems with the cluster (eg, a partition has happened),
the `safe_reboot` script will not reboot anything, and you'll need to
take manual action to resolve the problem.

-   Reboot the nodes in the cluster:

        fab <environment> class:rabbitmq rabbitmq.safe_reboot

If any applications start alerting due to `rabbitmq-1` being rebooted
then either add a note here about how to make that application recover,
or get the team responsible to make it point to the cluster.

## Rebooting asset master and slave machines

Unless there are urgent updates to apply the master machine should not be
rebooted in production during working hours - as the master machine is required
for attachments to be uploaded.

The slave machines can be rebooted as they hold a copy of data and are resynced
regularly.

Reboots of the master machine should be organised with Platform Health,
for the production environment.

You may reboot the master machine in the staging environment during working
hours however it is prudent to warn colleagues that uploading attachments will
be unavailable during this period.

## Rebooting router-backend machines

Router backend machines are instances of MongoDB machines and can be rebooted
as per the [MongoDB rebooting guidance](#rebooting-mongodb-machines).

## Rebooting jumpbox machines

These machines are safe to reboot during the day. During the night they
are involved in a data sync processes and rebooting could cause the data
sync to fail.

## Rebooting backend-lb machines (Carrenza only)

> **Note**
>
> These machines don't exist in AWS environments.

NAT rule points directly at backend-lb-1 for backend services. In order
to safely reboot these machines you'll need access to vCloud Director.

-   reboot backend-lb-2 and wait for it to recover

    `fab <environment> -H backend-lb-2.backend vm.reboot`

    ---
    **NOTE**

    Doing this may trigger a Pagerduty alert and trigger 5xx errors on fastly

    ---

-   find the IP addresses of backend-lb-1 and backend-lb-2 for the
    environment. They will be listed in [this
    repo](https://github.com/alphagov/govuk-provisioning/)
-   use vCloud Director to update the NAT rule to point to backend-lb-2.
    -   The Nat rule will be in [this
        repo](https://github.com/alphagov/govuk-provisioning/).
    -   Go to "Administration"
    -   find 'GOV.UK Management' in the list of vdcs and click on it
    -   select the "edge gateway" tab, right click on it and select
        "edge gateway services"
    -   click the NAT tab.
    -   Find the rule corresponding to the rule defined in the
        vcloud-launcher file, and update the DNAT rules to point to the
        ip address of backend-lb-2 by clicking edit, and updating the
        "Translated (Internal) IP/range" field and click ok to save
        these rules
-   reboot backend-lb-1 and wait for it to recover

    `fab <environment> -H backend-lb-1.backend vm.reboot`

-   use vCloud Director to update the NAT rule to point back to the IP
    address of backend-lb-1

## Rebooting MySQL backup machines (Carrenza only)

> **Note**
>
> These machines are managed by Amazon in AWS and do not require manual intervention.

The MySQL backup machines [create a file during the backup
process](https://github.com/alphagov/govuk-puppet/commit/0e1615bf31f714994b43142ecf915330d4d46af5).
If that file exists, the machine isn't safe to reboot.

-   Check if the file exists:

        fab <environment> -H mysql-backup-1.backend sdo:'test -e /var/lock/mysql-backup.lock'

-   If the file doesn't exist (that command returns non-0), reboot the
    machine:

        fab <environment> -H mysql-backup-1.backend vm.reboot

## Rebooting MySQL master and slave machines (Carrenza only)

> **Note**
>
> These machines are managed by Amazon in AWS and do not require manual intervention.

Unless there are urgent updates to apply, these machines should not be
rebooted during working hours in production. Applications write to the
masters and read from the slaves (with the exception of the slave within
the DR environment).

If urgently required, applications can have their database configuration
amended by editing the relevant configuration in
<https://github.com/alphagov/govuk-app-deployment>

When the app has been redeployed then the machine which is **not** being
read from can be rebooted.

Reboots of these machines, in the production environment, should be organised
with Platform Health.

They may be rebooted in working hours in the staging environment, however you
should notify colleagues before doing so.

## Rebooting PostgreSQL primary and standby machines (Carrenza only)

> **Note**
>
> These machines are managed by Amazon in AWS and do not require manual intervention.

Unless there are urgent updates to apply, these machines should not be
rebooted in production during working hours. Applications read and write
to the primary machines, and some applications (e.g. Bouncer) read from the
standby machines (with the exception of the slave within the DR
environment).

Reboots of these machines, in the production environment, should be organised
with Platform Health.

They may be rebooted in working hours in the staging environment, however you
should notify colleagues before doing so.
