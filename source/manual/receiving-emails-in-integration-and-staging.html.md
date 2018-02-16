---
owner_slack: "#email"
title: Receiving emails in integration and staging
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-02-16
review_in: 1 month
---

To avoid sending real emails in integration and staging that come from the data sync process, any email subscriptions
are, by default, sent with the email address overridden to a GOV.UK Notify success address.

To make sure that you're able to also receive emails for any subscriptions you may have set up in integration or
staging, you must add your email address to the whitelist.

The list can be found in [govuk-puppet][govuk-puppet] in the [`hieradata/common.yaml` file][common-yaml] (don't forget
to make the change in both the AWS and non-AWS copy). The key for the whitelist is
`govuk::apps::email_alert_api::email_address_override_whitelist`.

[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[common-yaml]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml
