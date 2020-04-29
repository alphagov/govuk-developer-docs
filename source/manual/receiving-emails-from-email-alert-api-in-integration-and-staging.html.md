---
owner_slack: "#govuk-developers"
title: Receive emails from Email Alert API in integration and staging
section: Emails
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-04-29
review_in: 6 months
---

In `integration` and `staging` Email Alert API defaults to sending emails
to a single test address: `success@simulator.amazonses.com`. This is used to
simulate a successful email sending.

However, you can override this for specific email addresses for testing
purposes. To do this, [you will need to be added as a team member to
the GOV.UK Email Integration or Staging service in Notify][add-in-notify] and
make changes to govuk-puppet.

[add-in-notify]: /manual/govuk-notify.html#receiving-emails-from-govuk-notify

In [govuk-puppet][]:

1. Add your email address to the common.yml for [hieradata](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml#L442) and [hieradata_aws](https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/common.yaml#L488) (these lists need to be kept in sync with the team members list in Notify)
2. Add your email address to the override whitelist in the YAML file for the environment you're testing on. This is set as an
   environment variable via hieradata under the key of
   `govuk::apps::email_alert_api::email_address_override_whitelist`. It should look something like this:

   ```
    govuk::apps::email_alert_api::email_address_override_whitelist:
      - your.name@digital.cabinet-office.gov.uk
   ```
  3. Create a branch with these changes and push them to GitHub. Deploy these changes by running [integration-puppet-deploy](https://ci.integration.publishing.service.gov.uk/job/integration-puppet-deploy/build?delay=0sec), providing your branch name instead of a release tag.

Once these changes have been deployed and the environment variable
`EMAIL_ADDRESS_OVERRIDE_WHITELIST` is populated with your address you can test
that you can receive emails by running the [deliver:to_test_email[name@example.com]](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=email-alert-api&MACHINE_CLASS=email_alert_api&RAKE_TASK=deliver:to_test_email[name@example.com]) [rake task].

## Testing digest emails

It is possible to re-send an entire digest run (e.g. to test changes that have been made to the email template) in integration.  You will need to have added yourself to the whitelist and have a digest subscription (daily or weekly) to something that had a significant update during the time period the digest covers (e.g. daily would be 07:00 the previous day to 07:00 today).

Using a Rails console for email-alert-api, retrieve the digest run that you wish to resend, then delete it, e.g.

```
digest = DigestRun.where(range: 'daily').last
DigestRun.delete(digest)
```

Then rerun the relevant digest initiator worker (either daily or weekly):

```
DailyDigestInitiatorWorker.perform_async
WeeklyDigestInitiatorWorker.perform_async
```

[Notify]: https://www.notifications.service.gov.uk
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[rake task]: https://github.com/alphagov/email-alert-api/blob/master/lib/tasks/deliver.rake#L19
