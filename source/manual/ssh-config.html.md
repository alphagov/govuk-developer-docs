---
owner_slack: "#2ndline"
title: SSH Configuration
parent: "/manual.html"
layout: manual_layout
section: Tools
last_reviewed_on: 2018-04-12
review_in: 6 months
---

Add the following to `~/.ssh/config`:

```
## CI
## --
Host ci-jumpbox
  Hostname ci-jumpbox.integration.publishing.service.gov.uk

Host *.ci
  ProxyCommand ssh -e none %r@ci-jumpbox -W $(echo %h | sed 's/\.ci$//'):%p

## Integration
## -----------
Host integration
  Hostname jumpbox.integration.publishing.service.gov.uk

Host *.integration
  ProxyCommand ssh -e none %r@integration -W $(echo %h | sed 's/\.integration$//'):%p

## Staging
## -------
Host jumpbox.staging.publishing.service.gov.uk
  ProxyCommand none

Host *.staging.publishing.service.gov.uk
  ProxyCommand ssh -e none %r@jumpbox.staging.publishing.service.gov.uk -W %h:%p

Host jumpbox-1.management.staging
  Hostname jumpbox.staging.publishing.service.gov.uk
  ProxyCommand none

Host jumpbox-2.management.staging
  Hostname jumpbox.staging.publishing.service.gov.uk
  Port     1022
  ProxyCommand none

Host *.staging
  ProxyCommand ssh -e none %r@jumpbox-1.management.staging -W $(echo %h | sed 's/\.staging$//'):%p

## Production
## ----------
Host jumpbox.publishing.service.gov.uk
  ProxyCommand none

Host *.publishing.service.gov.uk
  ProxyCommand ssh -e none %r@jumpbox.publishing.service.gov.uk -W %h:%p

Host jumpbox-1.management.production
  Hostname jumpbox.publishing.service.gov.uk
  ProxyCommand none

Host jumpbox-2.management.production
  Hostname jumpbox.publishing.service.gov.uk
  Port     1022
  ProxyCommand none

Host *.production
  ProxyCommand ssh -e none %r@jumpbox-1.management.production -W $(echo %h | sed 's/\.production$//'):%p
```

See [here](howto-ssh-to-machines-in-aws.html) about connecting to machines in AWS.
