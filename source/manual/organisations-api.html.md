---
owner_slack: "#govuk-developers"
title: Organisations API
section: Infrastructure
layout: manual_layout
type: learn
parent: "/manual.html"
---

## Where the Organisations API lives

There is a read-only Organisations API that returns either a JSON list of organisations, or a single organisation by its slug.

- JSON list of organisations: <https://www.gov.uk/api/organisations>
- Example of an organisation by slug: <https://www.gov.uk/api/organisations/government-digital-service>

The `/api/organisations` route is [published as a special prefix route](https://github.com/alphagov/collections-publisher/commit/bf2bc4fcf2e69d9accbfefb40c7dccef803f4c4e) by Collections Publisher. The routes therefore don't exist in Publishing API or Content Store.

Requests to these routes are [handled by Collections](https://github.com/alphagov/collections/blob/816d1fb6de93ffac386636fb7b8d6e1608bcf763/config/routes.rb#L72-L81) (frontend). The [OrganisationsApiController](https://github.com/alphagov/collections/blob/f8573ec0e7c033d795c53bfdfd56296e28b136df/app/controllers/organisations_api_controller.rb#L4-L24) file [uses Search API to fetch the organisations](https://github.com/alphagov/collections/blob/f8573ec0e7c033d795c53bfdfd56296e28b136df/app/controllers/organisations_api_controller.rb#L56-L65) before returning the API response with the help of an [OrganisationsApiPresenter](https://github.com/alphagov/collections/blob/968fb89bfec0d8ee264329ecd50d3096ad2429bb/app/presenters/organisations_api_presenter.rb).

The Organisations API response is very similar to what one would get from querying Search API directly: <https://www.gov.uk/api/search.json?filter_format=organisation>.

### Not to be confused with the Organisations index and Content API

As an aside, Collections has two competing methods for retrieving organisations. As stated above, Search API powers the Organisations API response, but a different mechanism is used to power the user-facing organisations pages:

- List of organisations: <https://www.gov.uk/government/organisations>
- Example of an organisation homepage: <https://www.gov.uk/government/organisations/government-digital-service>

These user-facing pages are [also handled by Collections](https://github.com/alphagov/collections/blob/816d1fb6de93ffac386636fb7b8d6e1608bcf763/config/routes.rb#L36-L48), but [they use Content Store](https://github.com/alphagov/collections/blob/5d5382fd768ea8123ed13b548ca5acc3756bc62c/app/controllers/organisations_controller.rb#L8-L12) to retrieve the organisation info.

- Organisations index page content item: <https://www.gov.uk/api/content/government/organisations>
- Example of an organisation content item: <https://www.gov.uk/api/content/government/organisations/government-digital-service>

## Consuming the Organisations API

The API is surfaced through GDS API Adapters, returning either a [list of organisations](https://github.com/alphagov/gds-api-adapters/blob/f053a0783fd5aa54fad8be35c8bbb70bc22c6954/lib/gds_api/organisations.rb#L4-L6) or a [specific organisation by its slug](https://github.com/alphagov/gds-api-adapters/blob/f053a0783fd5aa54fad8be35c8bbb70bc22c6954/lib/gds_api/organisations.rb#L8-L10). The [base URL of the requests is the website root www.gov.uk](https://github.com/alphagov/gds-api-adapters/blob/697aa098054fbd9c3c07946c40f1c67aa871f3e3/lib/gds_api.rb#L141-L143), so we can easily query the API in the browser as described earlier. To be clear, this is hitting Collections under the hood.

[Several apps rely on the Organisations API](https://github.com/search?q=org%3Aalphagov%20GdsApi.organisations&type=code) (via GDS API Adapters). For example, [Signon fetches the organisations list](https://github.com/alphagov/signon/blob/43380578e39c75c019961d6a9469e841d8f53113/lib/organisations_fetcher.rb#L27) to ensure its own internal list of orgs is in sync.

## Populating the Organisations API

Organisations are created, edited and deleted in Whitehall, modelled as an [Organisation](https://github.com/alphagov/whitehall/blob/75efcb936f3b02a5923742fed15bb5cc4d995895/app/models/organisation.rb) that pulls in several key modules.

The [PublishesToPublishingApi](https://github.com/alphagov/whitehall/blob/7979f7712636774f1fcd74c81d8f48fbaa96b60a/lib/publishes_to_publishing_api.rb) module is responsible for giving each organisation a random content ID, and for publishing to Publishing API whenever a model is updated. The model defines [callbacks](https://github.com/alphagov/whitehall/blob/75efcb936f3b02a5923742fed15bb5cc4d995895/app/models/organisation.rb#L213-L215) for republishing the organisations index page (content item) whenever an org is updated or deleted. *These Publishing API interactions power the [user-facing organisation pages](#not-to-be-confused-with-the-organisations-index-and-content-api)* described earlier.

The [Searchable](https://github.com/alphagov/whitehall/blob/a67fae1b8a0963927f38ce9987b99059fa9fff92/app/models/concerns/searchable.rb) module defines the behaviour for indexing the organisation after save, and unindexing it after destroy. *This Search API interaction is ultimately what powers the Organisations API*. As an aside, Whitehall really [shouldn't be updating Search API directly](https://trello.com/c/vnrBGTvr/26-search-is-populated-by-whitehall-sending-data) - work is currently underway to attempt to remedy that.

Also worth noting that the [OrganisationSearchIndexConcern](https://github.com/alphagov/whitehall/blob/3a3d7d113706d5ce9ecf350c9670ca0961438de1/app/models/concerns/organisation/organisation_search_index_concern.rb) module ensures that the organisation's corporate information pages (such as 'About' - [example](https://www.gov.uk/government/organisations/government-digital-service/about)) are added to or removed from GOV.UK's search index.

## Related bugs and technical debt

- [Bug: Mismatch of organisations between Whitehall and Search API](https://trello.com/c/oPEsW9mH/)
- [Tech debt: Signon orgs aren't always synced quickly enough](https://trello.com/c/r3nUwq1Y/419-automate-syncing-organisations-into-signon)
- [Bug / Tech debt: Whitehall should filter out 'joining' organisations](https://trello.com/c/yd6YbPHX/612-dont-include-joining-organisations-in-the-works-with-count)
- [Tech debt: Whitehall having to manually republish organisation content items](https://trello.com/c/V2riPPGI/)
