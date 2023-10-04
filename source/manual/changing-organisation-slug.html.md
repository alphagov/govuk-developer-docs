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

- [Organisation][organisation-rake-task]: `rake reslug:organisation['old-slug','new-slug']`
- [Worldwide Organisation][worldwide-organisation-rake-task]: `rake reslug:worldwide_organisation['old-slug','new-slug']`

Note: it's important that single-quotes are used in the tasks otherwise they will fail.

### 2. Update the organisation slug in Manuals Publisher

Find out if any manuals are published by this organisation, by running the
following in the Manuals Publisher Rails console:

```ruby
ManualRecord.where(organisation_slug: "old-slug").exists?
```

If there are, create a migration to update the slugs. Republish all affected
manuals after deploying your change.

### 3. Sync the organisations with Signon

[Signon][signon] assigns users to organisations. This is used by apps such as
Whitehall for authorisation.

To sync all organisations from Whitehall to Signon, run the Signon rake task
`rake organisations:fetch`. Users may have to log out and in again to pick up
permissions for the renamed organisation.

[signon]: https://signon.publishing.service.gov.uk/

### 4. Update any best bet searches in Search Admin

Search the best bets in [search-admin][search-admin] for references to the old
organisation name and update them.

[organisation-rake-task]: https://github.com/alphagov/whitehall/blob/900ab57004bb350eea409d06176e424bc9df0180/lib/tasks/reslugging.rake#L132
[worldwide-organisation-rake-task]: https://github.com/alphagov/whitehall/blob/900ab57004bb350eea409d06176e424bc9df0180/lib/tasks/reslugging.rake#L146
[search-admin]: https://search-admin.publishing.service.gov.uk/
