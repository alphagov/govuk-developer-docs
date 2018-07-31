---
owner_slack: "#govuk-2ndline"
title: SSH into GOV.UK servers from the VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-07-31
review_in: 6 months
---

By default, your SSH agent is forwarded to the VM. To confirm your key has
been forwarded you can run:

```shell
$ vagrant ssh # ssh onto vm
$ ssh-add -L  # list key and location on host machine
```

Things to check if it doesn't work:

- **Can you SSH directly onto the jumpbox?**
  `ssh jumpbox.integration.publishing.service.gov.uk` If not, check your ssh
  version and config.
- **Do you get a permission denied error?** Make sure you're in the
  user list in the [govuk-secrets repo][govuk-secrets] for production access,
  or the [govuk-puppet repo][govuk_puppet] for access to other environments.
- **Are you connecting from outside The White Chapel Building?**
  You'll need to connect to the VPN first; SSH connections are restricted
  to the White Chapel Building IP addresses.

[govuk-secrets]: https://github.com/alphagov/govuk-secrets/tree/master/puppet/hieradata
[govuk-puppet]: https://github.com/alphagov/govuk-puppet/tree/master/hieradata
