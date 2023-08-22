---
owner_slack: "#govuk-developers"
title: Deploy Puppet
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

## Build a release

[Jenkins](https://ci.integration.publishing.service.gov.uk/job/govuk-puppet/) builds govuk-puppet automatically on push to any branch.

## Deploy a branch

Before merging your PR, it's recommended that you deploy the change to
Integration in order to test it works on real infrastructure. Go to [the
`Deploy_Puppet` job in Jenkins][deploy-puppet] and click ‘Build with
Parameters’. The `TAG` field should contain the name of the branch you wish to
deploy.

[deploy-puppet]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_Puppet/

## Deploy a release

You can deploy Puppet to Staging and Production using the following steps:

1. In the [Release app][release-app-puppet], select the release tag and review
   the changes listed.
1. If your change on integration appears as expected, deploy a newer version of
   govuk-puppet to staging by using the **Deploy to Staging** button.
1. Wait 30 minutes or read about [convergence](#convergence).
   You should monitor [Staging Icinga][icinga-staging] and [Staging Smokey][smokey-staging],
   and test anything you're concerned about.
1. Repeat the above steps for Production.

[release-app-puppet]: https://release.publishing.service.gov.uk/applications/puppet
[icinga-staging]: https://alert.blue.staging.govuk.digital/
[smokey-staging]: https://deploy.blue.staging.govuk.digital/job/Smokey

Puppet is automatically deployed to integration by a combination of the [integration-puppet-deploy job on Jenkins CI](https://ci-deploy.integration.publishing.service.gov.uk/job/Deploy_Puppet/) and [Deploy Puppet job on Jenkins Deploy](https://deploy.integration.publishing.service.gov.uk/job/Deploy_Puppet/) jobs.

> **WARNING**
>
> If you're deploying a change to [hiera.yml](https://github.com/alphagov/govuk-puppet/blob/master/hiera.yml) or [hiera_aws.yml](https://github.com/alphagov/govuk-puppet/blob/master/hiera_aws.yml), you will need to restart the Puppet server on the Puppet Master machine, otherwise these changes will not be picked up.
>
> To restart the server, run `sudo service puppetserver restart`.

## Convergence

The deployment only pushes the new code to the Puppet Master. Each node
runs a Puppet agent every 30 minutes (via cron), so it may be some time
before the release takes effect. This has an implication on how
quickly you can go from staging to production.

If you'd rather not wait and you're able to safely determine from the
diff what classes of machines the change will affect, [you can force a run of puppet](/manual/howto-run-ssh-commands-on-many-machines.html#run-puppet) on the relevant machine classes.

This will run in serial across the nodes so there is a reduced chance of
downtime caused by a service restarting on all nodes of a given
class at the same time. You should still be careful though, because
some services take longer to restart than others.

## Prevent service restarts

It may occassionally be neccessary to trick Puppet into not restarting a
service, if it is a single point of failure and doing so would cause a
brief outage, e.g. MySQL.

> **WARNING**
>
> This is not a "normal" procedure. You should only do this if you need
> to and you MUST have some plan for restarting the service in the near
> future so that it's not inconsistent with its configuration.

1. Find out which machine class the service is running on

2. Disable puppet on all machines of that class

3. On each machine, change the file content to match what Puppet wants it to be.
   If it's a plain file you can probably apply the diff from git using sudo patch source.diff dest.
   If it's a template then you may need to refer to an existing environment or figure it out yourself.

4. Verify that Puppet won't change the file or notify the service by running it in noop mode.
   ou will need to provide a different lock path to bypass the disable:

```
govuk_puppet --noop --test --agent_disabled_lockfile=/tmp/puppet.noop
```

5. If you're happy with the results then re-enable Puppet on all of the machines

6. Schedule a time to actually restart the service if necessary.

Instructions on [how to disable and enable puppet can be found here](/manual/howto-run-ssh-commands-on-many-machines.html).
