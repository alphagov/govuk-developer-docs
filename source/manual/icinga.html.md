---
owner_slack: "#govuk-2ndline"
title: Icinga
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
---

- Production
  - [AWS](https://alert.blue.production.govuk.digital)
  - [Carrenza](https://alert.publishing.service.gov.uk)
- Staging
  - [AWS](https://alert.blue.staging.govuk.digital)
  - [Carrenza](https://alert.staging.publishing.service.gov.uk)
- Integration
  - [AWS](https://alert.integration.publishing.service.gov.uk)
- CI
  - [Carrenza](https://ci-alert.integration.publishing.service.gov.uk)

Icinga is used to monitor alerts that we have set up. It can be a bit hard to
navigate but there are only a few views you need to know about (listed in the left-hand
navigation):

- Unhandled Services
- Alert History

Alternatively, you can pull these into one local dashboard by [setting up Nagstamon](/manual/nagstamon.html).

### Scanning alerts

- If an alert is red or has a ![critical][critical_image] icon it is critical
- If an alert is yellow or has a ![warning][warning_image] icon it is a warning
- If an alert is green or has a ![recovery][recovery_image] icon it has recently recovered
- If an alert is purple or has a ![unknown][unknown_image] icon Icinga cannot retrieve data for it
- If an alert has a ![flapping][flapping_image] icon the alert is coming on and off or 'flapping'

[critical_image]: images/icinga/critical.png
[warning_image]: images/icinga/warning.png
[recovery_image]: images/icinga/recovery.png
[unknown_image]: images/icinga/unknown.png
[flapping_image]: images/icinga/flapping.gif

### External URLs

A service may have two additional URLs associated with it which will assist
in investigating alerts. These are included in the Icinga interface with
these icons:

- Action URL (![action][action_image]) typically links to a graph. If the check uses
  Graphite for its source of data then the graph will also include the
  warning and critical threshold bands.
- Notes URL (![notes][notes_image]) links to a page in this manual describing why a given check
  exists and/or how to go about resolving it.

[action_image]: images/icinga/action.gif
[notes_image]: images/icinga/notes.gif

They will appear next to the service name in the service overview page or on
the top-right of the page when viewing a specific service.

### Digging deeper

If you want to dig a little deeper into the history of a specific alert click on it in the "Unhandled Services" view. In the top left of the main window there a few links. "View Alert Histogram For This Service" and "View Trends For This Service" are particularly useful.
