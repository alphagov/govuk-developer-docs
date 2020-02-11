---
owner_slack: "#govuk-developers"
title: Review a page in this manual
section: Documentation
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-23
review_in: 12 months
---

We have [a system to make sure we regularly review pages](https://github.com/alphagov/tech-docs-monitor) in the manual.

Main pages in the manual are reviewed every 3-12 months.

We also document Icinga alerts. These explain what to do when a certain alert triggers ([example](/manual/alerts/fastly-error-rate.html)). Because these can be very rare and hard to review, we should review these around the same time every six months. This is best done by people with a lot of 2nd line context. To make sure we've documented all alerts, you can [run `rake lint_alert_docs` in govuk-puppet](https://github.com/alphagov/govuk-puppet/blob/master/lib/tasks/lint_alert_docs.rake), which will output alerts that can be removed/need to be added.

## How to review

### Things to look out for

- Is the page accurate?
- Is the page still relevant?
- Does it help the reader complete their task?
- Does it [follow the styleguide](/manual/docs-style-guide.html)?

### When you've reviewed the page, either:

- Update the page
- Remove it (don’t forget to [set up a redirect][redirects])
- Assign it for someone else to review
- Confirm the page is OK and set a new review date

These tasks can be achieved by editing the metadata at the top of the source for that page. See the [govuk-developer-docs github repo](https://github.com/alphagov/govuk-developer-docs).

### Choose a review by date

- How likely is it that the information will change?
- Is work happening in this area?
- What would the impact be if the information were wrong?

### Relevant blog posts to link to

Is there a relevant blog post to the page you're reviewing? Would linking to it help the reader complete their task?

You can find [GOV.UK blog posts on the  GDS Tech blog](https://gdstechnology.blog.gov.uk/category/gov-uk/).

[redirects]: https://github.com/alphagov/govuk-developer-docs/blob/master/config/tech-docs.yml
