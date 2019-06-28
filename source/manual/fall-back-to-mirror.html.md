---
title: Fall back to the static mirrors
section: Deployment
layout: manual_layout
parent: "/manual.html"
owner_slack: "#govuk-2ndline"
last_reviewed_on: 2019-06-28
review_in: 6 months
---

We maintain a static copy of most of the site, which gets used by the content delivery
network (CDN) whenever origin (the application server) times out or serves an error
response.

This process is handled by our CDN config and is entirely transparent to us and
our users. It happens multiple times a day, for lots of different reasons.

This is why we refer to switching off Nginx on the origin cache machines as
"falling back to the mirrors".

## Viewing

Mirror sites can be viewed and navigated at:
- Amazon S3 bucket `govuk-<environment>-mirror`,
  also replicated to `govuk-<environment>-mirror-replica` S3 bucket in another AWS region
- Google GCS bucket `govuk-<environment>-mirror`

## Access

Access to the:
1. S3 buckets are restricted to Fastly, Office and Pingdom IP addresses for read-only Access
   and AWS authenticated users in AWS web console
2. Google GCS buckets are restricted by secret keys in govuk-secrets and GDS authenticated users
   in Google GCP web console

## Hosting

We currently support two types of mirror backends:
- Amazon S3: the static mirror is hosted in a bucket and the content is retrieved via API
- Google GCS: the static mirror is hosted in a bucket and the content is retrieved via API

## Updates to the mirror

Every day at 20 00, the [govuk_seed_crawler][] on the Mirrorer machine adds hundreds of thousands of GOV.UK
URLs to a message queue. The [govuk_crawler_worker][] on the Mirrorer machine consumes these URLs,
saves them to disk and adds any new URLs found on those pages to the back of the queue.

Every hour, the static copy of the site is copied from the Mirrorer machine to the primary AWS S3 bucket
`govuk-<environment>-mirror`. This primary bucket is automatically replicated to another S3 bucket
(named `govuk-<environment>-mirror-replica`) in another region by AWS.

In addition, the primary AWS S3 bucket `govuk-<environment>-mirror` is synced to the Google GCS bucket
of the same name daily at 12 00.

The crawler is entirely independent of the mirrors. Stopping the crawler means
no new updates are made to the mirrors, but it will not stop the mirrors from working.

To inspect the contents of the mirror:
```
ssh <mirrorer_machine_name>
cd /mnt/crawler_worker/www.gov.uk
```
where `<mirrorer_machine_name>` can be obtained from the `govuk_node_list -c mirrorer` command
on the jumpbox.

## Forcing failover to the static mirrors

Because the CDN will retry every request against the mirrors automatically if origin
is unavailable, all you need to do is [stop Nginx on the cache machines with Fabric][fab-fail]:

```bash
$ fab $environment class:cache incident.fail_to_mirror
```

to disable to fallback:

```bash
$ fab $environment class:cache incident.recover_origin
```

[fab-fail]: https://github.com/alphagov/fabric-scripts/blob/master/incident.py

## Emergency publishing using the static mirror

If you need to make changes to the site while origin is unavailable, you'll have to
modify content on the static mirrors. Bear in mind that because the mirror is static
HTML, it's hard to make broad changes to the site (like putting a banner on every page).

You'll be notified by the escalation on-call contact that you need to edit the site.

1. If you're at home, connect to the [VPN][gds-vpn]
2. ssh the Mirrorer machine by running:
    ```
    ssh <mirrorer_machine_name>
    ```
    where `<mirrorer_machine_name>` can be obtained from the `govuk_node_list -c mirrorer` command
    on the jumpbox.
3. disable puppet on the machine by running:
   ```
   govuk_puppet --disable "stopping crawling to avoid mirror changes"
   ```
4. stop the govuk_crawler_worker by running:
   ```
   initctl stop govuk_crawler_worker
   ```
5. Modify the relevant file in the directory `/mnt/crawler_worker`
6. Upload the file to the S3 mirror via AWS console or command line

If you're notified that the edit you've made can be reverted, do that the same way.

Once origin becomes available again, somebody (maybe you) will have to ensure that
origin has been updated to serve the change that you made.

[govuk_crawler_worker]: https://github.com/alphagov/govuk_crawler_worker
[govuk_seed_crawler]: https://github.com/alphagov/govuk_seed_crawler
[govuk_mirror-puppet]: https://github.com/alphagov/govuk_mirror-puppet
[govuk_mirror-deployment]: https://github.com/alphagov/govuk_mirror-deployment
[gds-vpn]: https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-the-white-chapel-building/how-to/how-to/connect-to-the-aviation-house-vpn
