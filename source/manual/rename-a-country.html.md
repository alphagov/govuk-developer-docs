---
title: Rename a country
parent: "/manual.html"
layout: manual_layout
section: Publishing
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2019-06-19
review_in: 6 months
related_applications: [travel-advice-publisher, content-tagger, whitehall]
---
> **Note**
>
> We recommend you test out these instructions in integration and then staging before using them in production.

### 1. Update Foreign Travel Advice publisher

**Example PR:** [https://github.com/alphagov/travel-advice-publisher/pull/381](https://github.com/alphagov/travel-advice-publisher/pull/381)

This will update www.gov.uk/foreign-travel-advice/`<country_slug>`.

In [Travel Advice Publisher](https://github.com/alphagov/travel-advice-publisher):

1. Create a pull request with:
    * A migration to update the relevant `country_slug` of TravelAdviceEdition. [Example](https://github.com/alphagov/travel-advice-publisher/pull/346/commits/b28ff7b4eae96543324f61be700dca32f1ffdba5)
    * A change of the relevant name and slug in the `lib/data/countries.yml` file. Keep the same `content_id` and `email_signup_content_id`, and ensure the alphabetical order of the list is respected. [Example](https://github.com/alphagov/travel-advice-publisher/pull/346/commits/3eb10a8519638850760698992dd1f6467b041ab0)

2. Deploy Travel Advice publisher
    * Once the above PRs are ready, deploy Travel Advice Publisher. Perform a `deploy` and then an `app:migrate_and_hard_restart`, as a hard restart is required to update the `.yml` file.

3. Run rake tasks
    * Run [publishing_api:republish_edition[new_country_slug]](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish_edition[new_country_slug]) to update the PublishingApi.
    * Run [publishing_api:republish_email_signups:editions](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish_email_signups:editions) to update email subscriptions.

4. Update the search metadata
    * In the [UI](https://travel-advice-publisher.integration.publishing.service.gov.uk/admin), go to the country and create a new edition
    * Tick the "minor update" checkbox and update the `Search title` and `Search description` fields to ensure search results have the updated name.
    * Save and publish.

### 2. Update Worldwide Taxons

**Example PR:** [https://github.com/alphagov/rummager/pull/1265](https://github.com/alphagov/rummager/pull/1265)

This will update /world/countryname.

Rename the taxon in the [Rummager index list](https://github.com/alphagov/rummager/blob/master/config/govuk_index/migrated_formats.yaml#L51-L277).

Once the Rummager change is deployed, open the relevant country in [Content Tagger](https://content-tagger.integration.publishing.service.gov.uk/), tick "minor update" and update all the relevant fields with the new country name. Save the draft and publish.

> **Note**
>
> Updating the child taxons linked to the country taxon ("UK help and services in country") will be a content task.

### 3. Update Whitehall

**Example PR:** [https://github.com/alphagov/whitehall/pull/4245](https://github.com/alphagov/whitehall/pull/4245) and [https://github.com/alphagov/whitehall/pull/4259](https://github.com/alphagov/whitehall/pull/4259)

This will update /world/countryname/news. In [Whitehall](https://github.com/alphagov/whitehall):

1. Data migration
    * Create a data migration to update the `slug` and `name` fields of the WorldLocation table.
    * Create a data migration to redirect the old slug.
    * Deploy the data migrations

2. Update in the UI
Go to the relevant country in [World Location News](https://whitehall-admin.integration.publishing.service.gov.uk/government/admin/world_locations) and in the "Details" tab edit the Title, Mission statement and relevant Featured links.

### 4. Update Smart-answers

**Example PR:** [https://github.com/alphagov/smart-answers/pull/3619](https://github.com/alphagov/smart-answers/pull/3619)

smart-answers validates country names against the production worldwide API, which is managed by whitehall.  So do this after deploying the whitehall change.

This will update content from pages served by smart-answers such as marriage-abroad/y/countryname.

In [Smart-answers](https://github.com/alphagov/smart-answers):

1. Find and replace (case sensitive) `old_country_name` with `new_country_name`, then `Old_country_name` with `New_country_name`.

2. Run `bundle exec rake checksums:update`

3. Open and deploy a PR with these changes
