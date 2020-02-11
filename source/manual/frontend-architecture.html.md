---
owner_slack: "#govuk-frontenders"
title: Frontend architecture
parent: "/manual.html"
layout: manual_layout
type: learn
section: Frontend
last_reviewed_on: 2020-01-17
review_in: 3 months
related_applications:
 - static
 - slimmer
 - govuk_publishing_components
---

GOV.UK currently uses multiple systems to build frontends (HTML/CSS/JS).

## Current state

![Current state of libraries](https://docs.google.com/drawings/d/e/2PACX-1vQX7w1JT5zboAhKv2jssLPrO39KiWj4SL3T7MfSdigGlS1bjGR6UT_AqKHBKbif0VuRivIPD70WfpCQ/pub?w=1208&amp;h=470)

_[Source](https://docs.google.com/drawings/d/1L7pqFrHB2IQCnr0w3ticqBuR4U12b8psZQanZTvF098/edit)_

Applications that serve pages for the public (everything on www.gov.uk) use:

- [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components), the preferred way to share HTML, CSS and JS
- [Static](https://github.com/alphagov/static) and [Slimmer](https://github.com/alphagov/slimmer) for layouts
- Static uses [govuk_frontend_toolkit](https://github.com/alphagov/govuk_frontend_toolkit) and [govuk_template](https://github.com/alphagov/govuk_template), two deprecated projects built by GDS (not GOV.UK)
- [Calculators](https://github.com/alphagov/calculators) and [service-manual-frontend](https://github.com/alphagov/service-manual-frontend) still use [govuk_elements](https://github.com/alphagov/govuk_elements), which is also deprecated

Most admin applications use:

- [govuk_admin_template](https://github.com/alphagov/govuk_admin_template), built by GOV.UK, which uses [Bootstrap](https://getbootstrap.com/)

New admin applications and some legacy admin applications that have been updated use:

- [layout_for_admin](https://govuk-publishing-components.herokuapp.com/component-guide/layout_for_admin) which is available as a component in [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components)

## Long term vision

We have 2 [long term goals](https://docs.google.com/presentation/d/1q51pPWl4uaVM2PxFRmPUNu0wJvYfC-lO7GPLsRvyxtQ/edit) for the frontend:

- Use the same tech for the public and admin apps
- Use as much of the [GOV.UK Design System](https://design-system.service.gov.uk/) as possible

![](https://docs.google.com/drawings/d/e/2PACX-1vS5rtPYUJBvl2Th3JaT7WQQHu4KTDuYMdOiHCzUgyifG9ewuEyim_fC5VjmH8gjZg33o8E7TOcWn0sN/pub?w=873&amp;h=475)
_[Source](https://docs.google.com/drawings/d/1R5s5lHyeDmPFfqXn17Lz3Z2MXoxhJcuSnnmdN327z9g/edit)_

- Public and admin apps use [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components)
- [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components) consumes the [GOV.UK Design System](https://design-system.service.gov.uk/)
