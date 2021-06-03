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

You may diagnose this issue by looking at the `system logs` in AWS console
(select the failed instance in EC2 console -> `Actions` ->
`Monitor and troubleshoot` -> `Get system log`) and seeing whether all
init scripts have been run.

This issue is more severe in Staging due to `unattended reboot` checking every
5 minutes at all hours of the day (see [here](https://github.com/alphagov/govuk-puppet/commit/fd1a291ca69bae254b4b0efacec13f4228939496))
rather than between [0-5](https://github.com/alphagov/govuk-puppet/blob/e76b397c3e570ba807791befbf61758100e143d8/hieradata_aws/common.yaml#L1521) for Integration and Production.

You could temporarily disable `unattended reboot` by adding this to the relevant hiera:
`govuk_unattended_reboot::enabled: false`, deploy the branch of Puppet and create new
instances again.
