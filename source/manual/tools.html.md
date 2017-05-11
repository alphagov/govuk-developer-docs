---
owner_slack: "#2ndline"
title: 'Tools: Icinga, Grafana and Graphite, Kibana and Fabric'
section: Tools
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/tools.md"
last_reviewed_on: 2017-03-09
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.com/alphagov/govuk-legacy-opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.com/alphagov/govuk-legacy-opsmanual/tree/master/2nd-line/tools.md)


## Icinga

<https://alert.publishing.service.gov.uk/>

Icinga is used to monitor alerts that we have set up. It can be a bit hard to
navigate but there are only a few views you need to know about (listed in the left-hand
navigation):

- Unhandled Services
- Alert History

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

## Grafana

Grafana lets us create nice dashboards using Graphite data.

Useful Grafana dashboards:

- [Origin health](https://grafana.publishing.service.gov.uk/#/dashboard/file/origin_health.json)
- [Edge health](https://grafana.publishing.service.gov.uk/#/dashboard/file/edge_health.json)
- [Application deployment dashboards](deployment-dashboards.html)

The full list of Grafana dashboards is [stored in the Puppet repo][dashboards]

[dashboards]: https://github.com/alphagov/govuk-puppet/blob/master/modules/grafana/manifests/dashboards.pp

## Graphite

<https://graphite.publishing.service.gov.uk/>

Graphite is a graphing tool that allows us to draw graphs of various metrics that we put into it. Graphite has two main views: a [composer](https://graphite.publishing.service.gov.uk/composer) to build individual graphs and a [dashboard](https://graphite.publishing.service.gov.uk/dashboard) to put multiple graphs together.

We are currently locked at version 0.9.13.

To build a graph, you can add one or more graph targets in the composer by either clicking on them in the left frame.
Some useful targets are:

- `stats.cache-?_router.nginx_logs.www-origin.http_5xx` to graph the rate of HTTP errors from all cache machines (note the question mark to pattern-match multiple data series: * also works).
- `stats.backend-?_backend.nginx_logs.contentapi_publishing_service_gov_uk.http_5xx` to show HTTP errors for a specific app on all backend machines.

The composer offers tab completion, although it doesn’t handle patterns very well.

To add one of these graphs to a dashboard, you can copy the graph image URL and select Graphs → New Graph → From URL from the dashboard menu.

Both Graphite views let you adjust the time range of graphs, although they both do it in different ways. The composer view offers two buttons to select absolute and relative time ranges (![composer_buttons][composer_buttons_image]), and the dashboard view has ones with labels (![dashboard_buttons][dashboard_buttons_image]).

[composer_buttons_image]: images/composer-buttons.png
[dashboard_buttons_image]: images/dashboard-buttons.png

Our [deployment dashboards](deployment-dashboards.html) use Graphite extensively. [See some tips](graphite-and-deployment-dashboards.html) on how to best manipulate the data streams to create useful dashboards.

### Applying Functions

Graphite has a whole bunch of functions you can apply to your data to make it more useful: they’re listed out [in the Graphite docs](http://graphite.readthedocs.org/en/0.9.12/functions.html). One particularly useful one is `keepLastValue`: if your graphs come out nearly black with a few spots of colour in them, you probably want this one. Both views have an Apply Function button.
## Kibana

<https://kibana.publishing.service.gov.uk/>

Kibana is a log viewer and search engine. In Kibana, you can filter down log messages to show you just the ones you want. Say you’ve spotted a large number of errors coming from the content API related to Mongo connections and you want to find out whether the Mongo logs show anything strange. You can narrow down which log messages you want using the column browser on the left: `@source_host` and `@fields.application` are some particularly useful ones. The magnifying glass symbol next to each value lets you build up a query string and tinker with it.

You can tweak the time range manually with the drop down at the top or by dragging on the timeline.

Check out some of the [useful Kibana queries](kibana.html) to get an idea of what's possible.

## Fabric Scripts

<https://github.com/alphagov/fabric-scripts/>

The Fabric scripts are useful for running something on a set of machines. For instance, to restart all instances of the content API on backend boxes:

`fab $environment class:backend app.reload:contentapi`

Check the `app.py` class for different methods you can use. To run more specific commands you can run the following (`sdo` for sudo):

`fab $environment class:backend sdo:"service contentapi reload"`

For more information, check out the [Fabric scripts README](https://github.com/alphagov/fabric-scripts#readme>).

## On the blog

- [Monitoring the GOV.UK infrastructure](https://gdstechnology.blog.gov.uk/2016/03/30/monitoring-the-gov-uk-infrastructure/)
