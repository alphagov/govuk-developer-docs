---
owner_slack: "#govuk-2ndline"
title: Before you start on 2nd line
parent: "/manual.html"
layout: manual_layout
section: 2nd line
last_reviewed_on: 2018-05-15
review_in: 2 months
---
Before you start your shift you’ll need access to the accounts we use and our communication channels.

## Alerts
We use Icinga to monitor our platform and alert us when things go wrong. Please ensure you can access (if remote you will need to be on the [VPN](https://docs.publishing.service.gov.uk/manual/vpn.html)):

* [Production](https://alert.publishing.service.gov.uk)
* [Staging](https://alert.staging.publishing.service.gov.uk)
* [Integration](https://alert.integration.publishing.service.gov.uk)

Most alerts have some documentation in our [developer docs](https://docs.publishing.service.gov.uk). Use our [Chrome extension](https://github.com/alphagov/blinkenjs#chrome-extension) to see the alert status of our different environments.


## Zendesk
[Zendesk](https://govuk.zendesk.com) is our support ticketing system. Make sure you can sign in. This [diagram shows you how to process tickets](https://docs.google.com/presentation/d/1mUnkONOrto2SKRKAO6JnnSUHRLsMy4eZEoq75BGxC6E/edit?usp=sharing).

## PagerDuty
This is our escalation workflow for some key alerts that are likely to require urgent attention. When an alert that triggers pager duty goes off we require one of the 2nd line to acknowledge them, otherwise they will be escalated further. The sort of issues which would generate pagerduty are for key aspects of the site becoming unavailable or a large quantity of error pages served.

Please check you can sign in to [PagerDuty](https://govuk.pagerduty.com/). Speak to the delivery manager if you cannot sign in.

There is a [PagerDuty drill](https://docs.publishing.service.gov.uk/manual/alerts/pagerduty-drill.html) every Wednesday morning at 11am. You will be called by PagerDuty and must escalate the incident to the person on 3rd line. When you receive this call do not acknowledge it, instead escalate it so that each person in the workflow can be alerted.


You can also find out [what to do if there’s an incident](https://docs.publishing.service.gov.uk/manual/incident-management-guidance.html).

## Slack channels

Follow these Slack channels while you’re working on 2nd line:

* #govuk-2ndline - the main channel for people on 2nd line
* #govuk-deploy - every time a Staging/Production deploy is done, this is automatically posted to - people also manually post when putting branches on Integration for testing
* #govuk-developers - this is a general channel for developers and can be a good place to ask questions if you are struggling
