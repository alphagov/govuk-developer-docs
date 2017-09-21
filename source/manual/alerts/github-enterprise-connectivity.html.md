---
owner_slack: "#govuk-infrastructure"
title: GitHub Enterprise connectivity
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/alerts/github-enterprise-connectivity.md"
last_reviewed_on: 2017-09-21
review_in: 1 month
---

Some machines have a VPN connection to the GDS office so that they can
clone repositories from GitHub Enterprise.

The [Puppet class that sets up the VPN][puppet_vpn] sets up openconnect and
adds an alert that checks that GitHub Enterprise is reachable.

## Troubleshooting

- Ensure that the `openconnect` service is running
- If it crashes as soon as you start it, check the logs
- Use the GOV.UK Aviation House VPN credentials to try
  connecting from your own machine (if those don't work, talk
  to the IT Service Desk)

[puppet_vpn]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_ghe_vpn/manifests/init.pp
