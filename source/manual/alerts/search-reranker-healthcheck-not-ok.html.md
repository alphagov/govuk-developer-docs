---
owner_slack: "#govuk-2ndline-tech"
title: Search reranker healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

The Search API uses machine learning to rank search results based on
analytics data.  If this alert fires, something has gone wrong with
that process and we're serving results as they were ordered by
elasticsearch.

Unlike the other healthcheck failures, this does not mean that Search
API is serving errors.  Only that it is serving potentially worse
results.

The machine learning model is hosted in [Amazon SageMaker][aws-sagemaker].

### How do I investigate this?

Find out why the Search API can't connect to SageMaker.

- Look at the error message in the healthcheck response
- Look at the Search API logs
- Check the status of the [SageMaker endpoint in the AWS console][sagemaker-endpoint]

[aws-sagemaker]: https://aws.amazon.com/sagemaker/
[sagemaker-endpoint]: https://eu-west-1.console.aws.amazon.com/sagemaker/home?region=eu-west-1#/endpoints/govuk-production-search-ltr-endpoint
