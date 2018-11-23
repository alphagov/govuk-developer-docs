---
owner_slack: "#govuk-platform-health"
title: data.gov.uk Hacks
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-11-14
review_in: 8 weeks
---
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[data-gov-uk-support]: manual/data-gov-uk-supporting-ckan

## Editing Users for a Publisher

It's become difficult to access the CKAN version of the management page for a publisher. To work around this:

  1. Login as the 2ndline user (password in [govuk-secrets])
  2. Go to https://data.gov.uk/data/report/publisher-resources/cabinet-office
  3. Use the select box to find the publisher
  4. Path becomes e.g. `/data/report/publisher-resources/cambridge-city-council`
  5. Replace `/data/report/publisher-resources/' with `/publisher/`
  6. Click the 'Edit user permissions' link on the right
  7. Use the autocomplete to find the user to add (or make any other changes)

## Resurrecting Deleted Users

Previously deleted users seem to be able to recreate their account, but CKAN still thinks they're deleted. Fix:

```
co@prod3 ~ () $

psql ckan

select * from "user" where email='...';
update "user" set state='active' where email='...';
```

See [data-gov-uk-support] for details about how to login to the prod machine, which is a mandatory pairing zone.
