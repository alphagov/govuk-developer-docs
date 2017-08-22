---
owner_slack: "#2ndline"
title: Deploy Puppet
section: Deployment
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-08-22
review_in: 6 months
---

You can deploy puppet using the following steps:

1. Get the [release tag of the build that you wish to deploy][tag] from the release
app (`release_18295` for example). Look at the diff you're going to deploy.

2. Deploy the tag to staging using the [Deploy Puppet job][stage-deploy].

    You need to configure the build by setting the 'TAG' value to the
    successful build you previously selected (e.g.`release_18295`)

3. You will either need to wait 30mins or read about [convergence](#convergence).
After which you should keep an eye on Icinga, Smokey and test anything you're concerned about.

4.  Repeat the last step to [deploy to production][prod].

[tag]: https://release.publishing.service.gov.uk/applications/puppet
[stage-deploy]: https://deploy.staging.publishing.service.gov.uk/job/Deploy_Puppet
[prod]: https://deploy.publishing.service.gov.uk/job/Deploy_Puppet

## Convergence

The deployment only pushes the new code to the Puppet master. Each node
runs a Puppet agent every 30 minutes (via cron), so it may be some time
before the release has taken effect. This has an implication on how
quickly you can go from Staging to Production.

If you would like to know which version of Puppet is running where on a
specific environment, there is a script in the
[fabric-scripts](https://github.com/alphagov/fabric-scripts) repository
to help.

In order to run it, create a GitHub Access Token
[here](https://github.com/settings/tokens) and run the following inside
the fabric-scripts repository:

    GITHUB_ACCESS_TOKEN=<YOUR-GITHUB-TOKEN> ./bin/puppet_versions.sh

The script will prompt you for an environment (integration, staging or
production) and it will query all servers in that environment for the
version of Puppet and the last time the Puppet agent ran.

If you'd rather not wait and you're able to safely determine from the
diff what classes of machines the change will affect, or which ones are
still on an older version of Puppet using the script above, you can use
[Fabric](https://github.com/alphagov/fabric-scripts) to force a run of
Puppet. For example:

    fab $environment class:frontend_lb class:backend_lb puppet

This will run in serial across the nodes so there is a reduced chance of
downtime caused by a service restarting on all nodes of a given
class/tier at the same time. You should still be careful though, because
some services take longer to restart than others.

## Preventing service restarts

It may occassionally be neccessary to trick Puppet into not restarting a
service, if it is a single point of failure and doing so would cause a
brief outage, e.g. MySQL.

> **warning**

> This is not a "normal" procedure. You should only do this if you need
> to and you MUST have some plan for restarting the service in the near
> future so that it's not inconsistent with its configuration.

1.  Disable normal Puppet runs on the affected nodes:

        fab $environment class:mysql_master puppet.disable:'Preventing service restart'

2.  Change the file content to match what Puppet wants it to be. If it's
    a plain file you can probably apply the diff from git using
    `sudo patch source.diff dest`. If it's a template then you may need
    to refer to an existing environment or figure it out yourself.
3.  Verify that Puppet won't change the file or notify the service by
    running it in `noop` mode. You will need to provide a different lock
    path to bypass the disable:

        govuk_puppet -v --noop --agent_disabled_lockfile /tmp/puppet.noop

4.  If you're happy with the results then re-enable Puppet and run it
    again:

        fab $environment class:mysql_master puppet.enable puppet

5.  Schedule a time to actually restart the service if neccessary.
