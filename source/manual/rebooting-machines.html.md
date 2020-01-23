---
owner_slack: "#govuk-2ndline"
title: Reboot a machine
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
important: true
last_reviewed_on: 2020-01-23
review_in: 3 months
---

## Rules of rebooting

* *Read this page first* to see if any special cases apply to the type of
  machine you need to reboot.
* Do not reboot more than one machine of the same class at the
  same time.
* When rebooting clustered applications (such as RabbitMQ) wait
  for the cluster to recover fully before rebooting the next machine.
* If rebooting machines in AWS, extended reboot times may result in the
  relevant machine being terminated automatically. If this happens, a
  new machine will be created automatically.

### Rebooting guidance for 2ndline

Most machines in Production should be rebooted out of hours, and this
is handled by those who are on call out of hours.

Some machines in Production may need to be rebooted in hours though,
and machines in other environments can usually be rebooted in hours as
well.

Additionally, for machines running MongoDB, they may be automatically
rebooted out of hours, but only if they're not the primary. So it can
be helpful to step down the primary MongoDB machine to allow it to
reboot out of hours.

### Rebooting guidance for AWS

If you are rebooting a machine in AWS (either out of hours or in hours) it's
advised to pair with the RE interruptible/on call person.

There have been a few cases when a reboot in AWS has not come back successfully
and RE will be able to help in these cases. It also means RE can investigate
any problems so it doesn't happen again and we have confidence in our ability
to reboot machines in AWS.

There's a [section on rebooting `cache` machines in AWS](#rebooting-cache-machines-in-aws).

## Unattended upgrades

Machines are configured with [automatic security updates](https://help.ubuntu.com/community/AutomaticSecurityUpdates#Using_the_.22unattended-upgrades.22_package) which install security updates overnight. Sometimes these require a reboot in order to become active.

You can review the list of packages on machines (or classes of machines) with the [following command](https://github.com/alphagov/fabric-scripts#setup). Logs of the previous runs can be found in `/var/log/unattended-upgrades`.

    fab $environment all apt.packages_with_reboots

You will then need to decide whether to:

-   Reboot the machine
-   Silence the check until the next package requires update
    (`fab $environment all apt.reset_reboot_needed`)

### Deciding whether to reboot or silence

This can be quite nuanced. Before you go ahead with any course of action,
gather evidence and then ask in the \#reliability-eng Slack channel.

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

> If there is an incident which requires the rebooting of a machine
> otherwise marked as 'no', then it may be done provided any downstream
> effects of this reboot have been considered.

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

## Rebooting Cache machines in AWS

The `cache` machines run the `router` app which handles live user traffic.
To safely reboot them without serving too many errors to users, we must
remove them from the AWS load balancer target groups before rebooting:

1. Login to the AWS Console for the relevant environment (`gds aws govuk-<environment>-<your-role> -l`).
1. Find the [Instance ID](https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#Instances:sort=desc:launchTime) of the critical machine(s) (probably all 8 `blue-cache` machines)
1. `ssh [ip].eu-west-1.compute.internal` (find this from the reboots required alert listing)
1. Remove the machine from the following [Target Groups](https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#TargetGroups:sort=targetGroupName):
   1. cache-assets-origin
   1. cache-www
   1. cache-www-origin
1. Check the traffic has reduced to only be the Smokey healthchecks now: `tail -f /var/log/nginx/lb-access.log`.
1. Run the `vm.reboot` fab script on your local machine like normal.
1. Re-add the machine to the above target groups.
1. Check the traffic is flowing from the load balancer with `tail -f `/var/log/nginx/lb-access.log` again.

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

## Rebooting Redis machines

Unless there are urgent updates to apply, these machines should not be
rebooted during working hours in production. Other services rely directly on
particular Redis hosts and may error if they are unvailable.

Reboots of these machines, in the production environment, should be organised
by On Call staff and search-api workers must be restarted after the reboot.

They may be rebooted in working hours in other environments, however you
should notify colleagues before doing so as this may remove in-flight jobs
that Sidekiq has added to the Redis queues but not yet processed.

## Rebooting RabbitMQ machines

There's a Fabric task to reboot all nodes in the RabbitMQ cluster,
waiting for the cluster to recover before rebooting the next node.

> **Note**
>
> We have had a couple of incidents after running this script, so it should only
> be done in-hours and requires careful monitoring. See:
>
> 1) [No non-idle RabbitMQ consumers](https://docs.google.com/document/d/19gCq7p7OggkG0pGNL8iAspfnwR1UrsZfDQnOYniQlvM/edit?pli=1#) - This required killing RabbitMQ processes to resolve.
>
> 2) [Publishing API jobs became stuck](https://docs.google.com/document/d/1ia3OGn-v0bimW4P0vRtKUVeVVNh7VEiXjHqlc9jfeFY/edit#heading=h.p99426yo0rbv) - This required restarting Publishing API workers to resolve.

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

Reboots of the master machine should be organised by On Call staff,
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

NAT rule points directly at backend-lb-1 for backend services. In order
to safely reboot these machines you'll need access to vCloud Director.

-   reboot backend-lb-2 and wait for it to recover

    `fab <environment> -H backend-lb-2.backend vm.reboot`

    > **Note**
    >
    > Doing this may trigger a PagerDuty alert and trigger 5xx errors on Fastly.

-   Find the IP addresses of backend-lb-1 and backend-lb-2 for the
    environment. They will be listed in [this
    repo](https://github.com/alphagov/govuk-provisioning/)
-   Use vCloud Director to update the NAT rule to point to backend-lb-2.
    -   The Nat rule will be in [this
        repo](https://github.com/alphagov/govuk-provisioning/).
    -   Go to "Administration"
    -   Find 'GOV.UK Management' in the list of vdcs and click on it
    -   Select the "edge gateway" tab, right click on it and select
        "edge gateway services"
    -   Click the NAT tab.
    -   Find the rule corresponding to the rule defined in the
        vcloud-launcher file, and update the DNAT rules to point to the
        ip address of backend-lb-2 by clicking edit, and updating the
        "Translated (Internal) IP/range" field and click ok to save
        these rules
-   Reboot backend-lb-1 and wait for it to recover

    `fab <environment> -H backend-lb-1.backend vm.reboot`

-   Use vCloud Director to update the NAT rule to point back to the IP
    address of backend-lb-1

## Rebooting MySQL backup machines (Carrenza only)

The MySQL backup machines [create a file during the backup
process](https://github.com/alphagov/govuk-puppet/commit/0e1615bf31f714994b43142ecf915330d4d46af5).
If that file exists, the machine isn't safe to reboot.

-   Check if the file exists:

        fab <environment> -H mysql-backup-1.backend sdo:'test -e /var/lock/mysql-backup.lock'

-   If the file doesn't exist (that command returns non-0), reboot the
    machine:

        fab <environment> -H mysql-backup-1.backend vm.reboot

## Rebooting MySQL master and slave machines (Carrenza only)

Unless there are urgent updates to apply, these machines should not be
rebooted during working hours in production. Applications write to the
masters and read from the slaves (with the exception of the slave within
the DR environment).

Reboots of these machines, in the production environment, should be organised
by On Call staff.

They may be rebooted in working hours in the staging environment, however you
should notify colleagues before doing so.

### Whitehall MySQL slave machines

The whitehall-mysql-slave-1 machine is used by the frontend component
of Whitehall, so this'll be impacted when rebooting. The other
whitehall-mysql-slave machines are not used by Whitehall frontend.

## Rebooting PostgreSQL primary and standby machines (Carrenza only)

Unless there are urgent updates to apply, these machines should not be
rebooted in production during working hours. Applications read and write
to the primary machines, and some applications (e.g. Bouncer) read from the
standby machines (with the exception of the slave within the DR
environment).

Reboots of these machines, in the production environment, should be organised
by On Call staff.

They may be rebooted in working hours in the staging environment, however you
should notify colleagues before doing so.

## Rebooting Docker Management machines

These currently just run etcd which is used to coorindate automatic
out of hours reboots.

Reboots of these machines should be organised by 2nd line and happen
in hours.
