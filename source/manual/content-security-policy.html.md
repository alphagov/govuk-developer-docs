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

CSP can be run in two modes - *enforce*, where violations are blocked and the violation is reported to a given endpoint
and *report only*, where the violation is allowed to execute and a report is sent.

GOV.UK runs a CSP in enforce mode on the applications serving [www.gov.uk](https://www.gov.uk) - frontend applications
(with the exception of Whitehall due to current work to retire its frontend rendering). This enforce mode started in
Summer 2023, following a number of years running in report-only mode.

Although as of July 2023, only frontend applications are running the CSP it is intended to serve the needs of both
GOV.UK frontend and admin applications. We aspire to eventually run it across all applications and encourage teams
that own admin applications to use it.

## How the policy is set and changed

We have a global base policy that can be modified in individual applications. When you need to make modifications you
should prefer making changes in individual applications it is something that affects all GOV.UK pages or is across
most applications. Each frontend app has an [initialiser](https://github.com/alphagov/government-frontend/blob/main/config/initializers/csp.rb)
which invokes the CSP setting code in the gem.

There are two approaches to apply a CSP configuration change to an individual application:

- You can apply CSP modifications to an individual controller or action ([example in Smart Answers](https://github.com/alphagov/smart-answers/blob/1a2ff1d9f430afcc7435ac9775cc44de6b0a98f1/app/controllers/smart_answers_controller.rb#L8-L12)).
- You can apply a CSP modification to an entire application ([example in govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components/blob/80791ac61e2d5b959725f6b1064a2f83a82e9bf8/spec/dummy/config/initializers/content_security_policy.rb#L23))

The base policy is set in [`govuk_app_config` gem][govuk_csp]. This policy is shared amongst GOV.UK applications and
should only contain directives that are either global or common to many applications. This can be amended and deployed
to apps with a new gem release.

[govuk_csp]: https://github.com/alphagov/govuk_app_config/blob/main/lib/govuk_app_config/govuk_content_security_policy.rb

## How violations are reported

We log reports to Amazon S3 bucket which can be queried with [Athena](https://aws.amazon.com/athena/). We store them
for 30 days. Many of the reports we receive are from browser extensions we can't control so we
[filter the most prolific of them][lambda] from our logs.

As we receive high volumes of false positive alerts, it is likely we will remove the reporting functionality once
a CSP is enforced.

[lambda]: https://github.com/alphagov/govuk-aws/blob/main/terraform/lambda/CspReportsToFirehose/index.mjs

### Querying violations

Athena is available through the AWS control panel. To access, [log into AWS](/manual/get-started.html#sign-in-to-aws)
as a poweruser or greater privilege access, navigate to
[Athena](https://eu-west-1.console.aws.amazon.com/athena/home?region=eu-west-1#/query-editor) and select
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
