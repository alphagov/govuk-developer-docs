---
owner_slack: "#govuk-2ndline-tech"
title: Remove invalid WorldwideOrganisation draft CorporateInformationPages
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

A CorporateInformationPage is a Whitehall document that is attached to Organisation and WorldwideOrganisation models. For Organisations, it is accessed as the organisations `/about` page.

For WorldwideOrganisations, this document is presented directly on the organisation's home page.
As there is not a distinct page to visit directly, Whitehall can send a CorporateInformationPage to the Publishing API with the same base_path as the associated WorldwideOrganisation.

This can cause invalid drafts to be present in Publishing API, and may throw:

`GdsApi::HTTPUnprocessableEntity (Admin::WorldwideOfficesController)`

Whilst these invalid drafts are present users are unable to make any further edits.

A rake task exists in Publishing API that will clear the invalid drafts.

```bash
$ bundle exec rake 'data_hygiene:remove_invalid_worldorg_drafts'
```
