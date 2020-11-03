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

This involves manually querying a couple of databases. Start by logging on to the
licensing backend machine.

```bash
gds govuk connect -e production ssh licensing_backend
```

Connect to MongoDB with the following command. The host may be different, and can be
found in `/etc/licensing/gds-licensing-config.properties`.

```bash
mongo licensify-documentdb-0.ca5itorbs5wc.eu-west-1.docdb.amazonaws.com/licensify -u master -p
```

You'll be prompted for the password, which you can also find in the config file from
above. Once you're in the DB console, run:

```bash
db.applications.find({ email: "[email address]" }).count()
```

Secondly, we need to check for any audit records, which may still exist even if the
original licence application has been archived:

```bash
use licensify-audit

db.audit.find({ detail: { emailAddress: "[email address]" } }).count()
```

If you still need help, try asking in #govuk-licensing.
