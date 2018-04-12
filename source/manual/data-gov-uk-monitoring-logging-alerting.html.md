---
owner_slack: "#datagovuk-tech"
title: Monitoring, Logging and Alerting
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-04-30
review_in: 3 months
---
[publish]: apps/datagovuk_find
[find]: apps/datagovuk_find
[paas]: https://docs.cloud.service.gov.uk/#technical-documentation-for-gov-uk-paas
[infrastructure]: https://github.com/alphagov/datagovuk_infrastructure

## Metric Exporter

The metric-exporter [metric PaaS app](https://docs.cloud.service.gov.uk/#setting-up-the-metrics-exporter-app) sends data to an [AWS instance running graphite](http://ec2-52-211-85-194.eu-west-1.compute.amazonaws.com/dashboard/Find#Find) (details on the AWS EC2 console). The username and password are found in the environment variables of the app.

To install graphite on an AWS instance:

1. Open incoming ports 80 and 8125/UDP
2. Install docker and docker-graphite-statsd, then set the `STATSD_ENDPOINT` variable on metric-exporter to `xx.yy.zz.dd:8125`.
3. If username and passwords are set correctly, the web interface should show that data is coming in. If not, ssh on the box and run `sudo ngrep -d any -W byline port 8125`.

To monitor Redis metrics, we use [redis-statsd](https://github.com/zapier/redis-statsd) (just the script, not the container) running on the graphite instance.

## Prometheus

We are currently in the process of switching to Prometheus as provided by Reliability Engineering.  We have a folder in [Grafana](https://grafana-paas.cloudapps.digital/) which you can sign in to with your GDS email.  This works by the ‘dgu-prometheus’ service in PaaS scraping the `/metrics` endpoint for our apps.

If you wish to see which metrics are available, you can use the following command to see what a specific app publishes:
`curl -H "Authorization: Bearer $(cf app find-data-beta --guid)"`

## Pingdom

## Smoke tests

## Log.it
