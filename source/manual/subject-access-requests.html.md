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
this will usually come in through the form of a Zendesk ticket. Once 2nd line
has found the necessary information, the request might need to be passed to
another team to fully complete the request, for example, Licensing.

## Known requests

So far we've received requests that have asked for information on:

### Email subscriptions

We've had requests to get information on what is held about an email address
in terms of subscriptions. [There is a rake task for that][rake-task].
We also have [some documented queries that can help get this][email-alert-api-analytics].

[email-alert-api-analytics]: /manual/email-alert-api-analytics.html
[rake-task]: /apis/email-alert-api/tasks.html#view-subscribers-subscriptions

### Others

If any other information is requested, we should update this documentation so
they become easier to deal with in the future.
