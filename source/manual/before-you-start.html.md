---
owner_slack: "@hong.nguyen"
title: Before you start on 2nd line
parent: "/manual.html"
layout: manual_layout
section: 2nd line
last_reviewed_on: 2018-11-08
review_in: 2 months
---
Before you start your shift you’ll need access to the accounts we use and our communication channels.

## Dashboard
The 2nd line dashboard can be viewed [here](http://dsingleton.github.io/frame-splits/index.html?title=&layout=2col-75-25&url%5B%5D=https%3A%2F%2Fgrafana.publishing.service.gov.uk%2Fdashboard%2Ffile%2F2ndline_health.json%3Frefresh%3D1m%26orgId%3D1&url%5B%5D=https%3A%2F%2Fgovuk-secondline-blinken.herokuapp.com%2Fblinken.html&url%5B%5D=https%3A%2F%2Fgrafana.publishing.service.gov.uk%2Fdashboard%2Fdb%2Fapp-deployments%3Ffrom%3Dnow-7d%26to%3Dnow%26refresh%3D1m%26orgId%3D1&url%5B%5D=).

## Alerts
We use Icinga to monitor our platform and alert us when things go wrong. Please ensure you can access (if remote you will need to be on the [VPN](https://docs.publishing.service.gov.uk/manual/vpn.html)):

* [Production](https://alert.publishing.service.gov.uk)
* [Staging](https://alert.staging.publishing.service.gov.uk)
* [Integration](https://alert.integration.publishing.service.gov.uk)
* [AWS Production](https://alert.blue.production.govuk.digital)
* [AWS Staging](https://alert.blue.staging.govuk.digital)
* [CI](https://ci-alert.integration.publishing.service.gov.uk)

Most alerts have some documentation in our [developer docs](https://docs.publishing.service.gov.uk). Use our [Chrome extension](https://github.com/alphagov/blinkenjs#chrome-extension) to see the alert status of our different environments.


## Zendesk
[Zendesk](https://govuk.zendesk.com) is our support ticketing system. [Request an account](https://www.gov.uk/support/internal) if you don't have one yet - Signon access is required so speak to your fellow 2nd liners if you haven't got this.  This [diagram shows you how to process tickets](https://docs.google.com/presentation/d/1H8F9sTv283N_5j-3-LT2OW8Xvx0NrfCG1IjNA10vu2g/edit?usp=sharing).

## PagerDuty
This is our escalation workflow for some key alerts that are likely to require urgent attention. The escalation order is:

1. Primary Engineer
2. Secondary Engineer
3. Designated Programme team member (might not be technical)

This mirrors our out of hours on-call escalation order, so 2nd line can be thought of as in-hours on-call. 2nd line Shadows are not required to be on PagerDuty. If you're on Primary or Secondary, please check you can sign in to [PagerDuty](https://governmentdigitalservice.pagerduty.com). Speak to the Delivery Manager if you cannot sign in.

When an alert that triggers PagerDuty goes off, someone on the escalation schedule must acknowledge them, otherwise they will be escalated further. PagerDuty is for key aspects of the site becoming unavailable or a large quantity of error pages being served.

There is a [PagerDuty drill](https://docs.publishing.service.gov.uk/manual/alerts/pagerduty-drill.html) every Wednesday morning at 10am UTC. You will be called by PagerDuty and must escalate the incident to the next person in the escalation order. When you receive this call do not acknowledge it, instead escalate it so that each person in the workflow can be alerted.

You can also find out [what to do if there’s an incident](https://docs.publishing.service.gov.uk/manual/incident-management-guidance.html).

## Slack channels

Follow these Slack channels while you’re working on 2nd line:

* #govuk-2ndline - the main channel for people on 2nd line
* #govuk-deploy - every time a Staging/Production deploy is done, this is automatically posted to - people also manually post when putting branches on Integration for testing
* #govuk-developers - this is a general channel for developers and can be a good place to ask questions if you are struggling
