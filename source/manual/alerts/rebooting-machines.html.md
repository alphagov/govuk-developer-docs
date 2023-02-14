---
owner_slack: "#govuk-2ndline-tech"
title: Reboot a machine
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
important: true
---

Under normal circumstances, most machines reboot automatically when an update is required. Some machines need to be rebooted manually.

Icinga alerts state when machines need rebooting, and will tell you if it's a manual reboot and whether it can be done in-hours or should be done out-of-hours.

## Automatic rebooting

If machines are not rebooting automatically, there may be a problem with the locking mechanism.
See next section.

### Checking locking status

[locksmith](https://github.com/coreos/locksmith) manages unattended reboots to
ensure that systems are available. It is possible that a problem could occur
where they can't reboot automatically.

SSH into the machine in question, and run the following command, replacing 'integration' with whatever environment the machine is running in:

```
$ /usr/bin/locksmithctl -endpoint='http://etcd.integration.govuk-internal.digital:2379' status
```

If a lock is in place, it will detail which machine holds the lock. If you want to check which machine created the lock, you can [search for it in AWS](/find-an-instance-in-aws). If the machine doesn't exist, it may have been terminated before it could release the locks. The locking machine is almost always a docker_management machine, so [rebooting the docker management machine](#rebooting-docker_management-machines) will cause it to refresh and clear out-of-date locks. If the docker-management machine needs rebooting anyway, you should try this first.

If you need to manually remove the lock, you can remove it with:

```
$ /usr/bin/locksmithctl -endpoint='http://etcd.integration.govuk-internal.digital:2379' unlock '<machine-name>'
```

Machines that are safe to reboot should then do so at the scheduled time.

## Manual rebooting

You can manually reboot virtual machines. You should follow these general rules:

1. Do not reboot more than one machine of the same class at the same time.
1. Before you reboot, check whether the machine is safe to reboot, by looking at the [machine hieradata in govuk-puppet](https://github.com/alphagov/govuk-puppet/tree/main/hieradata_aws/class).
  - If a machine is not safe to reboot, its YAML file will have a `govuk_safe_to_reboot::can_reboot` property with a value of "no", "careful" or "overnight" ([example](https://github.com/alphagov/govuk-puppet/blob/32c1bbbb10067078c1406170666a135b4a10aaea/hieradata_aws/class/production/graphite.yaml#L1)).
  - Be sure to check _all_ of the YAML files for your machine class, as the `govuk_safe_to_reboot` configuration may differ between environments.
  - If there is no `govuk_safe_to_reboot` configuration, the machine is [considered safe to reboot](https://github.com/alphagov/govuk-puppet/blob/32c1bbbb10067078c1406170666a135b4a10aaea/modules/govuk_safe_to_reboot/manifests/init.pp#L20).
  - Even if a safe isn't considered 'safe' to reboot, you may need to do so in the event of an incident. Just be mindful of the downstream effects of the reboot.
1. Check if there are special instructions below for the machine type you're rebooting. If there aren't, then skip to the "[rebooting other machines](#rebooting-other-machines)" instructions.

Note that if a reboot gets stuck or takes too long, it can result in AWS automatically terminating that machine. If this happens, AWS should automatically create a new machine to replace the old one.

### Rebooting `asset_master` machines

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

### Rebooting `cache` machines

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

1. Login to the AWS Console for the relevant environment (`gds aws govuk-<ENVIRONMENT>-<your-role> -l`).
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

### Rebooting `ci_agent` machines

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

### Rebooting `docker_management` machines

It is only safe to reboot while no other unattended reboot is underway. This is because it is used to manage locks for unattended reboots of other machines. If this machine is down, then multiple machines in high availability groups may choose to reboot themselves at the same time.

To avoid this happening, we need to disable unattended reboots on all the other machines in the environment while we reboot this one:

1. Set `govuk_unattended_reboot::enabled` to `false` in the [govuk-puppet common configuration](https://github.com/alphagov/govuk-puppet/blob/9c97f1cfe22334e472a48277f5131e0735b16a4e/hieradata_aws/common.yaml#L1166) - you can do this in a branch.
1. Build the branch of govuk-puppet to Production
1. Wait half an hour to allow all machines to pull from the puppetmaster
1. Reboot the docker-management machine (`sudo reboot`)
1. Deploy the previous release of govuk-puppet to Production

### Rebooting `jenkins` machines

We only have one instance on each environment that runs Jenkins, therefore rebooting Jenkins will cause downtime for developers.
It will prevent developers from being able to deploy code, apply Terraform, run Smokey, and lots of other things.

Before rebooting Jenkins, put a message in `#govuk-2ndline-tech` and consider doing the same in `#govuk-developers`.
Check that there are no (important) jobs in progress. When things look free, `sudo reboot`.

Avoid doing this late in the day, as Jenkins is quite brittle and a reboot may cause runtime issues that require SRE assistance. Worse, it may trigger a new instance (see [manual rebooting](#manual-rebooting)), which can sometimes fail to provision correctly due to the original instance retaining a 'lock' on the volume, which then can't be mounted on the new instance. In this case, terminating the new instance should fix things, as that will cause another new instance to be created, and this time there will be no lock on the volume.

### Rebooting `mongo` machines

Read "[find the primary](/manual/mongo-db-commands.html#find-the-primary)" to figure out which Mongo machine is the primary and which are the secondaries.

All secondary Mongo machines reboot overnight automatically. If you need to reboot them sooner, reboot them one at a time, ensuring that you [check that the Mongo cluster is healthy](/manual/mongo-db-commands.html#check-cluster-status) before moving onto the next machine.

To reboot the primary, you'll need to [step the current primary down](/manual/mongo-db-commands.html#step-down-the-primary) so that it becomes a secondary machine. You're then free to reboot it as above.

### Rebooting `monitoring` machines

Before rebooting, post a message in the `#govuk-2ndline-tech` channel in case anyone is looking
at the alerts.

SSH into the machine and run `sudo reboot`. The Icinga alerts will be temporarily unavailable.

### Rebooting `router_backend` machines

Router backend machines are instances of MongoDB machines and can be rebooted
as per the [MongoDB rebooting guidance](#rebooting-mongodb-machines).

### Rebooting other machines

This guidance applies if you want to reboot a machine that is not one of the previous types.

1. Schedule downtime in Icinga, or let GOV.UK Technical 2nd Line know that there will be alerts for a machine being down.

2. SSH into the machine and run:

   ```sh
   sudo reboot
   ```
