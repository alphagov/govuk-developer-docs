---
owner_slack: "#govuk-2ndline-tech"
title: Scale unicorn workers
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

### Check the number of unicorn workers currently running

You will need to SSH into the machine class for your chosen application, you can find this information in the developer docs, for example, the machine class for [Smart Answers](/repos/smart-answers.html) is `calculators_frontend`

SSH into the machine on Integration using the command below

`gds govuk connect -e integration ssh calculators_frontend`

Once connected, run the command below to get a list of the Unicorn Workers running on the machine:

`ps -ax | grep unicorn | grep smartanswers`

You should then get an output similar to that below. In this example we can see that 4 unicorn workers are running on the machine.

```shell
18789 ?        S      0:00 unicorn master -D -P /var/run/smartanswers/app.pid -p 3010 -c /var/apps/smartanswers/config/unicorn.rb
18790 ?        S      0:12 unicorn worker[0] -D -P /var/run/smartanswers/app.pid -p 3010 -c /var/apps/smartanswers/config/unicorn.rb
18791 ?        S      0:11 unicorn worker[1] -D -P /var/run/smartanswers/app.pid -p 3010 -c /var/apps/smartanswers/config/unicorn.rb
18792 ?        S      0:12 unicorn worker[2] -D -P /var/run/smartanswers/app.pid -p 3010 -c /var/apps/smartanswers/config/unicorn.rb
18793 ?        S      0:13 unicorn worker[3] -D -P /var/run/smartanswers/app.pid -p 3010 -c /var/apps/smartanswers/config/unicorn.rb
```

### Increase the number of unicorn workers

- Create a branch of [govuk-puppet](https://github.com/alphagov/govuk-puppet)
- Increase the number of unicorn workers for your chosen application
  - [Example PR](https://github.com/alphagov/govuk-puppet/pull/11194)
- [Deploy your branch to Integration](https://deploy.integration.publishing.service.gov.uk/job/Deploy_Puppet/)
- [Run govuk-puppet](/manual/alerts/puppet-last-run-errors.html#re-run-puppet) on the relevant machine, to pull in the changes
- Follow the [steps from the previous section](#check-the-number-of-unicorn-workers-currently-running) to confirm the number of unicorn workers is now as expected
