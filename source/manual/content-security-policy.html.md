---
owner_slack: "#govuk-developers"
title: 'Content Security Policy on GOV.UK'
section: Security
layout: manual_layout
parent: "/manual.html"
---

Content Security Policy (CSP) is a browser standard to prevent cross-site scripting (XSS), clickjacking and other code
injection attacks resulting from execution of malicious content in the context of another website. A policy, determining
which stylesheets, scripts and other assets are allowed to run, is sent with every request and is parsed and enacted by
the browser.

CSP can be run in two modes - *report only*, where violations of the policy are reported to a given endpoint but
allowed to execute, and *enforcement*, where violations are blocked.

## GOV.UK CSP History

As of 2022, GOV.UK has been working, on and off, towards adding a CSP to the public www.gov.uk website for a number of
years. We have configured one that has been running on the frontend applications, in report only mode, since 2019.
We track this incomplete implementation as [tech debt](https://trello.com/c/lxxx5XLZ/178-govuk-has-a-half-implemented-content-security-policy-csp).

We continue to aspire to have the CSP set to enforcement mode and intend to enhance it to forbid [`unsafe-inline`][unsafe-inline]
scripts and styles (in applicable applications) before launching it.

[unsafe-inline]: https://content-security-policy.com/unsafe-inline/

## How the policy is set

GOV.UK has a base policy set in the [`govuk_app_config` gem][govuk_csp]. This policy is shared amongst GOV.UK
applications and should contain directives that are either global or common to many applications.

Each frontend app has an [initialiser](https://github.com/alphagov/government-frontend/blob/main/config/initializers/csp.rb)
which invokes the CSP setting code in the gem. Each application can make customisations to the policy for
application/route specific needs ([example in Smart Answers](https://github.com/alphagov/smart-answers/blob/1a2ff1d9f430afcc7435ac9775cc44de6b0a98f1/app/controllers/smart_answers_controller.rb#L8-L12)).

[govuk_csp]: https://github.com/alphagov/govuk_app_config/blob/main/lib/govuk_app_config/govuk_content_security_policy.rb

## How violations are reported

In all production-like environments (production, staging, integration), CSP is running in report only mode. In other
environments such as development and test, CSP is running in enforcement mode to allow errors to be captured
at an early stage.

We log reports to Amazon S3 bucket which can be queried with [Athena](https://aws.amazon.com/athena/). We store them
for 30 days. Many of the reports we receive are from browser extensions we can't control so we
[filter the most prolific of them][lambda] from our logs.

As we receive high volumes of false positive alerts, it is likely we will remove the reporting functionality once
a CSP is enforced.

[lambda]: https://github.com/alphagov/govuk-aws/blob/main/terraform/lambda/CspReportsToFirehose/index.mjs

### Querying violations

Athena is available through the AWS control panel. To access, [log into AWS](/manual/get-started.html#sign-in-to-aws),
navigate to [Athena](https://eu-west-1.console.aws.amazon.com/athena/home?region=eu-west-1#/query-editor) and select
the `csp_reports` database. The database is available in all environments, however the production environment one is
that only one that will have good quality data.

You can use SQL as the means to query Athena. Whenever you query it you should **always use
[partitions](https://docs.aws.amazon.com/athena/latest/ug/partitions.html)** which will make the query
substantially cheaper and faster.

#### Example Queries

Most recent reports

```
SELECT *
FROM csp_reports.reports
-- partitions
WHERE year = 2022 AND month = 12 AND date = 8
ORDER BY time DESC
LIMIT 10;
```

Most commonly blocked URI

```
SELECT blocked_uri, COUNT(*)
FROM csp_reports.reports
-- partitions
WHERE year = 2022 AND month = 12 AND date = 8
GROUP BY blocked_uri
ORDER BY COUNT(*) DESC;
```
