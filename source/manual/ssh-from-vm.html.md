---
owner_slack: "#govuk-dev-tools"
title: SSH into GOV.UK servers from the VM
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-10
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
  version (`ssh -V`) and config (`~/.ssh/config`). You can also try `ssh jumpbox.integration`.
- **Do you get a permission denied error?** Make sure you're in the
  user list in the [govuk-secrets repo][govuk-secrets] for production access
  (restricted access; ask your tech lead or line manager for access), or the
  [govuk-puppet repo][govuk-puppet] for access to other environments.
  Alternatively, are you the correct user? If you're in the VM you might need to
  specify a username (example: `ssh joebloggs@jumpbox.integration.publishing.service.gov.uk`),
  as 'vagrant' might be the default ssh username.
- **Are you connecting from outside The White Chapel Building?**
  You'll need to connect to the VPN first; SSH connections are restricted
  to the White Chapel Building IP addresses.

[govuk-secrets]: https://github.com/alphagov/govuk-secrets/tree/master/puppet/hieradata
[govuk-puppet]: https://github.com/alphagov/govuk-puppet/tree/master/hieradata
