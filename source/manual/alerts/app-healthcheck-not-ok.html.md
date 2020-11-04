---
owner_slack: "#govuk-2ndline"
title: App healthcheck not ok
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

Many apps on GOV.UK have a healthcheck endpoint.

- This is usually `/healthcheck` [[1](https://github.com/alphagov/govuk-puppet/blob/2693343ebc1aced7a7f94e8aba31fee8b05df8a5/modules/govuk/manifests/apps/email_alert_api.pp#L166)].
- Some apps just pick a random page [[1](https://github.com/alphagov/govuk-puppet/blob/2693343ebc1aced7a7f94e8aba31fee8b05df8a5/modules/govuk/manifests/apps/collections.pp#L51)].

The alert works by [making a request for the healthcheck endpoint](https://github.com/alphagov/govuk-puppet/blob/fab936cb82be7fad42636fcafca3718a8368ebfe/modules/icinga/files/usr/lib/nagios/plugins/check_json_healthcheck#L155) on the machine where the app is running. If you need to test the healthcheck endpoint manually, you can SSH on to the machine and `curl` it yourself.

```
# SSH on to a machine running Content Publisher
gds govuk connect ssh -e integration backend

# Find the port it's running on
ps -ef | grep content-publisher | grep master

# Do the Icinga check manually
curl localhost:3221/healthcheck
```

Apps with a custom healthcheck endpoint often make use of [the generic checks in govuk_app_config](https://github.com/alphagov/govuk_app_config/blob/master/docs/healthchecks.md). Some apps also implement [custom checks](https://github.com/alphagov/content-publisher/blob/2a6e68e5161cde6f8ee4329deee9a242f6d04668/app/controllers/healthcheck_controller.rb#L8), and the alert should link to custom documentation to explain these.

## Connection Refused Error

This means the app is not accepting requests for the healthcheck endpoint, and is probably down.

- Check [the processes are running](check-process-running.html).
- Try the healthcheck endpoint manually, as above.

## Timeout Error

This means the app is accepting requests, but taking too long to respond (over [20 seconds](https://github.com/alphagov/govuk-puppet/blob/fab936cb82be7fad42636fcafca3718a8368ebfe/modules/icinga/files/usr/lib/nagios/plugins/check_json_healthcheck#L155)).

- Try the healthcheck endpoint manually, as above, to confirm.
- Check the logs e.g. `tail -100f /var/log/email-alert-api/app.err.log`.
- Check for resource issues e.g. on the [Machine dashboard][machine metrics].

## Active Record Check

This means the app is unable to connect to its database.

- Check for [any RDS alerts](/manual/govuk-in-aws.html#postgresql-and-mysql).
- Check the [AWS RDS dashboard][postgres dash] to see if we're experiencing resourcing issues.
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

- Check for any [Redis alerts](redis.html).
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

## Sidekiq Retry Size Check

This means that [Sidekiq][] jobs are failing.

- Check the Sidekiq ['Retry set size'][Sidekiq dash] graph to see if we have a
  high number of failed jobs.
- Are the workers reporting any problems or any issues being raised in [Sentry]?
- Check [Kibana] for Sidekiq error logs (`application: <app> AND @type: sidekiq`).

## Sidekiq Queue Latency Check

This means the time it takes for a [Sidekiq][] job to be processed is unusually high.

- Check the Sidekiq ['Queue Length'][Sidekiq dash] graph to see if we have a
  high number of jobs queued up.
- Check the [Machine dashboard][machine metrics] or the [AWS RDS postgres dashboard][postgres dash] to see if we're experiencing resourcing issues.
- Are the workers reporting any problems or any issues being raised in [Sentry]?
- Check [Kibana] for Sidekiq error logs (`application: <app> AND @type: sidekiq`).

[Sidekiq]: /manual/sidekiq.html
[Sentry]: https://sentry.io/organizations/govuk
[Sidekiq dash]: https://grafana.blue.production.govuk.digital/dashboard/file/sidekiq.json
[Kibana]: https://kibana.logit.io/s/2dd89c13-a0ed-4743-9440-825e2e52329e/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-1h,mode:quick,to:now))&_a=(columns:!('@message',host),index:'*-*',interval:auto,query:(query_string:(query:'@type:%20sidekiq%20AND%20application:%20email-alert-api')),sort:!('@timestamp',desc))
[machine metrics]: https://grafana.blue.production.govuk.digital/dashboard/file/machine.json
[postgres dash]: https://grafana.production.govuk.digital/dashboard/file/aws-rds.json?orgId=1&var-region=eu-west-1&var-dbinstanceidentifier=blue-postgresql-primary&from=now-3h&to=now
