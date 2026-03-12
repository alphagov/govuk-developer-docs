---
owner_slack: "#govuk-developers"
title: Change an organisation's slug
parent: "/manual.html"
layout: manual_layout
section: Routing
---

The organisation slug is used as a foreign key for organisations across
multiple apps.

### 1. Change the organisation's slug in Whitehall

Run the rake task:

```
rake reslug:organisation['old-slug','new-slug']
```

Note: it's important that single-quotes are used otherwise they will fail.

### 2. Update the organisation slug in Manuals Publisher

Run the following rake task in Manuals Publisher:

```
rake reslug_organisation[old_slug,new_slug]
```

### 3. Sync the organisations with Signon

[Signon][signon] assigns users to organisations. This is used by apps such as
Whitehall for authorisation.

To sync all organisations from Whitehall to Signon, run the Signon rake task
`rake organisations:fetch`. Users may have to log out and in again to pick up
permissions for the renamed organisation.

[signon]: https://signon.publishing.service.gov.uk/

### 4. Update any best bet searches in Search Admin

Check the [best_bets.yml file in search-api-v2][search-api-v2] for any references to the old organisation name, and update them if so.

Note: as of July 2024, the YAML file above is the only way to configure 'best bets', but the search team are working on building a feature in [search-admin][search-admin], which may replace the above instructions.

[search-admin]: https://search-admin.publishing.service.gov.uk/
[search-api-v2]: https://github.com/alphagov/search-api-v2/blob/main/config/best_bets.yml
