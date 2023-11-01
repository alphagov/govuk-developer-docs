---
owner_slack: "#govuk-developers"
title: Sentry
parent: "/manual.html"
layout: manual_layout
section: Monitoring
type: learn
---

[Sentry][] is a service that collates errors that happen on GOV.UK in one
place, regardless of which application, what environment or what machine
the error occurred on. It is far more convenient than logging on to
individual machines and querying their logs.

Useful links:

- [Sentry Organization Stats](https://sentry.io/organizations/govuk/stats/)
  for an overview of how many errors are being sent/rate-limited site-wide.
- [Sentry Projects](https://sentry.io/organizations/govuk/projects/)
  for a per-project view, enabling you to see which ones are causing the
  most errors right now.
- Sentry Grafana dashboards:
  [Production](https://grafana.production.govuk.digital/dashboard/file/sentry_errors_across_all_environments.json),
  [Staging](https://grafana.staging.govuk.digital/dashboard/file/sentry_errors_across_all_environments.json)
  and [Integration](https://grafana.integration.publishing.service.gov.uk/dashboard/file/sentry_errors_across_all_environments.json)
  (all require VPN), for a per-environment breakdown of Sentry errors.

[Sentry]: https://sentry.io/govuk/

## Getting access to Sentry

Your tech lead should raise a PR to give you Sentry access in the [govuk_tech.yml file in govuk-user-reviewer](https://github.com/alphagov/govuk-user-reviewer/blob/main/config/govuk_tech.yml). Once the PR is merged and the Terraform has been applied, you'll be able to [sign in](https://sentry.io/auth/login/) using your GDS Google account.

## Nomenclature

- **Project**: each GOV.UK application has its own project on Sentry, where
  errors originating from that application are consolidated. Example:
  [publishing-api](https://sentry.io/organizations/govuk/issues/?project=202242)
- **Issue**: a group of similar errors. For example, multiple instances of
  `NoMethodError` from the same app are likely to be logged under the same
  issue (see [example][example-issue]) in the project in Sentry. In practice,
  there are a [variety of factors][anchor-error-grouping] that determine
  whether errors are grouped under the same issue.
- **Error/Exception**: a single occurrence of an Issue, containing details
  such as stack trace, arguments, server IP and error message.
  See [example][example-error].

[anchor-error-grouping]: #fingerprinting
[example-issue]: https://sentry.io/organizations/govuk/issues/2150349125/?project=202259&query=is%3Aunresolved
[example-error]: https://sentry.io/organizations/govuk/issues/2155210524/events/aa4edd05a94c4d14b07d4c754a13c788/

## How GOV.UK projects are added to Sentry

Projects can be created and edited in the Sentry UI, but this risks creating
inconsistencies or missing apps. We therefore configure projects using
Terraform.

[Teams are managed in govuk-user-reviewer](https://github.com/alphagov/govuk-user-reviewer/blob/main/terraform/saas/sentry.tf),
and [projects are managed in govuk-infrastructure](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/sentry/locals.tf).

To create a new team or project, edit the respective terraform and run a
plan and apply of the project in Terraform Cloud.

## How Sentry is integrated on GOV.UK

Apps are configured to talk to Sentry using the [govuk_app_config][] gem,
which interfaces with Sentry via its [`GovukError` class][govukerror]. Apps
call `GovukError.configure` - see [example][email-alert-api-example]. This
uses the [delegator pattern][delegator-pattern] to proxy requests to the
underlying Sentry gem, which is [sentry-ruby][] in govuk_app_config v4 and
above.

Unhandled exceptions are automatically logged to Sentry, but you can also
[manually report something to Sentry using `GovukError.notify`][manually-report].
This method takes an exception object, or a string.

[delegator-pattern]: https://github.com/alphagov/govuk_app_config/pull/160
[sentry-ruby]: https://github.com/getsentry/sentry-ruby/tree/master/sentry-raven
[govuk_app_config]: https://github.com/alphagov/govuk_app_config
[govukerror]: https://github.com/alphagov/govuk_app_config/blob/master/lib/govuk_app_config/govuk_error.rb
[email-alert-api-example]: https://github.com/alphagov/email-alert-api/blob/main/config/initializers/govuk_error.rb
[manually-report]: https://github.com/alphagov/govuk_app_config/blob/073c9b2312a4893b040c9225b713ac880c69f5b8/README.md#manual-error-reporting

## Sentry roles

There are different 'roles' in Sentry, with different permissions:

- Most people with access to Sentry have the "Member" role, which lets them
  view errors, issues and projects.
- Those with the "Admin" role can configure teams and projects.
- Those with the "Manager" role can edit organisation settings and set things
  like global rate limits.
- Those with the "Owner" role have unrestricted access to the system and can
  make billing and plan changes.

Some links in this documentation will only be visible to those with the
right permissions. If you need a higher permission than you already have, the
senior tech team can apply this for you.

## Deciding whether to log errors in Sentry

We should only capture actionable errors in Sentry, i.e. errors representing
an underlying issue that developers can fix. We should not capture 4XX
responses, for example, as these indicate a client issue. In fact, sentry-raven
ignores several exception types by default - see below.

### Ignoring exception types

govuk_app_config has a list of ignorable exceptions (
[`excluded_exceptions`][govuk_app_config-excluded_exceptions]). If your
application raises an exception on this list, it will not be logged in Sentry.
Note that sentry-raven also has a
[default list of exceptions to ignore][sentry-raven-excluded_exceptions], but
these are [overwritten, rather than appended][overwrite-warning] by
govuk_app_config, so have no meaning on GOV.UK.

Then there is a list of exceptions to ignore if they occur during the nightly
data sync: [`data_sync_excluded_exceptions`][data_sync_excluded_exceptions].
These are exceptions that are commonly raised while the databases and content
store are periodically unavailable.

When determining whether or not to ignore an exception, the exception chain is
inspected. This means if an exception isn't on the ignore list, but its
underlying cause is an exception on the ignore list, then it will be ignored.
This [applies to `excluded_exceptions`][global-chain-inspection] and
[to `data_sync_excluded_exceptions`][datasync-chain-inspection].

[sentry-raven-excluded_exceptions]: https://github.com/getsentry/sentry-ruby/blob/fec3fe012adfe80af63d54df1dfa8a0bdc0415b2/sentry-raven/lib/raven/configuration.rb#L199-L221
[overwrite-warning]: https://github.com/getsentry/sentry-ruby/blob/fec3fe012adfe80af63d54df1dfa8a0bdc0415b2/sentry-raven/lib/raven/configuration.rb#L35-L37
[govuk_app_config-excluded_exceptions]: https://github.com/alphagov/govuk_app_config/blob/b911c5bbef9bd1df6a92cf31eb5a8e0d3a91d851/lib/govuk_app_config/govuk_error/configure.rb#L20-L50
[data_sync_excluded_exceptions]: https://github.com/alphagov/govuk_app_config/blob/b911c5bbef9bd1df6a92cf31eb5a8e0d3a91d851/lib/govuk_app_config/govuk_error/configure.rb#L57-L65
[global-chain-inspection]: https://github.com/getsentry/sentry-ruby/blob/82e1ffe711af287ddc23e8517bdb8275beff94d5/sentry-raven/lib/raven/configuration.rb#L449-L455
[datasync-chain-inspection]: https://github.com/alphagov/govuk_app_config/blob/b911c5bbef9bd1df6a92cf31eb5a8e0d3a91d851/lib/govuk_app_config/govuk_error/configuration.rb#L43

### Advanced Sentry customisation

For all of the above, you can easily
[configure any of these properties by appending to them][error-reporting].

You can also run arbitrary code to decide whether or not an error should be
logged in Sentry, using the `before_send` lambda. Your custom code will be
[combined with the default evaluators][combined-code] such that if any of the
callbacks returns nil, the exception will be excluded.

[error-reporting]: https://github.com/alphagov/govuk_app_config/blob/master/README.md#error-reporting
[combined-code]: https://github.com/alphagov/govuk_app_config/blob/589b7aae49c3584ead2f60f915be05a7922c5c3e/lib/govuk_app_config/govuk_error/configuration.rb#L63–L71

## When errors are received by Sentry

Sentry first fingerprints the error to decide what Issue to group it under.
It then checks how many occurrences of that Issue have happened recently,
and rate-limits (i.e. ignores) this occurrence if it is happening too
frequently. More details below.

### Fingerprinting

Errors are grouped into Issues automatically by Sentry. By default, Sentry
[groups based on stack trace][stack-trace-grouping]. If no stack trace is
available, it will [group by exception type][exception-grouping] instead.
Failing that, it will group by error message.

Fingerprint rules can be applied at the project level by editing the
"Issue Grouping" page under a project (see [example][example-issue-grouping]).
For example, you can force all errors of the same exception type to have the
same fingerprint. On the same screen, you can set stack trace rules, to
remove or rename certain 'frames' in the trace. In practice, we don't
currently apply any custom rules, after an in-depth [investigation][]
found that Sentry's default grouping was already very accurate (despite it
often looking like the same exception is spread across multiple issues).

[stack-trace-grouping]: https://docs.sentry.io/platforms/ruby/data-management/event-grouping/#grouping-by-stack-trace
[exception-grouping]: https://docs.sentry.io/platforms/ruby/data-management/event-grouping/#grouping-by-exception
[example-issue-grouping]: https://sentry.io/settings/govuk/projects/app-asset-manager/issue-grouping/
[investigation]: https://trello.com/c/NZNjFHWO/284-5-improve-sentrys-grouping-of-exceptions-8

#### Stack trace cleaning

Note that sentry-raven automatically cleans up stack traces for the purposes
of fingerprinting, so that stack trace frames like:

`app/views/welcome/view_error.html.erb in _app_views_welcome_view_error_html_erb__2807287320172182514_65600 at line 1`

...get normalised to:

`app/views/welcome/view_error.html.erb at line 1`

This means if the same `ActionView::Template::Error` error happens twice, it
is grouped into the same issue instead of erroneously treated as separate issues.

sentry-raven uses a [customised version][custom-rails-backtrace] of
`Rails::BacktraceCleaner` to do this. The
[original `BacktraceCleaner`][native-rails-backtrace] would do this, but also
remove any "framework trace" from the stacktrace, leaving only the "application
trace" behind. The original `BacktraceCleaner` would actually be beneficial for
grouping, as Sentry is very sensitive to stack traces that differ only slightly
(which can happen when a dependency is updated or a Ruby version is upgraded).
However, removing the framework traces entirely means losing key diagnostic
information, so the customised, less aggressive `BacktraceCleaner` is a better
choice.

[custom-rails-backtrace]: https://github.com/getsentry/sentry-ruby/pull/1011/files#diff-c01d5cbc846720e47a4185cb501a55225247ec698aa169b0a2773ca9b65ae35dR1-R29
[native-rails-backtrace]: https://github.com/rails/rails/blob/b66235d432d0505857ff667e0a1ddecfb5640a56/railties/lib/rails/backtrace_cleaner.rb

### Rate limiting

GOV.UK is on a legacy billing plan with an account limit of 1000 events per hour.
When this limit is reached, subsequent events get discarded, meaning that noisy
issues can prevent other, more important issues from being logged.

In practice, it's more complicated than that. We have a per-project limit of 50%,
the lowest that Sentry allows. This means that any one project on Sentry cannot
log more than 500 events before it is rate limited. This is a protection
mechanism, ensuring that we would need two projects to be recording high-volume
errors to risk breaching our account limit. These limits are configured on the
[Rate Limits][sentry-configure-rate-limits] page.

[sentry-configure-rate-limits]: https://sentry.io/settings/govuk/rate-limits/

## Slack alerts

You can configure Sentry to notify a Slack channel when a notable condition is
satisfied. For example, the `#govuk-platform-security-reliability-team` channel gets notified when
any issue records 100 or more errors in a 1 hour period.

To set up an alert, visit the [Alerts panel][], select the project the alert
should apply to (e.g. `app-whitehall`), and then click "Create Alert Rule". It is
currently not possible to set up a 'global' alert to apply to all projects at
once.

We encourage teams to set up alerts for any projects they're responsible for, so
that they can be alerted to new and high-volume issues and prioritise them.
Multiple teams are allowed to set up alerts for the same projects.

[Alerts panel]: https://sentry.io/organizations/govuk/alerts/rules/

## Sentry issue actions

In the Sentry UI, you can merge related issues together, resolve issues, or
archive issues (permanently or for a set time period).

### Merging Sentry issues

Duplicate issues can be merged by going into the project view, checking the
boxes associated with each issue, and clicking "Merge". This should be done very
carefully, as issues cannot be unmerged once they are merged, and the issues are
often subtly different and warrant being separate issues. For example, they may
have the same exception type but occur in different transactions, so require two
separate fixes.

To find out why Sentry has treated two issues as separate, visit each issue and
scroll to the bottom of the page to see the "Event grouping information".

### Resolving an issue

When you know you've fixed the underlying issue, you should
[comment on the issue][anchor-comment] explaining what you've done, and then
click the "Resolve" button. This removes it from the default Sentry UI, making it
less noisy, but also has the advantage of marking it as a regression and emailing
you if the issue occurs again.

### Archiving (or ignoring) an issue

You can "Archive" something for a set period of time - this option used to
be called "Ignore" in Sentry. Archiving an issue for a set period of time can be
useful if you've identified an issue and written it up as a Trello card (or are
actively working on fixing it), as it prevents Sentry from accumulating events
and potentially spamming your Slack channel.

In these cases, you should [comment on the issue][anchor-comment] with a link to
your card or PR, then archive the issue for a set period . You should also set the
"Assignee" to yourself.

You can always un-archive an issue later if needed.

### Commenting on an issue

[anchor-comment]: #commenting-on-an-issue

Click on the issue, then on the "Activity" tab, where you can leave a comment.
Comments support markdown.

### Deleting and discarding an issue

If you've identified an issue that is high-volume, but is unlikely to be fixed any
time soon, you can [Delete and Discard][] the issue by clicking the arrow next to
the trash can and selecting "Delete and discard future events".

This should only be used when the issue is likely to have a significant impact on
our [Sentry quota](#rate-limiting). It is possible to "undiscard" the issue later,
but this will only capture new events. Any events prior to the "undiscard" action
are lost.

[Delete and Discard]: https://blog.sentry.io/2018/01/03/delete-and-discard

## Special Sentry accounts

There is a `2ndLineBot` member on the [members list](https://sentry.io/settings/govuk/members/)
which is set up so that a weekly Sentry report is sent to the Technical 2nd Line email address.
This bot account should not be deleted.

## GDS-wide usage of Sentry

Sentry is used by several programmes in GDS, not just GOV.UK. A report,
[GDS use of Sentry.io](https://docs.google.com/document/d/1yVa9iiu-DayGy-MtlrdXeV0E09CsetUenZJCmusLfLg/edit),
covers this in more detail, including documenting some of the limitations of the
setup.

## Retention period

[90 days](https://sentry.io/security/#data-retention).
