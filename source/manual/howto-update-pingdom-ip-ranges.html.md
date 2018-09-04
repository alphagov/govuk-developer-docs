---
owner_slack: "#govuk-2ndline"
title: Update Pingdom IP ranges
section: Environments
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-04
review_in: 6 months
---

> **NOTE**
> This process only applies to Carrenza environments.

The "Check_Pingdom_IP_Ranges" Jenkins job runs daily and checks
whether the IP addresses we have stored for Pingdom match the ones they
are actually using.

If this task fails, it is an indicator that our IPs are not consistent with
the ones they are using and we need to update our rules.

Edit the [carrenza_mirror_vars.yaml][carrenza] file in the
[govuk_mirror-deployment][mirror-repo]. There is a command in the comments of
that file that will generate a new list of IP addresses in YAML format.

To check the IP addresses from your own machine, clone the
[govuk_mirror-deployment][mirror-repo] and run `ruby tools/pingdom_ips.rb`.

[mirror-repo]: https://github.com/alphagov/govuk_mirror-deployment
[carrenza]: https://github.com/alphagov/govuk_mirror-deployment/blob/master/vcloud-edge_gateway/vars/carrenza_mirror_vars.yaml
