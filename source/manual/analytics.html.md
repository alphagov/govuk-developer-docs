---
owner_slack: "#govuk-frontenders"
title: 'Analytics on GOV.UK'
section: Frontend
layout: manual_layout
type: learn
parent: "/manual.html"
related_repos: [govuk_publishing_components]
---

GOV.UK uses Google Analytics 4 (GA4) to track user journeys through the site. The tracking data is available to anyone with Google Analytics Suite access for GOV.UK. You can request access to this by following the [steps in the GDS wiki](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/professions-in-gds/communities-of-practice/data-analysis/tools-technical/access-to-google-analytics).

## GOV.UK analytics code

The GOV.UK analytics codebase is a collection of JavaScript modules spread through a few different projects:

- the core analytics code is in [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components/blob/main/docs/analytics-ga4/analytics.md)
- applications may have their own specific tracking included, for example `finder-frontend` includes specific tracking JavaScript for search pages

## Tracking overview

The structure of the data sent to GA4 is recorded in our [implementation record](/analytics/).

User behaviours and journeys can be tracked in a variety of ways. The default method of tracking is to record _pageviews_ - data relating to a page the user has just requested (eg. URL, user-agent, referrer). Pageviews are typically recorded as the user visits the page.

Where a page offers the user navigation or interaction choices it is often desirable to track _events_, such as when an accordion section is expanded.

## Developing and debugging Google Analytics tracking

Read our [developer guide](https://github.com/alphagov/govuk_publishing_components/blob/main/docs/analytics-ga4/developer-guide.md) to GA4 developing.

Browser extensions such as [Omnibug](https://chromewebstore.google.com/detail/omnibug/bknpehncffejahipecakbfkomebjmokl) and [Analytics Debugger](https://chromewebstore.google.com/detail/analytics-debugger/ilnpmccnfdjdjjikgkefkcegefikecdc) show data being sent to Google Analytics. This is useful for testing what is being sent to GA and when. Other GA debuggers are also available.

## GA4 and publishing applications

Some publishing applications use the GA4 code from `govuk_publishing_components` to provide GA4 tracking in their systems, however some publishing applications have their own approach.

- [Content Publisher analytics](https://github.com/alphagov/content-publisher/blob/main/docs/approach-to-analytics.md)
- [Content Data Admin analytics code](https://github.com/alphagov/content-data-admin/blob/main/app/assets/javascripts/core/gtm.js)
