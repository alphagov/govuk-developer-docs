---
owner_slack: "#govuk-2ndline"
title: Use Graphite to monitor GOV.UK
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-01-31
review_in: 6 months
old_paths:
 - /manual/graphite-and-deployment-dashboards.html
 - /manual/metrics.html
---

<https://graphite.publishing.service.gov.uk/>

[Graphite] is the service used on GOV.UK to store metrics. Normally, metrics are sent by applications to another service called statsd, which will run on the local machine, and then the statsd service will forward the metrics to Graphite.

Graphite is a graphing tool that allows us to draw graphs of various metrics that we put into it. Graphite has two main views: a [composer](https://graphite.publishing.service.gov.uk/composer) to build individual graphs and a [dashboard](https://graphite.publishing.service.gov.uk/dashboard) to put multiple graphs together.

We are currently locked at version 0.9.13.

To build a graph, you can add one or more graph targets in the composer by either clicking on them in the left frame.
Some useful targets are:

- `stats.cache-?_router.nginx_logs.www-origin.http_5xx` to graph the rate of HTTP errors from all cache machines (note the question mark to pattern-match multiple data series: * also works).
- `stats.backend-?_backend.nginx_logs.content-store_publishing_service_gov_uk.http_5xx` to show HTTP errors for a specific app on all backend machines.

The composer offers tab completion, although it doesn’t handle patterns very well.

To add one of these graphs to a dashboard, you can copy the graph image URL and select Graphs → New Graph → From URL from the dashboard menu.

Both Graphite views let you adjust the time range of graphs, although they both do it in different ways. The composer view offers two buttons to select absolute and relative time ranges (![composer_buttons][composer_buttons_image]), and the dashboard view has ones with labels (![dashboard_buttons][dashboard_buttons_image]).

[composer_buttons_image]: images/composer-buttons.png
[dashboard_buttons_image]: images/dashboard-buttons.png

Our [deployment dashboards](deployment-dashboards.html) use Graphite extensively. [See some tips](graphite-and-deployment-dashboards.html) on how to best manipulate the data streams to create useful dashboards.

### Applying Functions

Apply [Graphite functions](http://graphite.readthedocs.org/en/0.9.12/functions.html) to your data to make it more useful.

One particularly useful Graphite function is `keepLastValue`. If your graphs come out nearly black with a few spots of colour in them, you probably want this one. Both views have an "Apply Function" button.

[graphite]: https://graphite.publishing.service.gov.uk/
