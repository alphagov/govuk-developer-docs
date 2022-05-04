---
owner_slack: "#govuk-frontenders"
title: Frontend architecture
parent: "/manual.html"
layout: manual_layout
type: learn
section: Frontend
related_repos:
 - static
 - slimmer
 - govuk_publishing_components
---

GOV.UK currently uses multiple systems to build frontends (HTML/CSS/JS).

## Current state

![Current state of libraries](https://docs.google.com/drawings/d/e/2PACX-1vQX7w1JT5zboAhKv2jssLPrO39KiWj4SL3T7MfSdigGlS1bjGR6UT_AqKHBKbif0VuRivIPD70WfpCQ/pub?w=1208&amp;h=470)

_[Source](https://docs.google.com/drawings/d/1L7pqFrHB2IQCnr0w3ticqBuR4U12b8psZQanZTvF098/edit)_

Applications that serve pages for the public (everything on www.gov.uk) use:

- components and assets from [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components)
- [layout_for_public](https://components.publishing.service.gov.uk/component-guide/layout_for_public) (via [static](https://github.com/alphagov/static) and [slimmer](https://github.com/alphagov/slimmer))

Most admin applications use:

- [govuk_admin_template](https://github.com/alphagov/govuk_admin_template), built by GOV.UK, which uses [Bootstrap](https://getbootstrap.com/)

New admin applications and some legacy admin applications that have been updated use:

- components and assets from [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components)
- [layout_for_admin](https://govuk-publishing-components.herokuapp.com/component-guide/layout_for_admin)

## Long term vision

![](https://docs.google.com/drawings/d/e/2PACX-1vS5rtPYUJBvl2Th3JaT7WQQHu4KTDuYMdOiHCzUgyifG9ewuEyim_fC5VjmH8gjZg33o8E7TOcWn0sN/pub?w=873&amp;h=475)
_[Source](https://docs.google.com/drawings/d/1R5s5lHyeDmPFfqXn17Lz3Z2MXoxhJcuSnnmdN327z9g/edit)_

We have 2 [long term goals](https://docs.google.com/presentation/d/1q51pPWl4uaVM2PxFRmPUNu0wJvYfC-lO7GPLsRvyxtQ/edit) for the frontend:

- Use the same tech for the public and admin apps
- Use as much of the [GOV.UK Design System](https://design-system.service.gov.uk/) as possible
