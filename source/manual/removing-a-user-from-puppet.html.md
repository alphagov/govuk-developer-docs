---
owner_slack: "#govuk-2ndline-tech"
title: Remove a user from Puppet
parent: "/manual.html"
layout: manual_layout
section: Accounts
---

Removing a user from our infrastructure via Puppet is a 2 change process that
requires a deploy in the middle. The first change ensures that when Puppet
runs the user's home directory is removed; the second change removes the
user from Puppet itself. If the user is just removed from Puppet their files
will remain on our servers forever more, [unless you perform a workaround](#what-to-do-if-you-miss-the-ensure-absent-step).

1. First find the user manifest in: [modules/users/manifests][manifest-path].
1. Add an entry to the govuk_user class of `ensure => absent`. Here is an
   [example][absent-example].
1. Once this has been raised as a PR and merged, deploy Puppet to all
   environments.
1. Create a PR in [GOV.UK secrets][govuk-secrets] that removes the user from [AWS production hieradata][aws-production-hieradata]. Follow the instructions in [what to do when someone leaves][what-to-do-when-someone-leaves]
1. Create another PR for Puppet that:
  - Removes the user manifest file
  - Removes the user from [Integration users][integration-users]
1. Once these have been merged, deploy Puppet again to all environments.

[what-to-do-when-someone-leaves]: /manual/encrypted-hiera-data.html#what-to-do-when-someone-leaves
[manifest-path]: https://github.com/alphagov/govuk-puppet/tree/master/modules/users/manifests
[absent-example]: https://github.com/alphagov/govuk-puppet/commit/0757bad41ed577f15c7f5d9e508f55e78c612ddb
[integration-users]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/integration.yaml
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[production-hieradata]: https://github.com/alphagov/govuk-secrets/tree/master/puppet/hieradata
[aws-production-hieradata]: https://github.com/alphagov/govuk-secrets/tree/master/puppet_aws/hieradata

## What to do if you miss the 'ensure absent' step

If you forgot to apply the `ensure => absent` step in the instructions above,
the user's home directory will persist on any machine they have SSH'd into in
the past. This isn't inherently bad, but has caused issues with disk space in
the past where user had large files in that directory.

Machines will eventually get recycled as they're scaled up or down, so these
directories should naturally start to disappear over time. If there is a need
to remove the directories more quickly, you can consider using some of the
[commands here](/manual/howto-run-ssh-commands-on-many-machines.html#useful-commands).

Unfortunately it's [not possible to retrospectively reintroduce](https://github.com/alphagov/govuk-puppet/pull/10892#issuecomment-749678673)
the user with a `ensure => absent` argument, as the user will already have
been deleted. Filesystem permissions are done through user IDs rather than names.
