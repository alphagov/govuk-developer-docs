---
owner_slack: "#govuk-developers"
title: Review a page in this manual
section: Documentation
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-01-23
---

Every page in the manual has a "Last updated" value, based on its `last_reviewed_on` value at the top of the source file. The more recent the date, the more confidence the reader can have that the content is accurate.
If that is missing, the date of the most recent commit applied to the file will be used.

It is helpful to review a document at the point of using it, as you likely have the most context for the problem at that moment in time.

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

These tasks can be achieved by editing the metadata at the top of the source for that page.

### Choose a review by date

- How likely is it that the information will change?
- Is work happening in this area?
- What would the impact be if the information were wrong?

### Relevant blog posts to link to

Is there a relevant blog post to the page you're reviewing? Would linking to it help the reader complete their task?

You can find [GOV.UK blog posts on the GDS Tech blog](https://gdstechnology.blog.gov.uk/category/gov-uk/).

[redirects]: https://github.com/alphagov/govuk-developer-docs/blob/master/config/tech-docs.yml
