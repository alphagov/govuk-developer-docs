---
owner_slack: "#govuk-platform-health"
title: "Publisher: Unprocessed fact-check emails"
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
---

As part of the [Publisher fact checking process], this alert appears if emails
have arrived in the inbox but weren't able to be processed. This is usually
because they're missing the identification for the edition they relate to
(which is currently stored in the subject line).

[Publisher fact checking process]: https://github.com/alphagov/publisher/blob/master/doc/fact-checking.md

## Dealing with the alert

### Log in to the inbox

To investigate the emails we first need to [log in to the inbox][login].

[login]: https://support.google.com/accounts/answer/1721977?co=GENIE.Platform%3DDesktop&hl=en

The current email addresses used for the fact checking process are:

- govuk-fact-check@digital.cabinet-office.gov.uk
- govuk-fact-check-staging@digital.cabinet-office.gov.uk
- govuk-fact-check-integration@digital.cabinet-office.gov.uk

#### Retrieving credentials

The passwords for the @digital.cabinet-office.gov.uk addresses are found in
[govuk-secrets]:

[govuk-secrets]: https://github.com/alphagov/govuk-secrets

```sh
PASSWORD_STORE_DIR=~/govuk/govuk-secrets/pass/2ndline pass google-accounts/govuk-fact-check@digital.cabinet-office.gov.uk
```

The password for the factcheck@alphagov.co.uk address can be found by logging
into the Publisher console:

```sh
$ gds govuk connect app-console -e production publisher
```

```ruby
> Publisher::Application.mail_fetcher_config
```

### Investigate the unprocessed emails

There are a number of different ways of proceeding here based on why the email
wasn't able to be processed:

#### Spam/out of office

If the email is clearly spam or not relevant for other reasons,
**it can be deleted**.

#### Missing edition identification

If the subject line is missing the edition identification but is clearly a
valid fact check response, the first thing to check is if a follow up
email was sent with the correct subject.

This can be checked by [logging in to Publisher][publisher] and finding the
relevant edition by using the title. Usually you'll need to filter on editions
with the state of "Published" or "Out for fact check".

Once you've found the edition, you can check in the "History and notes" tab
to see if the fact check was eventually re-sent with the correct subject line.
If this is the case, **the duplicate email can be deleted**.

If the fact check email never made it, you should forward the email to
govuk-fact-check@digital.cabinet-office.gov.uk with the edtion ID added to the
subject line in square brackets. Check this appears in publisher (usually within
10 minutes) then delete the original unprocessed email from the inbox.

[publisher]: https://publisher.publishing.service.gov.uk/
