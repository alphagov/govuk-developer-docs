---
owner_slack: "#2ndline"
title: Change an organisation's slug
parent: "/manual.html"
layout: manual_layout
section: Routing
last_reviewed_on: 2017-05-01
review_in: 6 months
---

> **NOTE:** for Worldwide Organisations, only Steps 1, 6 and maybe 7 below need
> to be performed.

The organisation slug is used as a foreign key for organisations across
lots of apps. Changing it can be complex and time consuming.

### 1)  Change the organisation's slug in Whitehall

Create a data migration that uses the `DataHygiene::OrganisationReslugger` class, see [this PR for an example](https://github.com/alphagov/whitehall/pull/2245).

### 2) Update the organisation in the Need API:

-   Pull the new organisation slug from Whitehall using the `organisations:import` rake task.
-   In the Rails console, update all needs with the new organisation:

  ```rb
  Need.where(organisation_ids: old_slug).each { |n| n.organisation_ids = (n.organisation_ids - [old_slug] + [new_slug]); n.save! }
  ```
-   Use `Organisation.find(old_slug).destroy` to delete the old
    organisation.
-   Re-index the needs in search via the `search:index_needs`
    rake task.

### 3)  Clear the organisation cache in Maslow:

Restart the workers using Fabric:

```
fab $environment class:backend sdo:'service maslow reload'
```

### 4)  Update the organisation in Transition/transition-config:

The [transition-config repo](https://github.com/alphagov/transition-config) may contain slugs. Change any references to the old slug:

- [search the codebase for the slug](https://github.com/alphagov/transition-config/search?utf8=%E2%9C%93&q=old-slug)
- update the slugs
- open a pull request, get it merged
- merging will trigger the changes to be imported

### 5) Update the organisation slug in Manuals Publisher

Repo: <https://github.com/alphagov/manuals-publisher>

Find out if any manuals are published by this organisation.

Run the following in manuals-publisher Rails console:

```ruby
ManualRecord.exists?(conditions: { organisation_slug: "old-slug" })
```

If there are, create a migration to update the slugs. Republish all affected
manuals after deploying your change.

### 6) Update the organisation slug in the GOV.UK Delivery database

Repo: <https://github.com/alphagov/govuk-delivery>

Find the original slug in the MongoDB database for GOV.UK
Delivery by running the following in a MongoDB console:

```js
use govuk_delivery
db.topics.find({_id: {$regex: new RegExp("old-slug") }})
```

Then update the topics by inserting the new record and deleting the old one.
(An update isn't possible because MongoDB doesn't allow updating IDs):

```js
db.topics.find({_id: {$regex: new RegExp("old-slug") }}).forEach(function(doc) {
  var old_id = doc._id;
  doc._id = doc._id.replace(/old-slug/g, "new-slug");
  db.topics.insert(doc);
  db.topics.remove({ _id: old_id });
});
```

### 7) Update any best-bet searches in Search Admin

<https://search-admin.publishing.service.gov.uk/>
