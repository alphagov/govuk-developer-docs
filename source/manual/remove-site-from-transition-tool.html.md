---
owner_slack: "#govuk-developers"
title: Remove a site from the Transition tool
parent: "/manual.html"
layout: manual_layout
section: Transition
---

Sometimes we get requests to delete sites from the [Transition tool](https://transition.publishing.service.gov.uk).

## 1. Remove site config YAML files

Sites that appear in the Transition tool are configured in YAML in the [alphagov/transition-config](https://github.com/alphagov/transition-config) repo. To remove one, `git rm` it from the `data/transition-sites` directory. There's [some prior art](https://github.com/alphagov/transition-config/pull/1306).

## 2. Run rake task

Once your changes have been merged, run the `import:revert:sites[site_abbr]` Rake on the Transition app with the site abbreviation that you want to delete. This task will only work for sites with zero mappings and zero hits - i.e. no associated data beyond that which was created by importing the site YAML file. It [triggers the `transition_load_site_config` Jenkins job](https://deploy.blue.production.govuk.digital/job/Transition_load_site_config/) to update the Transition tool's loaded site config.

To remove a redirect with existing mappings or hits, use the `import:revert_entirely_unsafe[site_abbr]` Rake task.

## 3. Check that the site is no longer recognised by the Transition tool

When all caches have cleared, the host will not appear in [hosts.json](https://transition.publishing.service.gov.uk/hosts).
