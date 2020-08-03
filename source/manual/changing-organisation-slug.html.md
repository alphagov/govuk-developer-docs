---
owner_slack: "#govuk-developers"
title: Change an organisation's slug
parent: "/manual.html"
layout: manual_layout
section: Routing
---

> **Note**
>
> For Worldwide Organisations, only steps 1 and 5 below need to be performed.

The organisation slug is used as a foreign key for organisations across
multiple apps.

### 1. Change the organisation's slug in Whitehall

Run the appropriate rake task:

- [Organisation][organisation-rake-task]
- [Worldwide Organisation][worldwide-organisation-rake-task]

### 2. Update the organisation in transition/transition-config:

The [transition-config repo](https://github.com/alphagov/transition-config) may
contain slugs. Change any references to the old slug:

- [Search the codebase for the slug](https://github.com/alphagov/transition-config/search?utf8=%E2%9C%93&q=old-slug)
- Update the slugs
- Open a pull request, and get it reviewed and merged

Merging will trigger the changes to be imported automatically.

### 3. Update the organisation slug in Manuals Publisher

Find out if any manuals are published by this organisation, by running the
following in the Manuals Publisher Rails console:

```ruby
ManualRecord.where(organisation_slug: "old-slug").exists?
```

If there are, create a migration to update the slugs. Republish all affected
manuals after deploying your change.

### 4. Sync the organisations with Signon

[Signon][signon] assigns users to organisations. This is used by apps such as
Whitehall for authorisation.

To sync all organisations from Whitehall to Signon, run the Signon rake task
`rake organisations:fetch`. Users may have to log out and in again to pick up
permissions for the renamed organisation.

[signon]: https://signon.publishing.service.gov.uk/

### 5. Update any best bet searches in Search Admin

Search the best bets in [search-admin][search-admin] for references to the old
organisation name and update them.

[organisation-rake-task]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/122585/rebuild/parameterized
[worldwide-organisation-rake-task]: https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/122581/rebuild/parameterized
[search-admin]: https://search-admin.publishing.service.gov.uk/
