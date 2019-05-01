---
owner_slack: "#govuk-platform-health"
title: Publish changes to the business readiness finder
section: Business readiness finder
layout: manual_layout
parent: "/manual.html"
important: true
last_reviewed_on: 2019-05-01
review_in: 3 months
---

*If you are trying to update the content returned by the business readiness finder, see: [Update content for the business readiness finder](/manual/business-readiness-update-content.html)*

The full journey for the  [business readiness finder][business-readiness-finder] is made up of the following content items:

1. The start page: [`/business-uk-leaving-eu`](https://www.gov.uk/business-uk-leaving-eu)
2. The Q&A: [`/prepare-business-uk-leaving-eu`](https://www.gov.uk/prepare-business-uk-leaving-eu)
3. The finder: [`/find-eu-exit-guidance-business`](https://www.gov.uk/find-eu-exit-guidance-business)
4. The email signup page: [`/find-eu-exit-guidance-business/email-signup`](https://www.gov.uk/find-eu-exit-guidance-business/email-signup)

The content for the start page can be updated in Mainstream Publisher as you would any other start page.

The content item for the Q&A doesn't actually contain any details. The titles of the questions are defined in a YAML file in [finder frontend][finder-frontend]. However the body of the question, for example the options if the question is a checkbox, are read from the content item of the finder itself (content item 3 in the list). Finder frontend searches the content item for a facet "key" that matches the question, e.g. `sector_business_area` to find the question content.

The content item for the finder is updated from a [YAML file][search-api]. Any changes to this YAML file affect both the facets in the finder and the options in the Q&A.

## Updating question titles

1. Update the content of the YAML file in [finder frontend][finder-frontend]
2. Merge and deploy the changes

## Updating the business readiness finder

The content item for the business readiness finder and its email signup page are published by `search-api` and the config for the facet group is managed in [content-tagger][content-tagger].

1. Update the facet group in [content-tagger][content-tagger]
2. Merge the changes to [content-tagger][content-tagger]
3. Deploy content-tagger
4. [Import and Publish the facet group](/manual/publishing-a-facet-group.html#how-to-import-or-update-a-facet-group)
5. Update [search-api][search-api]
6. Merge the changes to [search-api][search-api]
7. Deploy search-api 
8. Run the [`publishing_api:publish_facet_group_eu_exit_business_finder` rake task][staging-rake-task-facet-group] in `search-api` to publish the changes:

    ![download](images/publish-business-readiness.png)

9. If you are making changes to the schema, you may also need to [reindex elasticsearch](/manual/reindex-elasticsearch.html).


[business-readiness-finder]: https://www.gov.uk/find-eu-exit-guidance-business
[content-tagger]: https://github.com/alphagov/content-tagger/blob/master/lib/data/find-eu-exit-guidance-business.yml
[finder-frontend]: https://github.com/alphagov/finder-frontend/blob/3d7f25ddca4bedd9d9fb750fb1d651964cf2a34b/lib/prepare_business_uk_leaving_eu.yaml
[search-api]: https://github.com/alphagov/search-api/blob/master/config/find-eu-exit-guidance-business.yml
[staging-rake-task-facet-group]:https://deploy.blue.staging.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=search-api&MACHINE_CLASS=search&RAKE_TASK=publishing_api:publish_facet_group_eu_exit_business_finder
