---
title: Deploy Puppet
section: howto
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/deploy-puppet.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/deploy-puppet.md)


# Deploy Puppet

## Basic Steps

1.  Get the number of the build that you wish to deploy from the Puppet
    job on CI (e.g. `18295`, this will be tagged as `release_18295`):

> -   [](https://ci.integration.publishing.service.gov.uk/job/govuk-puppet/job/master/)

2.  Get the tag of the last deployed build from the release app (e.g.
    `release_18290`):

> -   [](https://release.publishing.service.gov.uk/applications/puppet)

3.  Compare the two build tags to see what you are deploying:

    NB: make sure you have the older release first otherwise you won't
    see a diff

> -   [](https://github.com/alphagov/govuk-puppet/compare/release_18290...release_18295)

4.  Deploy the tag to staging using the [Deploy Puppet
    job](https://deploy.staging.publishing.service.gov.uk/job/Deploy_Puppet).

    You need to configure the build by setting the 'TAG' value to the
    successful build you previously selected (e.g.`release_18295`)

    -   [](https://deploy.integration.publishing.service.gov.uk/job/deploy_puppet/build)

5.  You will either need to wait 30mins or read about convergence. After
    which you should keep an eye on Icinga, Smokey and test anything
    you're concerned about.
6.  Repeat the last step to deploy to production.

> -   [](https://deploy.publishing.service.gov.uk/job/Deploy_Puppet/)

## Build tags and release branches

Puppet deployments are different from most of the other application
deployments in GOV.UK in that we only ever deploy to Staging and
Production from the `release` branch. Build tags are promoted (merged)
into that branch prior to deployment.

This is in part because configuration management tools like Puppet rely
on managing only a subset of the complete system which doesn't lend
itself well to flipping backwards and forwards through build history.
Think of it like database migrations; you can't undo the creation of a
new column unless you write a new migration to explicitly remove it.

## Convergence

The deployment only pushes the new code to the Puppet master. Each node
runs a Puppet agent every 30mins (via cron), so it may be some time
before the release has taken effect. This has an implication on how
quickly you can go from Staging to Production.

If you would like to know which version of puppet is running where on a
specific environment, there is a script in the
[fabric-scripts](https://github.com/alphagov/fabric-scripts) repository
to help.

In order to run it, create a GitHub Access Token
[here](https://github.com/settings/tokens) and run the following inside
the fabric-scripts repository:

    GITHUB_ACCESS_TOKEN=<YOUR-GITHUB-TOKEN> ./bin/puppet_versions.sh

The script will prompt you for an environment (integration, staging or
production) and it will query all servers in that environment for the
version of puppet and the last time the puppet agent ran.

If you'd rather not wait and you're able to safely determine from the
diff what classes of machines the change will affect, or which ones are
still on an older version of puppet using the script above, you can use
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
> future so that it's not inconsistent with it's configuration.

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


