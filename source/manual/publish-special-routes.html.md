---
owner_slack: "#govuk-whitehall-experience-tech"
title: Publish special routes
section: Deployment
layout: manual_layout
parent: "/manual.html"
old_paths:
 - /manual/publish_special_routes.html
---

[Publishing API](https://github.com/alphagov/publishing-api) has a set of rake tasks for loading routes (a map of URL path to a rendering app and content ID) from a YAML file into Publishing API.

See [Publishing special routes](https://github.com/alphagov/publishing-api/blob/main/docs/admin-tasks.md#publishing-special-routes) for usage.

Note that, by default, special routes won't appear in GOV.UK search. There is an [override list in search-api-v2](https://github.com/alphagov/search-api-v2/blob/main/config/document_type_ignorelist_path_overrides.yml) where you can opt specific special routes into being indexed.
