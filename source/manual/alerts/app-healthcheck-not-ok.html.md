---
owner_slack: "#govuk-2ndline-tech"
title: App healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

Most apps on GOV.UK have a `/healthcheck/ready` endpoint that checks if the app is "ready" to respond to requests, including things like connecting to a database ([example](https://github.com/alphagov/content-publisher/blob/8df63907dab486a54894105b829ab9ea02936b67/config/routes.rb#L115-L118)).

This alert works by [making a request to the app's healthcheck endpoint](https://github.com/alphagov/govuk-puppet/blob/fab936cb82be7fad42636fcafca3718a8368ebfe/modules/icinga/files/usr/lib/nagios/plugins/check_json_healthcheck#L155) on a machine where the app runs. For most apps the endpoint is `/healthcheck/ready`; for legacy apps it's just a random page ([example](https://github.com/alphagov/govuk-puppet/blob/3f05678f36fde027efd3bbaae2421ebe04103136/modules/licensify/manifests/apps/licensify.pp#L63)).

Most healthcheck endpoints use [checks from govuk_app_config](https://github.com/alphagov/govuk_app_config/blob/master/docs/healthchecks.md); see below for guidance on these. Some apps also implement custom checks and the alert links to custom documentation to explain them:

- [Search API app healthcheck not ok](/manual/alerts/search-api-app-healthcheck-not-ok.html)
- [content-data-api app healthcheck not ok](/manual/alerts/content-data-api-app-healthcheck-not-ok.html)
- [datagovuk_publish app healthcheck not ok](/manual/alerts/datagovuk-publish-healthcheck-not-ok.html)

> **Note:** most apps also have a separate `/healthcheck/live` endpoint, which often just returns "200 OK" ([example](https://github.com/alphagov/publishing-api/blob/50af13759827318fb953086c836490b2f3de1242/config/routes.rb#L52)). This endpoint is meant to be a lightweight check for use with certain types of infrastructure, such as [AWS Elastic Load Balancers (ELBs)](https://github.com/alphagov/govuk-aws/pull/1438). [Read more about separate healthchecks](https://github.com/alphagov/govuk-rfcs/blob/main/rfc-141-application-healthchecks.md).

## Connection Refused Error

This means the app is not accepting requests for the healthcheck endpoint, and is probably down e.g. if the alert is appearing alongside an [`upstart not up` alert](/manual/alerts/check-process-running.html).

- Check [the processes are running](check-process-running.html).
- Try the healthcheck endpoint manually:

  ```
  # SSH on to a machine running Content Publisher
  gds govuk connect ssh -e integration backend

  # Find the port it's running on
  ps -ef | grep content-publisher | grep master

  # Do the Icinga check manually
  curl localhost:3221/healthcheck/ready
  ```

## Timeout Error

This means the app is accepting requests, but taking too long to respond (over [20 seconds](https://github.com/alphagov/govuk-puppet/blob/fab936cb82be7fad42636fcafca3718a8368ebfe/modules/icinga/files/usr/lib/nagios/plugins/check_json_healthcheck#L155)).

- Try the healthcheck endpoint manually, as above, to confirm.
- Check the logs e.g. `tail -100f /var/log/email-alert-api/app.err.log`.
- Check for resource issues e.g. on the [Machine dashboard][machine metrics].

## Active Record Check

This means the app is unable to connect to its database.

- Check for [any RDS alerts](/manual/govuk-in-aws.html#postgresql-and-mysql).
- Check the corresponding [AWS RDS dashboard][rds dash] to see if we're experiencing resourcing issues.
- Check for network connectivity to the DB.

```
# SSH on to a machine with the problem
gds govuk connect ssh -e integration backend

# Find the DB connection details
govuk_setenv content-publisher env | grep -i postgres

# Try to connect
psql -h postgresql-primary -U content-publisher -W content_publisher_production

# Try a command
select * from users;
```

## Sidekiq / Redis Check

This means that the Sidekiq workers can't connect to Redis.

- Check for network connectivity to Redis.

```
# SSH on to a machine with the problem
gds govuk connect ssh -e integration backend

# Find the redis connection details
govuk_setenv content-publisher env | grep -i redis

# Try to connect
redis-cli -h backend-redis

# Try a command
keys *
```

[machine metrics]: https://grafana.blue.production.govuk.digital/dashboard/file/machine.json
[rds dash]: https://grafana.production.govuk.digital/dashboard/file/aws-rds.json?orgId=1&var-region=eu-west-1&from=now-3h&to=now
