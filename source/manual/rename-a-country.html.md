---
owner_slack: "#govuk-developers"
title: Rename a country
parent: "/manual.html"
layout: manual_layout
section: Publishing
last_reviewed_on: 2020-02-10
review_in: 6 months
related_applications: [travel-advice-publisher, content-tagger, whitehall]
---
> **Note**
>
> We recommend you test out these instructions in integration and then staging before using them in production.

Renaming a country affects these pages:

* https://www.gov.uk/foreign-travel-advice/`<country_slug>`
* https://www.gov.uk/world/`<country_slug>`
* https://www.gov.uk/world/`<country_slug>`/news
* https://www.gov.uk/foreign-travel-advice/`<country_slug>`/email-signup/
* https://www.gov.uk/email/subscriptions/new?topic_id=`<country_slug>`


### 1. Update Travel Advice publisher

**Example pull request:** [https://github.com/alphagov/travel-advice-publisher/pull/539/files](https://github.com/alphagov/travel-advice-publisher/pull/539/files)

This will update www.gov.uk/foreign-travel-advice/`<country_slug>` to www.gov.uk/foreign-travel-advice/`<new_country_slug>`.

In [Travel Advice Publisher](https://github.com/alphagov/travel-advice-publisher):

1. Create a [pull request](https://github.com/alphagov/travel-advice-publisher/pull/539/files) with:
    * A migration to update the relevant `country_slug` of TravelAdviceEdition. [Example](https://github.com/alphagov/travel-advice-publisher/pull/539/files#diff-dafdd21fd31a2f3a5d3eac5e2bdaeb08)
    * A change of the relevant name and slug in the `lib/data/countries.yml` file. Keep `content_id` and `email_signup_content_id` the same, and ensure the alphabetical order of the list is respected. [Example](https://github.com/alphagov/travel-advice-publisher/pull/539/files#diff-e7c0733c6cf5a1d6fc1f2589a6d9f0f7)

2. Deploy Travel Advice publisher
    * Once the above pull requests are ready, [deploy](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/parambuild/?TARGET_APPLICATION=travel-advice-publisher&DEPLOY_TASK=deploy) Travel Advice Publisher
    * Then follow with another [deploy with app:migrate_and_hard_restart](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/parambuild/?TARGET_APPLICATION=travel-advice-publisher&DEPLOY_TASK=app:migrate_and_hard_restart), as a hard restart is required to update the `.yml` file.
    * You will see the country has updated in the list in [Travel Advice Publisher](https://travel-advice-publisher.integration.publishing.service.gov.uk/admin)

3. Run rake tasks
    * Run [publishing_api:republish_edition[<new_country_slug>]](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish_edition[<new_country_slug>]) to update the PublishingApi.
    * Run [publishing_api:republish_email_signups:country_edition[<country-slug>]](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=travel-advice-publisher&MACHINE_CLASS=backend&RAKE_TASK=publishing_api:republish_email_signups:country_edition[<country-slug>]) to update email subscriptions at `/foreign-travel-advice/<country_slug>/email-signup`

4. Update the search metadata
    * In the [UI](https://travel-advice-publisher.integration.publishing.service.gov.uk/admin), go to the country and create a new edition
    * Tick the "minor update" checkbox and update the `Search title` and `Search description` fields with the updated country name.
    * Save and publish.

### 2. Update Worldwide Taxons

**Example pull request:** [https://github.com/alphagov/search-api/pull/1436](https://github.com/alphagov/search-api/pull/1436)

This will update `www.gov.uk/world/<country_slug>` to `www.gov.uk/world/<new_country_slug>`.

In [Search API](https://github.com/alphagov/search-api):

1. Create a [pull request](https://github.com/alphagov/search-api/pull/1436) with a change to the relevant country taxon in `config/govuk_index/migrated_formats.yaml`
2. Deploy Search API

In [Content Tagger](https://content-tagger.integration.publishing.service.gov.uk/):

1. View the taxon from the list
2. Under `Tasks` go to `Edit taxon`, and update the `base path`, `internal taxon name`, `external taxon name` and any others with the new country name
3. Save the draft and publish.

The old slug might still appear as a duplicate in our internal GOV.UK search,

> **Note**
>
> Updating the child taxons linked to the country taxon ("UK help and services in country") will be a content task.

### 3. Update Whitehall

**Example pull request:** [https://github.com/alphagov/whitehall/pull/4643](https://github.com/alphagov/whitehall/pull/4643)

This will update `www.gov.uk/world/<country_slug>/news`.

In [Whitehall](https://github.com/alphagov/whitehall):

1. Create a [data migration](https://github.com/alphagov/whitehall/pull/4643/files) to update the `slug` and `name` fields of the `WorldLocation` table.
2. Deploy the pull request
  * After deploying, run the [Whitehall data migrations](https://deploy.integration.publishing.service.gov.uk/job/Run_Whitehall_Data_Migrations/) job
3. Update World Location News
  * Go to the relevant country in [World Location News](https://whitehall-admin.integration.publishing.service.gov.uk/government/admin/world_locations). In the "Details" tab, edit the `Title`, `Mission statement` and relevant `Featured links`.

### 4. Update Smart-answers

**Example pull request:** [https://github.com/alphagov/smart-answers/pull/3899/](https://github.com/alphagov/smart-answers/pull/3899/)

> **Note**
>
> `smart-answers` validates country names against the production worldwide API, which is managed by `whitehall`.  So do this *after* deploying the Whitehall change.

This will update content from pages served by `smart-answers` such as:

- https://www.gov.uk/marriage-abroad
- https://www.gov.uk/check-uk-visa
- https://www.gov.uk/register-a-death/y/overseas

In [Smart-answers](https://github.com/alphagov/smart-answers):

1. Create a [pull request](https://github.com/alphagov/smart-answers/pull/3899/) that replaces all instances of `country_name` with `new_country_name`.

2. Check changes are reflected in the affected smart answers

3. Deploy the pull request

### 5. Update Email-alert-api

The country's subscription list(s) `title` and `slug` needs to be updated, such as:

- "Publications related to `<country_name>`"
- "`<country_name>` - travel advice"
- "`<country_name>`"

1. Run the rake task [manage:find_subscriber_list_by_title[title]](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=manage:find_subscriber_list_by_title[country_name])
  with the country name to see which subscription lists need to be updated
2. Run the rake task [manage:update_subscriber_list[slug,new_title,new_slug]](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=manage:update_subscriber_list[country_slug,new_title,new_country_slug])
  to update the subscription lists

  > **Note**
  >
  > You can test the emails are being sent out correctly in `integration` and `staging`
    by following [Receive emails from Email Alert API in integration and staging](https://docs.publishing.service.gov.uk/manual/receiving-emails-from-email-alert-api-in-integration-and-staging.html)

### 6. Remove duplicate search results

In [Whitehall](https://github.com/alphagov/whitehall) run `SearchIndexDeleteWorker.perform_async(instance.search_index['slug'], instance.rummager_index)`

Failing this, there is a [rake task](https://github.com/alphagov/search-api/blob/4f106e40f2c1690d631f699bf8fc63dc39268866/lib/tasks/delete.rake#L9) that takes care of this.
