---
owner_slack: "#2ndline"
title: Update Pingdom IP Ranges
section: Environments
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-01-31
review_in: 6 months
---

There is a task that runs daily of "Check_Pingdom_IP_Ranges" which checks
whether the IP addresses we have stored for Pingdom match the ones they
are actually using.

If this task fails it is an indicator that our IPs are not consistent with
the ones they are using and we need to update our rules.

You will need to edit two files in [govuk_mirror_deployment][mirror_repo]:

- [vcloud-edge_gateway/vars/carrenza_mirror_vars.yaml][carrenza]
- [vcloud-edge_gateway/vars/skyscape_mirror_vars.yaml][skyscape]

Both have a list of Pingdom IPs and a command you can use to generate a new
list.

To run the check of IP ranges on your own machine clone the
[govuk_mirror_deployment][mirror_repo] and run `ruby tools/pingdom_ips.rb`.

[mirror_repo]: https://github.gds/gds/govuk_mirror-deployment
[carrenza]: https://github.gds/gds/govuk_mirror-deployment/blob/master/vcloud-edge_gateway/vars/skyscape_mirror_vars.yaml
[skyscape]: https://github.gds/gds/govuk_mirror-deployment/blob/master/vcloud-edge_gateway/vars/skyscape_mirror_vars.yaml
