---
owner_slack: "#2ndline"
title: Change an organisation's slug
parent: "/manual.html"
layout: manual_layout
section: Routing
last_reviewed_on: 2017-10-11
review_in: 6 months
---

> **NOTE:** for Worldwide Organisations, only Steps 1 and maybe 4 below need to
> be performed.

The organisation slug is used as a foreign key for organisations across
lots of apps. Changing it can be complex and time consuming.

### 1)  Change the organisation's slug in Whitehall

Create a data migration that uses the `DataHygiene::OrganisationReslugger` class, see [this PR for an example](https://github.com/alphagov/whitehall/pull/2245).

### 2)  Update the organisation in Transition/transition-config:

The [transition-config repo](https://github.com/alphagov/transition-config) may contain slugs. Change any references to the old slug:

- [search the codebase for the slug](https://github.com/alphagov/transition-config/search?utf8=%E2%9C%93&q=old-slug)
- update the slugs
- open a pull request, get it merged
- merging will trigger the changes to be imported

### 3) Update the organisation slug in Manuals Publisher

Repo: <https://github.com/alphagov/manuals-publisher>

Find out if any manuals are published by this organisation.

Run the following in manuals-publisher Rails console:

```ruby
ManualRecord.where(organisation_slug: "old-slug").exists?
```

If there are, create a migration to update the slugs. Republish all affected
manuals after deploying your change.

### 4) Update any best-bet searches in Search Admin

<https://search-admin.publishing.service.gov.uk/>
