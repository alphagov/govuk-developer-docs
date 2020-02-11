---
owner_slack: "#govuk-searchandnav"
title: How to publish a facet group
parent: "/manual.html"
layout: manual_layout
section: Publishing
type: learn
last_reviewed_on: 2020-02-04
review_in: 3 months
related_applications: [content-tagger]
---

Facet values are content items used to categorise other pieces of content. They can be used as filtering criteria in search API queries and used to populate finder results for multiple content formats from across GOV.UK.

Facet values are grouped by Facet which are a collection in a Facet Group.

The corresponding document types for these content items are (`facet_value`, `facet` and `facet_group`). These are related to one another via the relevant links.

Content Tagger is the central place for managing a facet group. It contains rake tasks to draft a facet group, facets and their facet values and publish these content items.

### How to import or update a facet group

1. [Define your group in content tagger data](https://raw.githubusercontent.com/alphagov/content-tagger/master/lib/data/find-eu-exit-guidance-business.yml)
1. Run [the `facets:import_facet_group` Rake task to import the facet group as draft](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE_CLASS=backend&RAKE_TASK=facets:import_facet_group[path-to-facet-yaml])
1. Run [the `facets:publish_facet_group` Rake task to publish the facet group](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE_CLASS=backend&RAKE_TASK=[path-to-facet-yaml]
