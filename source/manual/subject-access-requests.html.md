---
owner_slack: "#govuk-2ndline"
title: Subject Access Requests
parent: "/manual.html"
layout: manual_layout
section: 2nd line
last_reviewed_on: 2020-09-18
review_in: 6 months
related_applications: [email-alert-api]
---

Subject Access Requests (often referred to as a 'SAR') allow members of the
public to get information being held about them by an organisation.

2nd line might be needed to answer some of the questions in the request, and
this will usually come in through the form of a Zendesk ticket.

## Things to check

Sometimes the request won't be specific about where the data may be stored,
so we should check at least the following places.

If any other information is requested, we should update this documentation so
they become easier to deal with in the future.

### Email subscriptions

⚙  [Run rake task on production][email-rake-task]

[email-rake-task]: /apis/email-alert-api/support-tasks.html#view-subscribers-subscriptions

### Signon

Check if the user [has an account](https://signon.publishing.service.gov.uk/users).

### Licensing

Ask in #govuk-licensing.
