---
owner_slack: "#govuk-2ndline"
title: Reboot a machine
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
important: true
---

Under normal circumstances most machines reboot automatically when an update is required.
Some machines need to be rebooted manually.

Note that much of the following documentation assumes you have correctly
[set up your fabric scripts](https://github.com/alphagov/fabric-scripts#setup).

## Automatic rebooting

If machines are not rebooting automatically, there may be a problem with the locking mechanism.
See next section.

### Checking locking status

[locksmith](https://github.com/coreos/locksmith) manages unattended reboots to
ensure that systems are available. It is possible that a problem could occur
where they can't reboot automatically.

```command-line
$ fab <environment> all locksmith.status
```

If a lock is in place, it will detail which machine holds the lock.

You can remove it with:

```command-line
$ fab <environment> -H <machine-name> locksmith.unlock:"<machine-name>"
```

Machines that are safe to reboot should then do so at the scheduled
time.

## Manual rebooting

> Before rebooting anything manually, see if any [special cases][#special-cases] apply to the type of machine you need to reboot.

### Rules of manual rebooting

* Do not reboot more than one machine of the same class at the same time.
* There are Icinga alerts that warn if machines need rebooting. Those
  alerts will tell you if it's a manual reboot, and whether it's in-
  or out-of-hours.
* There is [extra guidance if the machine you are rebooting is in AWS](#rebooting-guidance-for-aws).
  You may wish to pair with the RE interruptible/on call person.
* There are also [things to consider when rebooting Carrenza machines](#rebooting-guidance-for-carrenza).

### Rebooting one machine

First check whether the machine is safe to reboot. This information is
stored in puppet in hieradata. For example,
[here](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/class/mysql_master.yaml)
is an example of a machine that cannot be safely rebooted. The
[default](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_safe_to_reboot/manifests/init.pp)
is `safe_to_reboot::can_reboot: 'yes'`.

> If there is an incident which requires the rebooting of a machine
> otherwise marked as 'no', then it may be done provided any downstream
> effects of this reboot have been considered.

If you want to reboot the machine immediately, you can SSH into it and run:

```sh
sudo reboot
```

Alternatively, there is a Fabric task to schedule a machine for downtime
in Nagios for 20 minutes and then reboot it:

```
fab $environment -H graphite-1.management vm.reboot
```

### Rebooting guidance for AWS

If rebooting machines in AWS, extended reboot times may result in the
relevant machine being terminated automatically. If this happens, a
new machine will be created automatically.

There have been a few cases when a reboot in AWS has not come back successfully
and RE will be able to help in these cases. It also means RE can investigate
any problems so it doesn't happen again and we have confidence in our ability
to reboot machines in AWS.

There's a [section on rebooting `cache` machines in AWS](#rebooting-cache-machines-in-aws).

### Rebooting guidance for Carrenza

There is a known issue whereby adding an extra disk using the LSI
Logic Parallel (SCSI) controller to a VM causes the BIOS boot order to
change, meaning that the system disk cannot be found and the OS does
not boot when the affected VM is restarted. See the
manual entry on [adding disks](/manual/adding-disks-in-vcloud.html) for
more info.

## Special cases

### Rebooting Cache machines in AWS

The `cache` machines run the `router` app which handles live user traffic.
To safely reboot them without serving too many errors to users, we must
remove them from the AWS load balancer target groups before rebooting:

1. Login to the AWS Console for the relevant environment (`gds aws govuk-<environment>-<your-role> -l`).
1. Find the [Instance ID](https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#Instances:sort=desc:launchTime) of the critical machine(s) (probably all 8 `blue-cache` machines)
1. Remove the machine from the following [Target Groups](https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#TargetGroups:sort=targetGroupName):
   1. cache-assets-origin
   1. cache-www
   1. cache-www-origin
1. SSH onto the machine (find this from the reboots required alert listing)
1. Check the traffic has reduced to only be the Smokey healthchecks now: `tail -f /var/log/nginx/lb-access.log`.
1. Run the `vm.reboot` fab script on your local machine like normal.
1. Re-add the machine to the above target groups.
1. Check the traffic is flowing from the load balancer with `tail -f /var/log/nginx/lb-access.log` again.

### Rebooting MongoDB machines

You can see our MongoDB machines by running:

```
$ fab $environment puppet_class:mongodb::server hosts
```

All secondary Mongo machines will reboot overnight. If you don't need to
reboot the cluster right now, step the current primary down and allow it
to reboot overnight:

```
$ fab $environment -H $hostname mongo.step_down_primary
```

The general approach for rebooting machines in a MongoDB cluster is:

* Check cluster status with `fab $environment -H $hostname mongo.status`
* Using `fab $environment -H $hostname mongo.safe_reboot`
  * Reboot the secondaries
  * Reboot the primary. The `mongo.safe_reboot` Fabric task automates stepping down the primary and waiting for the cluster to recover before rebooting.

### Rebooting Redis machines

Unless there are urgent updates to apply, these machines should not be
rebooted during working hours in production. Other services rely directly on
particular Redis hosts and may error if they are unvailable.

Reboots of these machines, in the production environment, should be organised
by On Call staff and search-api workers must be restarted (by re-deploying the latest release) after the reboot.

They may be rebooted in working hours in other environments, however you
should notify colleagues before doing so as this may remove in-flight jobs
that Sidekiq has added to the Redis queues but not yet processed.

### Rebooting RabbitMQ machines

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

* Reboot the nodes in the cluster:

```
fab <environment> class:rabbitmq rabbitmq.safe_reboot
```

If any applications start alerting due to `rabbitmq-1` being rebooted
then either add a note here about how to make that application recover,
or get the team responsible to make it point to the cluster.

### Rebooting asset master and slave machines

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

### Rebooting router-backend machines

Router backend machines are instances of MongoDB machines and can be rebooted
as per the [MongoDB rebooting guidance](#rebooting-mongodb-machines).

### Rebooting jumpbox machines

These machines are safe to reboot during the day. During the night they
are involved in a data sync processes and rebooting could cause the data
sync to fail.

### Rebooting backend-lb machines (Carrenza only)

In order to safely reboot these machines you'll need access to [vCloud Director][vcloud], in order to switch traffic away from backend-lb-1 before rebooting it - all traffic goes through this machine unless it fails.

* Reboot backend-lb-2 and wait for it to recover.

  ```
  fab <environment> -H backend-lb-2.backend vm.reboot
  ```

  > Doing this may trigger a PagerDuty alert and trigger 5xx errors on Fastly.

* Find the IP addresses of backend-lb-1 and backend-lb-2 for the
    environment. They will be listed in [this
    repo](https://github.com/alphagov/govuk-provisioning/).
* Use vCloud Director to update the NAT rule to point to backend-lb-2.
  * The Nat rule will be in [this repo](https://github.com/alphagov/govuk-provisioning/).
  * Go to "Administration".
  * Find 'GOV.UK Management' in the list of vdcs and click on it
  * Select the "edge gateway" tab, right click on it and select "edge gateway services".
  * Click the NAT tab.
  * Find the rule corresponding to the rule defined in the vcloud-launcher file, and update the DNAT rules to point to the IP address of backend-lb-2 by clicking edit, and updating the "Translated (Internal) IP/range" field and click OK to save these rules.
* Reboot backend-lb-1 and wait for it to recover

  ```
  fab <environment> -H backend-lb-1.backend vm.reboot
  ```

* Use [vCloud Director][vcloud] to update the NAT rule to point back to the IP address of backend-lb-1.

### Rebooting MySQL backup machines (Carrenza only)

The MySQL backup machines [create a file during the backup
process](https://github.com/alphagov/govuk-puppet/commit/0e1615bf31f714994b43142ecf915330d4d46af5).
If that file exists, the machine isn't safe to reboot.

* Check if the file exists:

  ```
  fab <environment> -H mysql-backup-1.backend sdo:'test -e /var/lock/mysql-backup.lock'
  ```

* If the file doesn't exist (that command returns non-0), reboot the
  machine:

  ```
  fab <environment> -H mysql-backup-1.backend vm.reboot
  ```

### Rebooting MySQL master and slave machines (Carrenza only)

Unless there are urgent updates to apply, these machines should not be
rebooted during working hours in production. Applications write to the
masters and read from the slaves (with the exception of the slave within
the Disaster Recovery environment).

Reboots of these machines, in the production environment, should be organised
by On Call staff.

They may be rebooted in working hours in the staging environment, however you
should notify colleagues before doing so.

### Rebooting Whitehall MySQL slave machines

The whitehall-mysql-slave-1 machine is used by the frontend component
of Whitehall, so this'll be impacted when rebooting. The other
whitehall-mysql-slave machines are not used by Whitehall frontend.

### Rebooting PostgreSQL primary and standby machines (Carrenza only)

Unless there are urgent updates to apply, these machines should not be
rebooted in production during working hours. Applications read and write
to the primary machines, and some applications (e.g. Bouncer) read from the
standby machines (with the exception of the slave within the Disaster Recovery
environment).

Reboots of these machines, in the production environment, should be organised
by On Call staff.

They may be rebooted in working hours in the staging environment, however you
should notify colleagues before doing so.

[vcloud]: /manual/connect-to-vcloud-director.html
