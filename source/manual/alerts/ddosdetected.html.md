---
owner_slack: "#govuk-2ndline-tech"
title: DDOS Detected
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

If there is a Distributed Denial of Service (DDoS) alert in Icinga this means that
AWS have detected a probable DDoS attack on one or more of the AWS Shield Advanced
protected resources.

If the alert is `UNKNOWN`, this means that the alert is not working properly.

If the alert is `CRITICAL`, you should take the following actions to investigate the issue:

1. Check the [CloudWatch dashboard](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#cw:dashboard=DDoSProtection). This should show the rate of DDoS requests, data throughput and packets which Amazon is detecting.
    * The dashboard might not display any graphs at all if no DDoS activity has been detected recently. This is a known issue and there is a [support ticket](https://console.aws.amazon.com/support/cases#/6554017771/en) open with Amazon about it. If the DDoSDetected alert is firing and the graphs are still not displayed, contact AWS support.
1. If the attack is ongoing, contact AWS support: <https://console.aws.amazon.com/support/home>
1. Inform them that the DDOSDetected alarm has been triggered.
1. Enquire about the nature of the attack.
1. Follow their instructions (if any).

The alert will appear on the Icinga dashboard for 24 hours after it was first triggered
due to the sparse metrics.

## AWS Shield Response Team (SRT)

We have pre-configured an [IAM role for the SRT team to use](https://github.com/alphagov/govuk-aws/pull/1550/files).

It is currently not assigned to any resources, but when activated will allow
the SRT to view our shielded resources and edit things such as Web Application
Firewall (WAF) rules, Access Control Lists (webacls), Shield and CloudFront
configurations.

We should not enable the role unless we are [engaged with the team](https://docs.aws.amazon.com/waf/latest/developerguide/ddos-edit-drt.html)
as a result of an incident.

To enable the role:

1. Open the AWS console for the affected environment, eg `gds aws govuk-integration-poweruser -l`
1. Navigate to the [Edit AWS Shield Response Team (SRT) access page](https://console.aws.amazon.com/wafv2/shieldv2#/drt_settings/edit)
1. In the AWS Shield Response Team (SRT) access section, select the "Choose an existing role for the SRT to access my accounts." radio button.
1. From the role name drop down, select "shield-response-team-access".
1. Click Save to apply the changes.
