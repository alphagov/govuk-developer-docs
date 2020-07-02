---
owner_slack: "#govuk-2ndline"
title: "Publisher: Unprocessed fact-check emails"
section: Icinga alerts
subsection: Email alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-07-02
review_in: 6 months
---

### Unprocessed fact-check emails

This means there are unprocessed emails in the [fact-check] inbox (currently
`factcheck@alphagov.co.uk` but soon to change to
`govuk-fact-check@digital.cabinet-office.gov.uk`).
Publisher has a [script (`mail_fetcher`)](script) that checks the inbox
[every 5 minutes](schedule) and [processes all emails present](process).

If emails are not processed or deleted, this alert is triggered. The level of
the [alert] depends on the number of emails present - which was chosen
arbitrarily and is currently:

- [warning with 1 email](warning)
- [critical with 2 or more emails](critical)

### Log into the fact-check inbox

If this alert is triggered, we want to [log into the fact-check inbox](login)
and investigate why the emails were not processed and deleted.

The password to log into the govuk-fact-check@digital.cabinet-office.gov.uk
inbox can be found by running:

```bash
PASSWORD_STORE_DIR=~/govuk/govuk-secrets/pass/2ndline pass google-accounts/govuk-fact-check@digital.cabinet-office.gov.uk
```

The password to log into the factcheck@alphagov.co.uk inbox can be found by
logging into the Publisher console:

```bash
gds govuk connect app-console -e production publisher
```

and then running:

```bash
Publisher::Application.mail_fetcher_config
```

The same can be done for
staging (govuk-fact-check-staging@digital.cabinet-office.gov.uk)
and integration (govuk-fact-check-integration@digital.cabinet-office.gov.uk).

[fact-check]: https://github.com/alphagov/publisher/blob/d0ab32c10c5d22ffb9b6edccb84f5345bd766cf4/doc/fact-checking.md
[script]: https://github.com/alphagov/publisher/blob/d0ab32c10c5d22ffb9b6edccb84f5345bd766cf4/script/mail_fetcher
[schedule]: https://github.com/alphagov/publisher/blob/d0ab32c10c5d22ffb9b6edccb84f5345bd766cf4/config/schedule.rb#L7-L9
[process]: https://github.com/alphagov/publisher/blob/d0ab32c10c5d22ffb9b6edccb84f5345bd766cf4/lib/fact_check_email_handler.rb#L41-L53
[warning]: https://github.com/alphagov/govuk-puppet/blob/68507dba280dd6e2fd4e5663f915c0fd7be06bef/modules/govuk/manifests/apps/publisher/unprocessed_emails_count_check.pp#L19
[critical]: https://github.com/alphagov/govuk-puppet/blob/68507dba280dd6e2fd4e5663f915c0fd7be06bef/modules/govuk/manifests/apps/publisher/unprocessed_emails_count_check.pp#L20
[login]: https://support.google.com/accounts/answer/1721977?co=GENIE.Platform%3DDesktop&hl=en
[alert]: https://github.com/alphagov/govuk-puppet/blob/68507dba280dd6e2fd4e5663f915c0fd7be06bef/modules/govuk/manifests/apps/publisher/unprocessed_emails_count_check.pp
