---
owner_slack: "#govuk-2ndline"
title: CDN logs from Fastly not appearing in S3
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

## Meaning and impact

CDN logs from Fastly might not be getting uploaded to the
`govuk-{environment}-fastly-logs` S3 bucket.

## Possible causes

* Configuration change to Fastly may have stopped the log upload from working.
* Access controls might have changed on the S3 bucket.
* There might be a problem with the alert itself. It was added in Feb 2020.

## Investigation

List the S3 bucket to see what log files are present for today's date.
Depending on your level of access, you might need to replace `admin` with
`poweruser`. The S3 prefix is in the alert's Status Information in Icinga.

```
$ gds aws govuk-production-admin -- aws s3 ls s3://govuk-production-fastly-logs/govuk_assets/year=2020/month=02/date=04/
...
2020-02-04 13:30:06      10565 2020-02-04T13:30:00.000-q0DyBS-uFj3pPKiRDsVz.log.gz
2020-02-04 13:30:04       8833 2020-02-04T13:30:00.000-rx5n9t5ClzuVpEMb4Y8H.log.gz
2020-02-04 13:30:04      12012 2020-02-04T13:30:00.000-sOjSZzfwbklh5BaLe2Wx.log.gz
```

Log files should appear in batches every 15 minutes and there should normally
be only 30 minutes' lag between the current time and the latest batch of files.

If logs are missing, check any recent changes to the [Fastly
config](/manual/cdn.html#cdn-configuration). The active Fastly config (and
previous versions) can be inspected via the Fastly web interface. The login for
this is in the 2nd-line password store in govuk-secrets, under
`fastly/deployment_shared_account`.
