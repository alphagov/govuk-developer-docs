---
owner_slack: "#govuk-2ndline"
title: Athena Fastly Logs Check
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

The monitoring for `Athena has recent results for fastly_logs {database_name}`
is used to check that we can query a particular [Athena database containing
GOV.UK CDN log data][govuk-athena]. It monitors this service by periodically
querying each of the monitored databases and checking that they have > 0 results
over the preceding hours.

## Critical Alert

A critical alert indicates that the database either has no recent results or
that the process to query it failed. By looking at the Jenkins console output
you should be able to determine which of these situations occurred.

If the database query returned 0 results then this indicates that there
is a problem with data being available to query. To determine the cause of
this, you should check that:

- [the Fastly CDN service is still sending logs to the expected S3 bucket and
  these are in the expected JSON
  structure](#how-to-check-log-file-presence-and-validity);
- [the "GOV.UK fastly logs" crawler defined in AWS Glue doesn't have
  errors in it's most recent logs](#how-to-check-the-govuk-fastly-logs-crawler);
- whether you can [query the database yourself][query-athena] manually via
  Athena to confirm there is no recent data.

There is also the possibility that there are no results because there hasn't
been any recent traffic to the particular environment. This is quite unlikely
in production, but may be experienced in integration or staging if the GOR
traffic replay isn't running.

If the query failed with an error rather than returning 0 results then it is
likely that we have data available but the monitoring is broken. In this case
you should inspect the failed Jenkins job for clues as to what is not working.
Potential causes could be: broken credentials, change in the AWS CLI tool
syntax, or a change in the Athena API.

### How to check log file presence and validity

1. [Sign into the AWS console][aws-login] for the appropriate environment.
1. Browse to [S3][] and find the `govuk-{environment}-fastly-logs` bucket.
1. Navigate through the directories of the database in question to verify a
   directory exists for the current day, for example
   `govuk_www/year=2020/month=02/date=20`.
1. If a directory exists for the current day check that there are files present
   from the last few hours (the prefix search can make finding recent files
   easier), new files should added approximately every 15 minutes and may
   lag by 30 mins.
1. If a recent log file is found then you can verify the JSON is valid using
   [jq](https://stedolan.github.io/jq/).
   1. Download the file through S3 web interface.
   1. Run the file through `jq` to check for errors and to view the JSON
      structure, for example
      `gunzip -c 2020-02-20T19_45_00.000-nINz8eDOPAd3Uv1Mq-jW.log.gz | jq`.
   1. If there are errors parsing the JSON you should check the contents of
      the file to identify the problem.

If you find that log files are not being written to S3 or the JSON is invalid
you should log into the [Fastly control panel](https://manage.fastly.com)
(credentials are available in
[govuk-secrets](https://github.com/alphagov/govuk-secrets)) and check the
logging configuration of the service in question. The expected JSON formatting
of CDN logs is defined in the [infra-fastly-logs][] terraform
project and this should be checked to see if it was changed recently and/or
matches what is defined in the Fastly console.

### How to check the "GOV.UK fastly logs" crawler

1. [Sign into the AWS console][aws-login] for the appropriate environment.
1. Browse to [AWS Glue][aws-glue] and navigate to the "Crawlers" section.
1. Find the crawler appropriate for the database, for example "Assets fastly
   logs" is for the "govuk_assets" database.
1. View the logs from the last run by clicking the "Logs" link.
1. Check the crawler has run in a recent time period (it should run once every
   4 hours).

Any issues in the logs should help indicate where a problem may be. For example,
if you see entries indicating that many files don't match the expected schema
it may be that the database schema and JSON structure don't match. If you find
any discrepancies or that the crawler isn't running you should check that
the configuration is correct in the [infra-fastly-logs][] terraform project
and that the configuration is applied.

## Freshness warning

A freshness warning indicates that the Jenkins job to monitor the alerts has
not reported a success or failure in a sufficiently long time period.

Causes for this could be: the Jenkins job no longer exists; the job has been
misconfigured and isn't able to run on a schedule anymore; or the job is
running and there is a problem reporting it's completed status.

To resolve these issues you should investigate Jenkins for signs of problems
in the job and any downstream jobs it triggers.

[govuk-athena]: ../query-cdn-logs.html
[aws-glue]: https://eu-west-1.console.aws.amazon.com/glue/home?region=eu-west-1#catalog:tab=crawlers
[query-athena]: ../query-cdn-logs.html#example-queries
[aws-login]: https://docs.publishing.service.gov.uk/manual/set-up-aws-account.html#2-sign-in-to-aws
[S3]: https://s3.console.aws.amazon.com/s3/home?region=eu-west-1#
[infra-fastly-logs]: https://github.com/alphagov/govuk-aws/blob/master/terraform/projects/infra-fastly-logs/main.tf
