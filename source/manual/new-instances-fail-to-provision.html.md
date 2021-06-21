---
owner_slack: "#re-govuk"
title: New instances fail to provision
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

Sometimes, it may happen that a new instance is not provisioned correctly due to
`unattended reboot` rebooting the instance before all the init scripts have
time to run.

This issue is more likely in Staging due to `unattended reboot` checking [every
5 minutes at all hours of the day](https://github.com/alphagov/govuk-puppet/commit/fd1a291ca69bae254b4b0efacec13f4228939496) rather than between [midnight and 5am](https://github.com/alphagov/govuk-puppet/blob/e76b397c3e570ba807791befbf61758100e143d8/hieradata_aws/common.yaml#L1521) for Integration and Production.

## Symptoms

You'll likely see "puppet last run errors" on the instance.
When running `govuk_puppet --test`, you'll likely see output like this:

```sh
$ govuk_puppet --test
# ...
Error: Execution of '/usr/bin/apt-get -q -y -o DPkg::Options::=--force-confold install libxml2-dev' returned 100: E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.
Error: /Stage[main]/Base::Packages/Package[libxml2-dev]/ensure: change from absent to present failed: Execution of '/usr/bin/apt-get -q -y -o DPkg::Options::=--force-confold install libxml2-dev' returned 100: E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.
Info: Class[Nginx::Config]: Scheduling refresh of Class[Nginx::Service]
Info: Class[Nginx::Service]: Scheduling refresh of Service[nginx]
Notice: /Stage[main]/Nginx::Service/Service[nginx]: Triggered 'refresh' from 1 events
Notice: /Stage[main]/Govuk_scripts/Exec[check_boto]: Dependency Package[libxml2-dev] has failures: true
Warning: /Stage[main]/Govuk_scripts/Exec[check_boto]: Skipping because of failed dependencies
Notice: Finished catalog run in 24.56 seconds
```

## Diagnosis

You may diagnose this issue by looking at the `system logs` in AWS console
(select the failed instance in EC2 console -> `Actions` ->
`Monitor and troubleshoot` -> `Get system log`) and seeing whether all
init scripts have been run.

## Treatment

Replatforming have a [card](https://trello.com/c/uymM8qmy/538-fix-intermittently-broken-provisioning-in-ec2-govuk-because-of-unattended-reboot) to fix this.

Until then, the recommended fix is to run `/usr/local/bin/govuk_sync_apps` once puppet has run cleanly on the machine. Note that the script takes some time to complete as there is a `sleep 180` in it.

Failing that, you could try [reprovisioning the machine](/manual/reprovision.html). If the issue persists, you may need to temporarily disable `unattended reboot` by adding `govuk_unattended_reboot::enabled: false` to the relevant hiera. You'll need to deploy the branch of Puppet before creating the new instances again.
