---
title: Fall back to the static mirrors
section: Deployment
layout: manual_layout
parent: "/manual.html"
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2018-05-17
review_in: 3 months
---

We maintain a static copy of most of the site, which gets used by the content delivery
network (CDN) whenever origin (the application server) times out or serves an error
response.

This process is handled by our CDN config and is entirely transparent to us and
our users. It happens multiple times a day, for lots of different reasons. The
`govuk-cdn-logs-monitor` app outputs [stats showing if the mirrors are active][graphite_cdn_backend].

This is why we refer to switching off Nginx on the origin cache machines as
"falling back to the mirrors".

## Viewing

Mirror sites can be viewed and navigated at:

- [Carrenza](https://www-origin.mirror.provider1.production.govuk.service.gov.uk/) (`https://www-origin.mirror.provider1.production.govuk.service.gov.uk/`)
- Amazon S3 bucket `govuk-mirror-<environment>`

## Access

To gain SSH access to the mirrors in Carrenza, please see the following repositories:

 - [govuk_mirror-puppet][]
 - [govuk_mirror-deployment][]

To gain console access to the mirrors in Carrenza, please use the credentials from the [password store](https://github.com/alphagov/govuk-secrets/tree/master/pass).

Access to the S3 mirror is restricted to Fastly IP addresses (read-only) and AWS authenticated users.

## Hosting

We currently support two types of mirror backends:

- VCloud: the static mirror is hosted as two pairs of machines running a webserver. This is
hosted with Carrenza.

- Amazon S3: the static mirror is hosted in a bucket and the content is retrieved via API

## Updates to the mirror

The mirror is updated constantly by the `mirrorer-1.management` machine.

Every day, the [govuk_seed_crawler][] adds hundreds of thousands of GOV.UK
URLs to a message queue. The [govuk_crawler_worker][] consumes these URLs, saves them to
disk and adds any new URLs found on those pages to the back of the queue.

Every hour, the static copy of the site is copied from the mirrorer machine to each
of the mirror machines.

The crawler is entirely independent of the mirrors. Stopping the crawler means
no new updates are made to the mirrors, but it will not stop the mirrors from working.

To inspect the contents of the mirror:

```
ssh mirrorer-1.management.production
cd /mnt/crawler_worker/www.gov.uk
```

## Forcing failover to the static mirrors

Because the CDN will retry every request against the mirrors automatically if origin
is unavailable, all you need to do is [stop Nginx on the cache machines with Fabric][fab-fail]:

```
fab $environment class:cache incident.fail_to_mirror
```

[fab-fail]: https://github.com/alphagov/fabric-scripts/blob/master/incident.py

## Emergency publishing using the static mirror

If you need to make changes to the site while origin is unavailable, you'll have to
modify content on the static mirrors. Bear in mind that because the mirror is static
HTML, it's hard to make broad changes to the site (like putting a banner on every page).

You'll be notified by the escalation on-call contact that you need to edit the site.

1. If you're at home, connect to the [VPN][gds-vpn]
2. Download a copy of the file you want to edit using [govuk_mirror-deployment][]:

        $ fab $environment get_file:path-to-file.html

3. Edit the file in `tmp/path-to-file.html` on your machine
4. Put the file back to VCloud mirror:

        $ fab $environment put_file:path-to-file.html

5. Upload the file to the S3 mirror via AWS console or command line

Your manual changes to the mirror might be overwritten by the hourly copy from the
mirrorer machine. You might need to ensure that the copy doesn't happen.

If you're notified that the edit you've made can be reverted, do that the same way.

Once origin becomes available again, somebody (maybe you) will have to ensure that
origin has been updated to serve the change that you made.

[graphite_cdn_backend]: https://graphite.publishing.service.gov.uk/render?from=-1months&until=now&width=800&height=600&target=stats.govuk.app.govuk-cdn-logs-monitor.logs-cdn-1.cdn_backend.mirror1&target=stats.govuk.app.govuk-cdn-logs-monitor.logs-cdn-1.cdn_backend.mirror0
[govuk_crawler_worker]: https://github.com/alphagov/govuk_crawler_worker
[govuk_seed_crawler]: https://github.com/alphagov/govuk_seed_crawler
[govuk_mirror-puppet]: https://github.com/alphagov/govuk_mirror-puppet
[govuk_mirror-deployment]: https://github.com/alphagov/govuk_mirror-deployment
[gds-vpn]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-the-white-chapel-building/how-to/how-to/connect-to-the-aviation-house-vpn
