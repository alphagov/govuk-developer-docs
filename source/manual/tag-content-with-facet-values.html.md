---
title: How to tag content with facet values
parent: "/manual.html"
layout: manual_layout
section: Publishing
type: learn
owner_slack: "#govuk-platform-health"
last_reviewed_on: 2019-03-29
review_in: 3 months
related_applications: [content-tagger]
---

Content tagger is the central place for tagging content with facet values.

### How to edit facet values for a single page

**Note** This workflow would normally be performed by 2nd-line content designers.

You'll need GDS Editor permissions for content tagger.

1. Visit the [facet groups admin page in content tagger](https://content-tagger.integration.publishing.service.gov.uk/facet_groups)
2. Click on the facet group you'd like to use for tagging content.
3. Enter the page path you'd like to edit.
4. Type to search available facets in the "Facets" select field and assign the appropriate values.
5. (Optional) If you'd like to pin this content item to the top of finder results (currently only supported in the _Find EU Exit Guidance for Business_ finder) check the appropriate box.
6. (Optional) If you'd like to notify subscribers to the finder using this facet group than new content has been added to the search results check the appropriate box and fill the notification message. This message appears in the resulting email notification telling users what has changed and why.
7. Click "Update facet values". The changes will patch links in the Publishing API and take effect as soon as they reach the content-store.

![content-tagger screenshot](images/tagging-content-with-facets.png)


### How to bulk tag business readiness content to facet values

1. SCP [the correct format CSV file](https://github.com/alphagov/govuk-app-deployment-secrets/blob/master/shared_config/business_readiness.csv) to a backend machine.
2. Run [this rake task](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-tagger&MACHINE_CLASS=backend&RAKE_TASK=facets:tag_content_to_facet_values[%22/tmp/business-readiness.csv%22,%22lib/data/find-eu-exit-guidance-business.yml%22]) *
