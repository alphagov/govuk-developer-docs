---
owner_slack: "#govuk-2ndline-tech"
title: Search API app healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

See also: [how healthcheck alerts work on GOV.UK](app-healthcheck-not-ok.html)

## Elasticsearch connectivity is not OK

The Search API uses elasticsearch as an underlying data store and search
engine.

If the application cannot connect to the elasticsearch cluster,
this will prevent end users performing searches. Search API has [a custom healthcheck](https://github.com/alphagov/search-api/blob/05df032d2791769837d2b23cb8fd08a2bc474456/lib/rummager/app.rb#L311-L315) to check for this scenario.

Note: We use a managed elasticsearch, [Amazon Elasticsearch Service][aws-elasticsearch], rather than running our own.

### How do I investigate this?

Find out why the Search API can't connect to elasticsearch.

- Look at the Search API logs
- Look at the [elasticsearch cluster health][cluster-health]
- Check the status of the Elasticsearch cluster in the AWS console

[cluster-health]: /manual/alerts/elasticsearch-cluster-health.html
[aws-elasticsearch]: https://aws.amazon.com/elasticsearch-service/
