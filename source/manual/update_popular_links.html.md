---
owner_slack: "#govuk-2ndline-tech"
title: Update popular links
section: 2nd line
layout: manual_layout
parent: "/manual.html"
---

Popular links on GOV.UK are shown in two places on the home page and in the search bar.

![Image of the popular links on the GOV.UK homepage](images/popular-links-on-homepage.jpeg)

![Image of the popular links in the search drop down](images/popular-links-in-search-dropdown.jpeg)

## Updating the popular links on the homepage

Popular links can be found in [config/locales/en.yml on frontend](https://github.com/alphagov/frontend/blob/80ec5cb2840086e7f073ceeba89d5c07d581a02d/config/locales/en.yml#L363-L373)

[Example PR](https://github.com/alphagov/frontend/pull/3155)

## Updating the popular links in the search drop down

These links are set in the [GOV.UK publishing components](https://github.com/alphagov/govuk_publishing_components/blob/d05b3369b7426e32ad49b5898096b9752df7e410/config/locales/en.yml#L179-L189)

[Example PR](https://github.com/alphagov/govuk_publishing_components/pull/2660)

The GOV.UK publishing components gem will then need to be released, and [static](https://github.com/alphagov/static) will have to be updated to use the latest GOV.UK publishing components gem for these changes to take effect.
