---
owner_slack: "#govuk-developers"
title: Add a Pingdom check
section: Monitoring
layout: manual_layout
parent: "/manual.html"
---

GOV.UK uses [Pingdom](https://www.pingdom.com/) to provide an external view of
the availability of our services, this compares to our internal monitoring
which is performed from within the same local network. With internal monitoring
(such as [Smokey][]) we can tell that services are serving requests, but this
doesn't necessarily tell us that users can reach them (for example, there could
be problems with DNS or a network misconfiguration). Pingdom, therefore, serves
this role in providing a different perspective.

Pingdom operates by making pre-defined requests at a regular interval
(typically 1 minute) and if it returns a non-success response it will deem
the host as down. After a suitable threshold (typically 5 minutes) of downtime
it will alert that the host is down.

[Smokey]: https://github.com/alphagov/smokey

## How to access GOV.UK Pingdom

Credentials for Pingdom are available in [govuk-secrets][] via the [2nd line
password store][] under `monitoring/pingdom`.

[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[2nd line password store]: https://github.com/alphagov/govuk-secrets/tree/master/pass

## When to add a check

You should add a Pingdom check when we gain extra value from the external
perspective and that it can tell us something more than we can get from our own
internal monitoring.

For example, we benefit from a single check on
`assets.publishing.service.gov.uk` hostname, this determines
an external user can use that hostname. Adding additional checks for assets
served on this hostname does not provide any additional information from an
external perspective.

For situations where you are considering adding a Pingdom check but this does
not provide any additional external insight you should instead consider adding
a [test to Smokey][Smokey].

## Adding a check

These instructions are based on adding a check for HTTP request, if you are
checking something unusual or with specific needs you may need to tweak this
for your use case.

1. In Pingdom, visit the [uptime](https://my.pingdom.com/app/newchecks/checks)
   section and click "Add new".
1. Name your check based on the service you are monitoring.
1. Leave the default check interval at 1 minute.
1. Select the "HTTP(S) check".
1. Enter the URL you are monitoring.
1. Leave the location as the default (North America/Europe).
1. Leave "Check importance" at the default of "High importance", we don't have
   different configurations for High or Low importance
1. Select "GOV.UK 2nd line support" in the "Who to alert?" section and
   uncheck "Platform Team". This will mean the 2nd line support email is
   notified when services are down for long enough to alert.
1. Leave "When down, alert after" at the default value of 5 minutes, this
   offers a buffer against alerting for a short lived spike.
1. Update the "Customized message" to capture any links to documentation
   or specific steps that would help someone if they received this alert.
1. In the "Webhook" section check the PagerDuty integration, this will mean in
   and out of hours support team are called up when the service is down and the
   alert threshold has passed.
