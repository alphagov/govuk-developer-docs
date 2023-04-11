---
owner_slack: "#govuk-publishing-experience-tech"
title: Rename a country
parent: "/manual.html"
layout: manual_layout
section: Publishing
related_repos: [travel-advice-publisher, content-tagger, whitehall]
---
> **Note**
>
> We recommend you test out these instructions in integration and then staging before using them in production.

Renaming a country affects these pages:

* https://www.gov.uk/export-health-certificates (country filter)
* https://www.gov.uk/international-development-funding (country filter)
* https://www.gov.uk/foreign-travel-advice/`<country_slug>`
* https://www.gov.uk/world/`<country_slug>`
* https://www.gov.uk/world/`<country_slug>`/news
* https://www.gov.uk/foreign-travel-advice/`<country_slug>`/email-signup/
* https://www.gov.uk/email/subscriptions/new?topic_id=`<country_slug>`

### 1. Update Travel Advice Publisher

This will update www.gov.uk/foreign-travel-advice/`<country_slug>` to www.gov.uk/foreign-travel-advice/`<new_country_slug>`.

1. Change the relevant name and slug in the `lib/data/countries.yml` file. Keep `content_id` and `email_signup_content_id` the same, and ensure the alphabetical order of the list is respected. [Example](https://github.com/alphagov/travel-advice-publisher/pull/539/files#diff-e7c0733c6cf5a1d6fc1f2589a6d9f0f7)

2. Deploy Travel Advice Publisher
   * Once the above pull request is ready, [deploy](https://deploy.integration.publishing.service.gov.uk/job/Deploy_App/parambuild/?TARGET_APPLICATION=travel-advice-publisher&DEPLOY_TASK=deploy:with_hard_restart) Travel Advice Publisher with a hard restart to update the countries YAML file.
   * You will see the country has updated in the list in [Travel Advice Publisher](https://travel-advice-publisher.integration.publishing.service.gov.uk/admin)

3. Run Rake tasks
   * Run `country:rename[old_country_slug,new_country_slug]` to update the `TravelAdviceEdition`s.
   * Run `publishing_api:republish_edition[new_country_slug]` to update the Publishing API.
   * Run `publishing_api:republish_email_signups:country_edition[country-slug]` to update email subscriptions at `/foreign-travel-advice/<country_slug>/email-signup`

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

2. Deploy the changes

3. Run the `db:data:migrate` rake task in Whitehall

4. Update World Location News
   * Go to the relevant country in [World Location News](https://whitehall-admin.integration.publishing.service.gov.uk/government/admin/world_locations). In the "Details" tab, edit the `Title`, `Mission statement` and relevant `Featured links`.

### 4. Update Smart-answers

**Example pull request:** [https://github.com/alphagov/smart-answers/pull/3899/](https://github.com/alphagov/smart-answers/pull/3899/)

> **Note**
>
> `smart-answers` validates country names against the production worldwide API, which is managed by `whitehall`.  So do this *after* deploying the Whitehall change.

This will update content from pages served by `smart-answers` such as:

* <https://www.gov.uk/marriage-abroad>
* <https://www.gov.uk/check-uk-visa>
* <https://www.gov.uk/register-a-death/y/overseas>

In [Smart-answers](https://github.com/alphagov/smart-answers):

1. Create a [pull request](https://github.com/alphagov/smart-answers/pull/3899/) that replaces all instances of `country_name` with `new_country_name`.

2. Check changes are reflected in the affected smart answers

3. Deploy the pull request

### 5. Update Email Alert API

The country may have associated subscriber lists, such as:

* "Publications related to `<country_name>`"
* "`<country_name>` - travel advice"
* "`<country_name>`"

The titles of these lists will update automatically the next time a user tries to subscribe. You can force this to happen sooner by pretending to subscribe yourself (just to the point where you select a frequency).

Each subscriber list also has a "slug", which appears in the query params of the last few pages of the signup journey (selecting a frequency and entering an email). You can reset the slug manually as follows:

**WARNING: the slug is used as an ID for the last few pages of the signup journey (e.g. [here](https://github.com/alphagov/email-alert-frontend/blob/784009bfff734003e028e1c0ab36b61d1775a45f/app/controllers/content_item_signups_controller.rb#L33)). When you change the slug, any users currently trying to sign up on the pages will receive a 404.**

1. Run the rake task `data_migration:find_subscriber_list_by_title[title]`
  with the country name to see which subscription lists need to be updated
2. Run the rake task `data_migration:update_subscriber_list_slug[slug,new_slug]`
  to update the subscription lists

### 6. Remove duplicate search results

In [Whitehall](https://github.com/alphagov/whitehall) run `SearchIndexDeleteWorker.perform_async(instance.search_index['slug'], instance.rummager_index)`

Failing this, there is a [rake task](https://github.com/alphagov/search-api/blob/4f106e40f2c1690d631f699bf8fc63dc39268866/lib/tasks/delete.rake#L9) that takes care of this.

### 7. Update Specialist Publisher

1. Create and deploy pull requests for schemas in publishing api  ([example](https://github.com/alphagov/govuk-content-schemas/pull/1014)) and Specialist Publisher ([example](https://github.com/alphagov/specialist-publisher/pull/1722/commits/79c10d173f8294fef25b07678a7e74213e78e424)) to support both countries temporarily (during the data migration). Note that the schema example PR given here is for the archived govuk-content-schemas repo - please update with a publishing api PR when this is available.

2. Run the rake task `publishing_api:publish_finder[finder]` to republish the updated finders:
   * `export_health_certificates`
   * `international_development_funds`

3. Run the rake task `rename_country:all[country_slug,new_country_slug]` to republish all the relevant documents.

4. Check the country filter options have updated and documents appear with the new country filter set. This could take a few minutes due to the time it takes to republish the finder and all its associated documents.
   * [Export Health Certificates](https://www-origin.integration.publishing.service.gov.uk/export-health-certificates?cachebust=123).
   * [International Development Funds](https://www-origin.integration.publishing.service.gov.uk/international-development-funding?cachebust=123).

5. Create and deploy another pull request for content schemas in publishing api ([example](https://github.com/alphagov/govuk-content-schemas/pull/1015)) and Specialist Publisher ([example](https://github.com/alphagov/specialist-publisher/pull/1724)) to remove support for the old country. Note that the schema example PR given here is for the archived govuk-content-schemas repo - please update with a publishing api PR when this is available.

6. Re-publish the finders again, as above.

7. Run the rake task `data_migration:update_subscriber_list_tag[field,country_slug,new_country_slug]` to update the matching criteria for any subscriber lists in Email Alert API with keys of:
   * `location`
   * `destination_country`
