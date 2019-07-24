---
owner_slack: "#govuk-2ndline"
title: Remove a user from Puppet
parent: "/manual.html"
layout: manual_layout
section: Accounts
last_reviewed_on: 2019-05-29
review_in: 12 months
---

Removing a user from our infrastructure via Puppet is a 2 change process that
requires a deploy in the middle. The first change ensures that when Puppet
runs the user's home directory is removed; the second change removes the
user from Puppet itself. If the user is just removed from Puppet their files
will remain on our servers forever more.

1. First find the user manifest in: [modules/users/manifests][manifest-path].
2. Add an entry to the govuk_user class of `ensure => absent`. Here is an
   [example][absent-example].
3. Once this has been raised as a PR and merged, deploy Puppet to all
   environments.
4. Create another PR for Puppet that:
  - Removes the user manifest file
  - Removes the user from [Integration users][integration-users]
  - Removes the user from [AWS training environment users][training-environment]
  - Removes the user from [CI users][ci-users]
5. Create a PR in [GOV.UK secrets][govuk-secrets] that:
  - Removes the user from [production hieradata][production-hieradata]. Read [what to do when someone leaves][what-to-do-when-someone-leaves]
  - Removes the user from [AWS production hieradata][aws-production-hieradata]. Read [what to do when someone leaves][what-to-do-when-someone-leaves]
6. Once these have been merged, deploy Puppet again to all environments.

[what-to-do-when-someone-leaves]: https://docs.publishing.service.gov.uk/manual/encrypted-hiera-data.html#what-to-do-when-someone-leaves
[manifest-path]: https://github.com/alphagov/govuk-puppet/tree/master/modules/users/manifests
[absent-example]: https://github.com/alphagov/govuk-puppet/commit/0757bad41ed577f15c7f5d9e508f55e78c612ddb
[integration-users]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/integration.yaml
[training-environment]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/training.yaml
[ci-users]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/integration.yaml
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[production-hieradata]: https://github.com/alphagov/govuk-secrets/tree/master/puppet/hieradata
[aws-production-hieradata]: https://github.com/alphagov/govuk-secrets/tree/master/puppet_aws/hieradata
