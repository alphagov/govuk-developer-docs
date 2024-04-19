---
owner_slack: "#govuk-ga4"
title: GA4 Implementation Record
section: Frontend
layout: manual_layout
type: learn
parent: "/manual.html"
related_repos: [govuk_publishing_components]
---

The GOV.UK [GA4 implementation record](/analytics) holds information about our Google Analytics 4 data schemas, as well as other related information about our GA4 implementation.

## Updating the record

The implementation record should be kept up to date with any changes made to the GA4 implementation. For changes to existing content this will be possible if:

- you have a locally running version of this site
- you understand how to edit YML files
- you have access to the git repository for this site and can push changes

For more complex changes such as adding a new page or changing how existing data is displayed, a developer may be required.

## How to make changes

Static page templates are stored in `/source/analytics`. They include pages like the [Documentation pages](/analytics/docs.html) and are written using standard HTML/CSS using styles from the [Design System](https://design-system.service.gov.uk/styles/).

Dynamic pages such as the [events](/analytics/events.html), [attributes](/analytics/attributes.html) and [trackers](/analytics/trackers.html) pages are generated automatically from the YAML files stored in [/data/analytics/](https://github.com/alphagov/govuk-developer-docs/tree/main/data/analytics).

When editing events and attributes please note the following.

- YML files rely on specific indenting, if the page breaks during editing check that you have indented the YML correctly
- new events require a `data` section, including the minimum attributes: `event` and `event_data`. `event_data` must contain `event_name`. See existing events for examples
- attributes added to events in [events.yml](https://github.com/alphagov/govuk-developer-docs/blob/main/data/analytics/events.yml) will only appear if a corresponding entry for the attribute is added to [attributes.yml](https://github.com/alphagov/govuk-developer-docs/blob/main/data/analytics/attributes.yml)
- new attributes should have the same detail provided as existing attributes, although the minimum requirement is a `name` and a `type`
- if no value is provided in `events.yml` for an attribute, the `type` of the attribute will be shown
- the values of `implemented` for events are used to calculate the details on the [implementation progress page](/analytics/progress.html)
