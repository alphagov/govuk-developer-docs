---
owner_slack: "#govuk-search"
title: Add a new field to an elasticsearch document type
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
related_repos: [search-api]
---

## The elasticsearch schema

`config/schema` contains JSON files that together define a schema for documents in Search API. This is described in more detail in the
[schema documentation][schema-documentation].

When adding a new field, first you need to decide which field type to use.
`field_types.json` defines common elasticsearch configuration that we reuse for multiple fields having the same type.

The type you use affects whether the field is [analysed][] by elasticsearch and whether you can use it in [filters][] and [aggregates][].

Add your new field to `field_definitions.json`.

If your field should be valid for any kind of document, you can add it to `base_elasticsearch_type.json`. Otherwise, add it to the appropriate JSON file under `elasticsearch_types`.

## Integration testing

The easiest way to test the new fields is to write an integration test for it. These tests run against a development Elasticsearch cluster, and create new search indices each test run.

## Updating Search API schema indexes on all environments

In order for the new field to work as expected, you will need to reindex elasticsearch. Follow the guidance on [how to reindex elasticsearch][reindex-guide].

If you consider the change low risk and are only adding new fields for which content doesn't yet exist, you can run the `search:update_schema` [task][update-schema-task].
This task will attempt to update the Elasticsearch index schema in place without requiring a re-index.
If you have made any changes which affect existing fields, Elasticsearch will reject the change and a full re-index will be required.

[schema-documentation]: https://docs.publishing.service.gov.uk/repos/search-api/schemas.html
[analysed]: https://www.elastic.co/guide/en/elasticsearch/guide/current/mapping-analysis.html
[filters]: https://www.elastic.co/guide/en/elasticsearch/reference/6.8/query-filter-context.html
[aggregates]: https://www.elastic.co/guide/en/elasticsearch/reference/6.8/search-aggregations.html
[reindex-guide]: https://docs.publishing.service.gov.uk/manual/reindex-elasticsearch.html
[update-schema-task]: https://github.com/alphagov/search-api/blob/main/lib/tasks/indices.rake#L131-L149
