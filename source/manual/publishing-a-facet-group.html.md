---
title: How to publish a facet group
parent: "/manual.html"
layout: manual_layout
section: Publishing
type: learn
owner_slack: "#govuk-platform-health"
last_reviewed_on: 2019-03-29
review_in: 3 months
related_applications: [content-tagger]
---

Facet values are content items used to categorise other pieces of content. They can be used as filtering criteria in search API queries and used to populate finder results for multiple content formats from across GOV.UK.


Facet values are grouped by Facet which are a collection in a Facet Group.

The corresponding document types for these content items are (`facet_value`, `facet` and `facet_group`). These are related to one another via the relevant links.

Content tagger is the central place for managing a facet group. It contains rake tasks to draft a facet group, facets and their facet values and publish these content items.


### How to import or update a facet group

1. [Define your group in content tagger data](https://raw.githubusercontent.com/alphagov/content-tagger/master/lib/data/find-eu-exit-guidance-business.yml)
2. Run [this rake task to import the facet group as draft items](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE_CLASS=backend&RAKE_TASK=facets:import_facet_group[%22lib/data/find-eu-exit-guidance-business.yml%22])

```
rake facets:import_facet_group[<path-to-facet-group-config>]
```

3. Run [this rake task to publish the facet group](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE_CLASS=backend&RAKE_TASK=facets:publish_facet_group[%22lib/data/find-eu-exit-guidance-business.yml%22])

```
rake facets:publish_facet_group[<path-to-facet-group-config>]
```
