---
owner_slack: "#govuk-frontenders"
title: 'Google Tag Manager change process'
section: Frontend
layout: manual_layout
type: learn
parent: "/manual.html"
related_repos: [govuk_publishing_components]
---

GOV.UK has implemented Google Analytics 4 (GA4) using Google Tag Manager (GTM) to track user journeys through the site. This page describes the process of making changes to GTM to support improvements to our analytics.

## Concerns and responses

This process exists because some changes in GTM could increase the size of the JavaScript (JS) included in the public frontend of GOV.UK, negatively impacting performance.

To mitigate this concern a GTM blocklist has been implemented in our [GA4 code](https://github.com/alphagov/govuk_publishing_components/blob/main/app/assets/javascripts/govuk_publishing_components/analytics-ga4/ga4-core.js#L16), specifically preventing `customPixels`, `customScripts`, `html` and `nonGoogleScripts`, which are the most likely cause of JS size increase.

The size of the two scripts involved is also monitored by the [Public Asset Checker](https://govuk-public-asset-checker.herokuapp.com/), a tool built by the GA4 migration team. It monitors the size of [gtm.js](https://govuk-public-asset-checker.herokuapp.com/public_assets/1) and [gtag](https://govuk-public-asset-checker.herokuapp.com/public_assets/2). Daily output is posted to `#govuk-frontenders` including warnings of any significant size increase.

## Change process

Create a change in the GTM web interface.

- change is created in a new workspace
- change must include a clear description
- change can be checked in preview mode (optional)

The change must be checked by a second performance analyst.

Raise a request to have the change approved.

- can be raised in the `#govuk-ga4` slack channel
- include a link to the workspace to review
- must specify which environment to publish to

Change is reviewed.

- `modified` is a change to an existing thing
- `added` is a new thing
- specific changes are listed under `Version changes`
- `Activity history` shows previous changes
- ensure no custom HTML or JS included in tags

If the change is not rejected or returned for further discussion, it is approved and published.

- publish to the required environment - `Production`, `Staging` or `Integration`
- publishing defaults to the `Production` environment, if it needs to be deployed to a different environment that must be selected first
- publishing may involve more than one publishing act e.g. publish version 35 to `Production`, publish version 36 to `Integration`

Test that the change has been successful, in the following order.

- `Integration`: analyst checks that change has been implemented as per specifications
- `Staging`: for wider community/second analyst to check that the change fits the data requirement
- `Production`: analyst must check that change has gone live as expected
