---
owner_slack: "#govuk-developers"
title: 'Tools: Icinga, Grafana and Graphite, Kibana and Fabric'
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-11
review_in: 6 months
---

## Icinga

[Icinga](/manual/icinga.html) is used to monitor alerts that we have set up.

## Grafana

[Grafana](/manual/grafana.html) lets us create nice dashboards using data from Graphite, Elasticsearch (Logit) and Cloudwatch.

## Graphite

<https://graphite.publishing.service.gov.uk/>

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

## Kibana

Kibana is a log viewer and search engine. Access GOV.UK Kibana through [Logit](logit.html).

In Kibana, you can filter down log messages to show you just the ones you want. Say you’ve spotted a large number of errors coming from the content store related to MongoDB connections, and you want to find out whether the MongoDB logs show anything strange.

You can narrow down which log messages you want using the column browser on the left: `@source_host` and `application` are some particularly useful ones. The magnifying glass symbol next to each value lets you build up a query string and tinker with it.

You can tweak the time range manually with the drop down at the top or by dragging on the timeline.

Check out some of the [useful Kibana queries](kibana.html) to get an idea of what's possible.

Logs are sent to Kibana using [Filebeat](logging.html#filebeat).

## Fabric Scripts

<https://github.com/alphagov/fabric-scripts/>

The Fabric scripts are useful for running something on a set of machines. For instance, to restart all instances of the content store on backend boxes:

`fab $environment class:backend app.reload:content-store`

Check the `app.py` class for different methods you can use. To run more specific commands you can run the following (`sdo` for sudo):

`fab $environment class:backend sdo:"service content-store reload"`

For more information, check out the [Fabric scripts README](https://github.com/alphagov/fabric-scripts#readme>).

## On the blog

- [Monitoring the GOV.UK infrastructure](https://gdstechnology.blog.gov.uk/2016/03/30/monitoring-the-gov-uk-infrastructure/)
