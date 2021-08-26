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

You can manually reboot virtual machines.

Icinga alerts state when machines need rebooting. These alerts tell you if it's a manual reboot, and whether it's in or out-of-hours.

Do not reboot more than one machine of the same class at the same time.

The way that you reboot machines depends on the type of machine.

### Before you start

Before you start manually rebooting, you must check whether the machine is safe to reboot.

This information is stored in `govuk-puppet` in hieradata. If a machine is safe to reboot, the `govuk_safe_to_reboot` class will show `$can_reboot = 'yes'`.

See the [`govuk_safe_to_reboot/manifests/init.pp` file in the `govuk-puppet` repo](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_safe_to_reboot/manifests/init.pp) for more information.

Because of an incident, you may need to reboot a machine that is not safe to reboot. You can reboot that machine as long as you have considered the downstream effects of this reboot.

### Rebooting AWS machines

If you need to reboot a machine in AWS, extended reboot times may result in AWS automatically terminating that machine.

If this happens, AWS should then automatically create a new machine to replace the old one.

If AWS does not automatically create a new machine, [contact the Reliability Engineering team](mailto:reliability-engineering@digital.cabinet-office.gov.uk) for support.

See the [documentation on rebooting `cache` machines in AWS](#rebooting-cache-machines-in-aws) for more information.

### Rebooting Jenkins CI agents

Sometimes a CI agent starts continually erroring on Jenkins jobs, and the
most straightforward way of fixing the issue is to reboot the machine.

First, visit the [Jenkins nodes list](https://ci.integration.publishing.service.gov.uk/computer/).
Click on the problematic agent and then "Mark this node temporarily
offline". You'll need to provide a reason, which could just be "to reboot
problematic agent". This will stop the agent from being used for new jobs.

SSH into the agent; the machine number to SSH into will match the agent
number. For example:

```sh
gds govuk connect ssh -e integration ci_agent:6
```

Reboot the machine: `sudo reboot`.

Finally, go back into the Jenkins nodes list to take the node online and
then to "Launch agent". You'll be taken to the live log for the agent,
where you should see the output `Agent successfully connected and online`.

### Rebooting Cache machines in AWS

The `cache` machines run the `router` app which handles live user traffic.
To safely reboot them without serving too many errors to users, we must
remove them from the AWS load balancer target groups before rebooting.

The tool for rebooting cache machines is in the govuk-puppet repository. This
is the recommended way to reboot a cache machine:

```
cd govuk-puppet
gds aws govuk-integration-poweruser -- ./tools/reboot-cache-instances.sh -e integration ip-1-2-3-4.eu-west-1.compute.internal
```

The tool takes an environment and a private DNS name, which are provided by the
Icinga alert.

You can also follow this process manually:

1. Login to the AWS Console for the relevant environment (`gds aws govuk-<environment>-<your-role> -l`).
1. Find the [Instance ID](https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#Instances:sort=desc:launchTime)
   of the critical machine(s) (probably all 8 `blue-cache` machines)
1. Navigate to the `blue-cache` Auto Scaling Group (ASG)
1. Put the instance into a "Standby" state, which will detach the instance
   from its Target Groups
1. Once the instance is in a Standby state, SSH onto the machine (find this
   from the reboots required alert listing)
1. Check the traffic has reduced to only be the Smokey healthchecks now: `tail -f /var/log/nginx/lb-access.log`.
1. Schedule downtime in icinga and run `sudo reboot` on the remote machine like normal.
1. In the `blue-cache` ASG, move the instance back to the "InService" state,
   which will re-add the instance to the Target Groups
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

Example:

```shell
$ fab aws_production -H ip-127-0-0-11.eu-west-1.compute.internal mongo.step_down_primary
```

(note that the example IP is fake)

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

There are 3 RabbitMQ virtual machines in a cluster. You reboot one machine at a time. You should only reboot the RabbitMQ machines in-hours.

1. SSH into the machine and environment you want to reboot by running the following command:

    ```
    gds govuk connect ssh -e <ENVIRONMENT> <MACHINE>
    ```

    For example, to SSH into the `integration` environment of the `rabbitmq-1` machine:

    ```
    gds govuk connect ssh -e integration rabbitmq:1
    ```

1. Check that the RabbitMQ cluster is healthy by running `sudo rabbitmqctl cluster_status`.

    This prints a list of expected machines and a list of currently running machines. If the 2 lists are the same then the cluster is healthy. The following output is an example of a healthy cluster:

    ```
    Cluster status of node 'rabbit@ip-10-12-6-130'
    [{nodes,[{disc,['rabbit@ip-10-12-4-186','rabbit@ip-10-12-5-128',
                'rabbit@ip-10-12-6-130']}]},
     {running_nodes,['rabbit@ip-10-12-4-186','rabbit@ip-10-12-5-128',
                 'rabbit@ip-10-12-6-130']},
     {cluster_name,<<"rabbit@ip-10-12-6-130.eu-west-1.compute.internal">>},
     {partitions,[]},
     {alarms,[{'rabbit@ip-10-12-4-186',[]},
              {'rabbit@ip-10-12-5-128',[]},
              {'rabbit@ip-10-12-6-130',[]}]}]
    ```

1. Reboot the machine by running `sudo reboot`.

When you have rebooted the machine, you should monitor alerts to see if there are any RabbitMQ-related alerts.

For more information on RabbitMQ-related alerts, see the [GOV.UK Puppet RabbitMQ `monitoring.pp` file](https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk_rabbitmq/manifests/monitoring.pp).

There have been two incidents after rebooting RabbitMQ machines. For more information, see the [No non-idle RabbitMQ consumers](https://docs.google.com/document/d/19gCq7p7OggkG0pGNL8iAspfnwR1UrsZfDQnOYniQlvM/edit?pli=1#) and [Publishing API jobs became stuck](https://docs.google.com/document/d/1ia3OGn-v0bimW4P0vRtKUVeVVNh7VEiXjHqlc9jfeFY/edit#heading=h.p99426yo0rbv) incident reports.

### Rebooting asset primary and secondary machines

Unless there are urgent updates to apply the primary machine should not be
rebooted in production during working hours - as the primary machine is required
for attachments to be uploaded.

The secondary machines can be rebooted as they hold a copy of data and are resynced
regularly.

Reboots of the step_down_primary machine should be organised by On Call staff,
for the production environment.

You may reboot the primary machine in the staging environment during working
hours however it is prudent to warn colleagues that uploading attachments will
be unavailable during this period.

### Rebooting router-backend machines

Router backend machines are instances of MongoDB machines and can be rebooted
as per the [MongoDB rebooting guidance](#rebooting-mongodb-machines).

### Rebooting jumpbox machines

These machines are safe to reboot during the day. During the night they
are involved in a data sync processes and rebooting could cause the data
sync to fail.

```
sudo reboot
```

### Rebooting docker-management

It is safe to reboot while no other unattended reboot is underway - see https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/class/docker_management.yaml

### Rebooting other machines

This guidance applies if you want to reboot a machine that is not one of the previous types.

1. Schedule downtime in Icinga, or let GOV.UK 2nd line support know that there will be alerts for a machine being down.

2. SSH into the machine and run:

   ```sh
   sudo reboot
   ```
