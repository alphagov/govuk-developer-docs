---
owner_slack: "#govuk-notifications"
title: Receive emails from Email Alert API in integration and staging
section: Emails
layout: manual_layout
parent: "/manual.html"
---

In `integration` and `staging` Email Alert API defaults to [writing emails to
a logfile][logging-emails] rather than sending them to Notify. Only [email
addresses specified in GOV.UK Puppet][puppet-config] will receive actual
emails.

You can override this for specific email addresses for testing
purposes. To do this, [you will need to be added as a team member to
the GOV.UK Email Integration or Staging service in Notify][add-in-notify] and
make changes to GOV.UK Puppet.

1. Add your email address to the `govuk_notify_recipients` list in
   [hieradata_aws/common.yml][].
2. Create a branch with your changes and push them to GitHub. Deploy the
   changes by running the [deploy-puppet][] job for the environment you're
   testing on, providing your branch name instead of a release tag.
3. Once these changes have been deployed, and the environment variable
   `GOVUK_NOTIFY_RECIPIENTS` is populated with your address, you can test that
   you can receive emails by running the [Send a test email][] support task.

## Testing digest emails

It is possible to re-send an entire digest run (e.g. to test changes that have been made to the email template) in integration.  You will need to have added yourself to the recipients list and have a digest subscription (daily or weekly) to something that had a significant update during the time period the digest covers (e.g. daily would be 07:00 the previous day to 07:00 today).

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

[logging-emails]: https://github.com/alphagov/email-alert-api/blob/006afa2ee6c35631b83b16519f8af2c6c2ea5c59/app/services/send_email_service/send_pseudo_email.rb#L10-L20
[puppet-config]: https://github.com/alphagov/govuk-puppet/blob/028381e3022f635e1958a45478b0b274e672b602/hieradata_aws/common.yaml#L546-L549
[add-in-notify]: /manual/govuk-notify.html#receiving-emails-from-govuk-notify
[hieradata_aws/common.yml]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata_aws/common.yaml
[deploy-puppet]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_Puppet
[Send a test email]: https://github.com/alphagov/email-alert-api/blob/master/docs/support-tasks.md#send-a-test-email
