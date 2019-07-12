---
owner_slack: "#govuk-2ndline"
title: Remove redirected URLs from Transition
parent: "/manual.html"
layout: manual_layout
section: Transition
last_reviewed_on: 2019-07-11
review_in: 12 months
---

## 1. Remove YML files

[Example PR](https://github.com/alphagov/transition-config/pull/1306)

First remove the relevant yml files and get your PR merged.

## 2. Run rake task

Once your changes have been merged, run the following rake task with the abbr to be deleted:

```
import:revert:sites[spva]
```

This task will only work for sites with zero mappings and zero hits - ie no associated data beyond that which was created by importing the site YAML file. It will also trigger another task to load the config to Transition (Transition_load_site_config).

If you need to remove a redirect with mappings or hits you'll have to do it manually. Open a console in the Transition machine and run the following:

```
site = Site.find_by(abbr: abbr)
site.hosts.each(&:destroy)
site.destroy
```

Check [here](https://transition.publishing.service.gov.uk/organisations) if it worked. It may take up to an hour for cache to be cleared and you should see the following message when it does:

`This host is not configured in Transition`
