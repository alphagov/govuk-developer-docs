---
owner_slack: "#govuk-2ndline"
title: DDOS Detected
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-07-24
review_in: 6 months
---

If there is a Distributed Denial of Service (DDOS) alert in Icinga this means that AWS have detected a probable DDOS attack on one or more of the AWS Shield Advanced
protected resources.

You should take the following actions to investigate the issue:

1. Contact AWS support https://console.aws.amazon.com/support/home
1. Inform them that the DDOSDetected alarm has been triggered
1. Enquire about the nature of the attack
1. Follow their instructions (if any)

The alert will appear on the Icinga dashboard for 24 hours after it was first triggered
due to the sparse metrics.
