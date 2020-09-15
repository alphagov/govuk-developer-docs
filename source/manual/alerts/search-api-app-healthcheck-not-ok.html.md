---
owner_slack: "#govuk-2ndline"
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
this will prevent end users performing searches.

Note: We use a managed elasticsearch, [Amazon Elasticsearch Service][aws-elasticsearch], rather than running our own.

To solve this issue, look at the logs of the application to see what
is wrong.

### How do I investigate this?

Find out why the Search API can't connect to elasticsearch.

- Look at the Search API logs
- Look at the [elasticsearch cluster health][cluster-health]
- Check the status of the Elasticsearch cluster in the AWS console

## Reranker is not OK

The Search API uses machine learning to rank search results based on
analytics data.  If this alert fires, something has gone wrong with
that process and we're serving results as they were ordered by
elasticsearch.

Unlike the other healthcheck failures, this does not mean that Search
API is serving errors.  Only that it is serving potentially worse
results.

The machine learning model is hosted in [Amazon SageMaker][aws-sagemaker].

### How do I investigate this?

Find out why the Search API can't connect to elasticsearch.

- Look at the error message in the healthcheck response
- Look at the Search API logs
- Check the status of the SageMaker endpoint in the AWS console

[sentry]: /manual/error-reporting.html
[search-github-repo]: https://github.com/alphagov/search-api/
[cluster-health]: /manual/alerts/elasticsearch-cluster-health.html
[aws-elasticsearch]: https://aws.amazon.com/elasticsearch-service/
[aws-sagemaker]: https://aws.amazon.com/sagemaker/
