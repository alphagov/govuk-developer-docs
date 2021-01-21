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

## How Sentry is integrated on GOV.UK

Projects can be created and edited in the Sentry UI, but this risks creating
inconsistencies or missing apps. We therefore configure projects using
[govuk-saas-config][] (and its [associated rake tasks][rake-tasks]), which
read a [list of apps][docs-apps] from govuk-developer-docs and make sure that
all configuration is set up correctly.

Apps are configured to talk to Sentry using the [govuk_app_config][] gem,
which interfaces with Sentry via its [`GovukError` class][govukerror]. Apps
call `GovukError.configure` - see [example][email-alert-api-example]. This
[delegates][delegator-pattern] to the [sentry-raven][] gem under the hood,
though the gem is now superseded by sentry-ruby, which we have
[plans to migrate to][trello-migrate] in the future.

Unhandled exceptions are automatically logged to Sentry, but you can also
[manually report something to Sentry using `GovukError.notify`][manually-report].

[docs-apps]: https://docs.publishing.service.gov.uk/apps.json
[govuk-saas-config]: https://github.com/alphagov/govuk-saas-config/blob/5171b2803a7e211fff9536909b7d27c7fa5a4840/sentry/Rakefile#L1-L12
[rake-tasks]: https://github.com/alphagov/govuk-saas-config/blob/5171b2803a7e211fff9536909b7d27c7fa5a4840/sentry/Rakefile#L26-L87
[delegator-pattern]: https://github.com/alphagov/govuk_app_config/pull/160
[sentry-raven]: https://github.com/getsentry/sentry-ruby/tree/master/sentry-raven
[trello-migrate]: https://trello.com/c/1zVPYfTR/1979-replace-sentry-raven-with-sentry-ruby
[govuk_app_config]: https://github.com/alphagov/govuk_app_config
[govukerror]: https://github.com/alphagov/govuk_app_config/blob/master/lib/govuk_app_config/govuk_error.rb
[email-alert-api-example]: https://github.com/alphagov/email-alert-api/blob/master/config/initializers/govuk_error.rb
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

### Ignoring environments

There is a hardcoded list of environments in which Sentry is
considered to be active. If the `SENTRY_CURRENT_ENV` environment variable
available to your app is not on the
[`active_sentry_environments`][active_sentry_environments] list, then none of
its errors will be logged to Sentry.

[active_sentry_environments]: https://github.com/alphagov/govuk_app_config/blob/b911c5bbef9bd1df6a92cf31eb5a8e0d3a91d851/lib/govuk_app_config/govuk_error/configure.rb#L14-L18

### Advanced Sentry customisation

For all of the above, you can easily
[configure any of these properties by appending to them][error-reporting].

You can also run arbitrary code to decide whether or not an error should be
logged in Sentry, using the `should_capture` lambda. Your custom code will be
[lazily combined with the default evaluators][combined-code] such that if an
exception is on any of the 'excluded exceptions' lists, it will be excluded
(even if your custom `should_capture` callback returns true).

[error-reporting]: https://github.com/alphagov/govuk_app_config/blob/master/README.md#error-reporting
[combined-code]: https://github.com/alphagov/govuk_app_config/blob/b911c5bbef9bd1df6a92cf31eb5a8e0d3a91d851/lib/govuk_app_config/govuk_error/configuration.rb#L18-L24

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

In addition, we've set up alerting so that any issue which records 100 or more
errors in an hour period gets alerted to `#govuk-platform-health`. These alerts
are configured in the [Alerts panel][].

[Alerts panel]: https://sentry.io/organizations/govuk/alerts/rules/
[sentry-configure-rate-limits]: https://sentry.io/settings/govuk/rate-limits/
