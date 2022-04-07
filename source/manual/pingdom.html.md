---
owner_slack: "#govuk-developers"
title: Pingdom
section: Monitoring
layout: manual_layout
parent: "/manual.html"
---

GOV.UK uses [Pingdom](https://www.pingdom.com/) to monitor the external availability of our services, integrating with [PagerDuty](/manual/pagerduty.html) to notify developers if a service becomes unavailable (owing to a DNS issue or network misconfiguration, for example).

Our internal monitoring tool, [Smokey](https://github.com/alphagov/smokey), is not as reliable at detecting problems like these, as it runs on the same local network as our services, and thus can't necessarily guarantee for us that users can reach our services.

Pingdom operates by making pre-defined requests at a regular interval (typically 1 minute) and if it returns a non-success response it will deem the host as down. After a suitable threshold (typically 5 minutes) of downtime it will alert that the host is down.

## Access Pingdom

GOV.UK account credentials for Pingdom are available in [govuk-secrets](https://github.com/alphagov/govuk-secrets) via the [Technical 2nd Line password store](https://github.com/alphagov/govuk-secrets/tree/master/pass) under `monitoring/pingdom`.

## Add a Pingdom check

Before you add a new check, see if an existing check covers your use case. For example, it's beneficial to have a single check on the `assets.publishing.service.gov.uk` hostname, as this determines an external user can reach that host. However, there'd be no benefit in checking for _assets_ served on that host, which should already be covered by internal tests in Smokey or Asset Manager, and from which we learn nothing extra if making the requests externally.

These instructions are for adding a standard HTTP request check.

1. In Pingdom, visit the [uptime](https://my.pingdom.com/app/newchecks/checks)
   section and click "Add new".
1. Name your check based on the service you are monitoring.
1. Leave the default check interval at 1 minute.
1. Select the "HTTP(S) check".
1. Enter the URL you are monitoring.
1. Leave the location as the default (North America/Europe).
1. Leave "Check importance" at the default of "High importance", we don't have
   different configurations for High or Low importance
1. Select "GOV.UK Technical 2nd Line" in the "Who to alert?" section and
   uncheck "Platform Team". This will mean the Technical 2nd Line email is
   notified when services are down for long enough to alert.
1. Leave "When down, alert after" at the default value of 5 minutes, this
   offers a buffer against alerting for a short lived spike.
1. Update the "Customized message" to capture any links to documentation
   or specific steps that would help someone if they received this alert.
1. In the "Webhook" section check the PagerDuty integration, this will mean in
   and out of hours support team are called up when the service is down and the
   alert threshold has passed.
