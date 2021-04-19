---
owner_slack: "#govuk-developers"
title: Grafana
section: Monitoring
type: learn
layout: manual_layout
parent: "/manual.html"
---

[Grafana](https://grafana.com/) is an open-source visualisation tool.
It does not store data, but consumes data sources to create real-time
graphs displayed on custom dashboards. Data sources include Prometheus,
[Graphite], [Logit] and CloudWatch. The query language of the data
store, such as PromQL for Prometheus, is used to construct the graphs.

[Graphite]: /manual/graphite-and-deployment-dashboards.html
[Logit]: /manual/logit.html

## Grafana dashboards

- [Production (AWS)](https://grafana.blue.production.govuk.digital)
- [Staging (AWS)](https://grafana.blue.staging.govuk.digital)
- [Integration (AWS)](https://grafana.integration.publishing.service.gov.uk)

Useful Grafana dashboards:

- [Origin health](https://grafana.publishing.service.gov.uk/dashboard/file/origin_health.json)
- [Edge health](https://grafana.publishing.service.gov.uk/dashboard/file/edge_health.json)
- [Application deployment dashboards](deployment-dashboards.html)

The full list of Grafana dashboards is [stored in the Puppet repo][dashboards].
For details on how to create a new dashboard, read the
[Grafana dashboards alert documentation](/manual/alerts/grafana-dashboards.html).

[dashboards]: https://github.com/alphagov/govuk-puppet/blob/master/modules/grafana/manifests/dashboards.pp

## Grafana tips

You can use regexes to filter for relevant information. For example,
[`*frontend*` on the processes dashboard](https://grafana.production.govuk.digital/dashboard/file/processes.json?refresh=1m&orgId=1&var-host=All&var-processes=*frontend*&from=now-15m&to=now)
to see all processes that have 'frontend' in them.

We often show multiple metrics on the same graph. The position of the
key shows which Y-axis each metric corresponds to:

![screenshot of multiple metrics selected](/manual/images/grafana-y-axis.png)

You can click on a metric in a graph to show only that metric, or you
can `CMD + click` to select multiple:

![screenshot of multiple metrics selected](/manual/images/grafana-select-multiple.png)

Annotations on charts show events such as deploys:

![screenshot of annotations](/manual/images/grafana-annotations.png)

For more tips, see the [Introduction to Grafana slides](https://docs.google.com/presentation/d/1jza62bRUt8BnyIqKkGP0oaP2X26pI-rooU6ri3YCm5w/edit).

## Fixing N/A in dashboards

When a request for data times out, Grafana will render an "N/A" in the panel.
Usually refreshing the page or choosing a shorter time range fixes the issue.

If a dashboard consistently returns "N/A", then there may be an underlying issue.

In the failing panel, open Query Inspector, and read the error message for clues:

![screenshot of query inspector](https://trello-attachments.s3.amazonaws.com/5acb8d0387ff12f600df0a13/5fa2aabcd3c6a14f183a4864/67fefdfd06aaaeca84977dcc32abc27f/Screenshot_2020-11-30_at_10.53.20.png)

If you see the following error:

```
raise CorruptWhisperFile(&quot;Unable to read header&quot;, fh.name) CorruptWhisperFile: Unable to read header (/opt/graphite/storage/whisper/stats/govuk/app/collections-publisher/ip-10-1-5-36/errors_occurred.wsp)
```

...that suggests the [disk was full at the time of writing to Graphite](https://github.com/graphite-project/carbon/issues/327).
The solution is to remove the corrupt file, and ensure there is space on the disk.

SSH into the relevant machine and `more errors_occurred.wsp` to see the file contents,
or `ls -lsa` in the directory to see the file sizes. This should confirm a file size of
zero.

Delete all empty (corrupt) WSP files with:

```sh
sudo find /opt/graphite/storage/whisper/ -type f -empty -delete
```

You should now find the dashboard panels load properly.
