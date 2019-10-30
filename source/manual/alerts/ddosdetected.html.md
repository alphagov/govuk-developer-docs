---
owner_slack: "#govuk-2ndline"
title: DDOS Detected
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-24
review_in: 6 months
---

If there is a Distributed Denial of Service (DDoS) alert in Icinga this means that AWS have detected a probable DDoS attack on one or more of the AWS Shield Advanced
protected resources.

If the alert is `UNKNOWN`, this means that the alert is not working. This is a known issue which happens when there is no data for the CloudWatch metric that this alert is based on. The alert needs to be changed so that it doesn't fire when there are no data points.

If the alert is `CRITICAL`, you should take the following actions to investigate the issue:

1. Check the [CloudWatch dashboard](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#cw:dashboard=DDoSProtection). This should show the rate of DDoS requests, data throughput and packets which Amazon is detecting.
1. If the attack is ongoing, contact AWS support: https://console.aws.amazon.com/support/home
1. Inform them that the DDOSDetected alarm has been triggered.
1. Enquire about the nature of the attack.
1. Follow their instructions (if any).

The alert will appear on the Icinga dashboard for 24 hours after it was first triggered
due to the sparse metrics.
