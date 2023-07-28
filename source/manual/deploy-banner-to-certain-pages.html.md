---
owner_slack: "#govuk-2ndline-tech"
title: Deploy a banner to certain pages
parent: "/manual.html"
layout: manual_layout
section: Frontend
---

This documentation should be used when we receive a request to publish a banner
to a single, or group of pages. If you want to publish a sitewide banner then
reference [deploy emergency banner][emergency-banner] or [deploy non-emergency
banner][non-emergency-banner].

We can publish a few different banner types, depending on the ask. For example,
we've previously published a [notice banner][notice-banner] for a
mini-reshuffle and an [intervention banner][intervention-banner] for a research
panel.

The [component guide][component-guide] has a list of GOV.UK components which
includes banners like [notice][notice] and [intervention][intervention] and
their variants, e.g [notice with markup in title][notice-markup].

## Prerequisites

* banner text

* banner location on page/s

## Steps

1. Find the rendering app of the chosen pages (visit `https://gov.uk/api/content/<base-path>` and look for `rendering_app`)
1. Create a branch introducing the component in the relevant view and with a helper method that only displays the banner for certain base_paths (e.g [org pages in Collections][notice-banner]).
1. Preview the banner locally (e.g using docker [collections-app-live][collections-live], or deploy a branch to integration)
1. Check the positioning of the banner and adjust accordingly. See [an example][notice-margin] of adjusting the margin of the notice banner.

Once your changes are merged, you should also [write a technical debt
card][tech-debt-board] for the banner you've added, as this is a non-standard
piece of technical work that has been essentially 'hacked in' due to
limitations in our current platform.

[collections-live]: https://github.com/alphagov/govuk-docker/blob/main/projects/collections/docker-compose.yml#L41
[component-guide]: https://components.publishing.service.gov.uk/component-guide/intervention
[emergency-banner]: /manual/emergency-publishing.html
[intervention]: https://components.publishing.service.gov.uk/component-guide/intervention
[intervention-banner]: https://github.com/alphagov/collections/pull/3046
[non-emergency-banner]: /manual/global-banner.html
[notice]: https://components.publishing.service.gov.uk/component-guide/notice
[notice-banner]: https://github.com/alphagov/collections/pull/3172/files
[notice-margin]: https://github.com/alphagov/government-frontend/blob/8e8b10768c360c3c10b2f013086de2455e155040/app/views/content_items/corporate_information_page.html.erb#L8-L12
[notice-markup]: https://components.publishing.service.gov.uk/component-guide/notice/with_markup_in_the_title
[tech-debt-board]: https://trello.com/b/oPnw6v3r/govuk-tech-debt
