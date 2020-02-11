---
owner_slack: "#govuk-developers"
title: Remove redirected URLs from Transition
parent: "/manual.html"
layout: manual_layout
section: Transition
last_reviewed_on: 2019-07-29
review_in: 12 months
---

## 1. Remove YML files

[Example PR](https://github.com/alphagov/transition-config/pull/1306)

First remove the relevant YAML files and get your PR merged.

## 2. Run rake task

Once your changes have been merged, run the following rake task with the abbr to be deleted:

```rake
import:revert:sites[site_abbr]
```

This task will only work for sites with zero mappings and zero hits - i.e. no associated data beyond that which was created by importing the site YAML file. It will also trigger another task to load the config to Transition (Transition_load_site_config).

If you need to remove a redirect with mappings or hits you can run the following Rake task:

```rake
import:revert_entirely_unsafe[site_abbr]
```

Check [here](https://transition.publishing.service.gov.uk/organisations) if it worked. It may take up to an hour for cache to be cleared and you should see the following message when it does:

`This host is not configured in Transition`
