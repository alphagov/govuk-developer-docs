---
owner_slack: "#govuk-2ndline-tech"
title: GOV.UK CDN static mirrors
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

# GOV.UK CDN static mirrors

The GOV.UK mirror is a static copy of GOV.UK.

## When is the GOV.UK mirror used?

Most requests to GOV.UK are handled by the [Fastly content delivery network (CDN)](/manual/cdn.html), which sits between the user and [GOV.UK Origin](/manual/architecture-shallow-dive.html#a-user-visits-the-gov-uk-homepage).

When a user requests a GOV.UK page, Fastly retrieves that page from its cache, or fetches the page from GOV.UK Origin if Fastly does not have the page in its cache.

Sometimes, GOV.UK Origin may time out or return a 5xx error response. When that happens, Fastly automatically fetches the page from the GOV.UK mirror instead.

If Fastly goes down, we would manually [switch to AWS CloudFront](/manual/fall-back-to-aws-cloudfront.html) instead of Fastly. Where Fastly makes requests to GOV.UK Origin, AWS CloudFront instead makes all its requests to the GOV.UK mirror.

## GOV.UK mirror locations and access

The GOV.UK mirror is hosted in an [Amazon Web Services (AWS) S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html). The bucket contains copies of GOV.UK HTML files. The mirror is static, meaning dynamic pages such as search pages will not work. S3 will return 403 Forbidden response for non-existent pages instead of 404, because we don't allow the ListBucket permission. This also affects requests for features such as Search, which are not covered by the mirrors.

The term "GOV.UK mirror" actually refers to 3 separate mirrors:

- the main `govuk-<environment>-mirror` S3 bucket in one AWS region
- the `govuk-<environment>-mirror-replica` S3 bucket in another region, so if the first AWS region is down, we can fall back to this other region
- the `govuk-<environment>-mirror` bucket in Google Cloud Storage (GCS), so if AWS overall is down, we can fall back to this mirror

Access to the Amazon S3 buckets is restricted. If you have a Fastly, Office or Pingdom IP address, you have read-only access. If you’re an authenticated AWS web console user, you have read-write access.

Access to the GCS bucket is also restricted. You can access the GCS bucket if you can access the secret keys in `govuk-secrets`, or if you’re an authenticated Google Cloud Platform (GCP) web console user.

## Updates to the GOV.UK mirror

Automatic scripts update the GOV.UK mirror every day.

The [`govuk_seed_crawler`](https://github.com/alphagov/govuk_seed_crawler) is a script on the GOV.UK “mirrorer” machine. Every day at 8:00pm, this script fetches all of the URLs in the [GOV.UK sitemap](https://www.gov.uk/sitemap.xml) and adds them to a [RabbitMQ message queue](/manual/rabbitmq.html).

Then the [`govuk_crawler_worker`](https://github.com/alphagov/govuk_crawler_worker) on the mirrorer machine:

- consumes the fetched GOV.UK URLs from the RabbitMQ message queue
- retrieves the GOV.UK HTML files returned by these URLs
- saves these HTML files to a `/tmp` folder on the mirrorer machine
- adds any new URLs found on those pages to the back of the RabbitMQ message queue

Every hour, the [`govuk_sync_mirror`](https://github.com/alphagov/govuk-puppet/blob/86d1480c6e081313c415246063d5931af24473da/modules/govuk_crawler/manifests/init.pp#L109) script runs on the mirrorer machine. This script copies the GOV.UK HTML files from the mirrorer machine to the main `govuk-<environment>-mirror` AWS S3 bucket. AWS then copies this main bucket to the replica `govuk-<environment>-mirror-replica` S3 bucket in another region.

Finally, a job is run in Google Cloud Storage (GCS) at 6:00pm the day after the original `govuk_seed_crawler`script is run. This job syncs the primary AWS S3 bucket `govuk-<environment>-mirror` to the GCS `govuk-<environment>-mirror` bucket. For more information on GCS, see the [Google Cloud Platform documentation](/manual/google-cloud-platform-gcp.html).

The `govuk_seed_crawler` and `govuk_crawler_worker` scripts are independent of the mirrors. Stopping these scripts stops the mirror updates, but does not stop the mirrors from working.

Run the following to inspect the contents of the GOV.UK mirrorer machine:

```
gds govuk connect -e production ssh mirrorer
cd /mnt/crawler_worker/www.gov.uk
```

## Troubleshooting

If the `govuk_sync_mirror` cronjob has not succeeded for 24 hours, it triggers the ‘Mirror GOV.UK content to S3’ alert. See the [Mirror GOV.UK content to S3 alert documentation](/manual/alerts/mirror-sync.html) for more information.

- This alert **will not** be raised in the event that `govuk_seed_crawler` is broken but `govuk_sync_mirror` is still working.

If the `govuk_seed_crawler` cronjob fails to run:

- The ‘seed_crawler last run status‘ alert should be triggered.
- Files will stop being mirrored to `/mnt/crawler_worker/www.gov.uk` on the `mirrorer` node (this can be checked with `ls -ltr /mnt/crawler_worker/www.gov.uk`).
- The [RabbitMQ dashboard](https://grafana.blue.production.govuk.digital/dashboard/file/rabbitmq.json?refresh=10s&orgId=1) will show fewer jobs (or no jobs at all) being published to the `govuk_crawler_queue` queue.
- [Monitoring for the `cache_public_web_acl` ACL](https://us-east-1.console.aws.amazon.com/wafv2/homev2/web-acl/cache_public_web_acl/d9033e40-69e8-4bbc-a61a-cd3c50254d04/overview?region=eu-west-1) on AWS WAF will show a reduced number of requests to the cache machines (`govuk-infra-cache-requests AllowedRequests`).

## Forcing failover to the GOV.UK mirrors

If Origin is unavailable, Fastly will automatically retry every request against the mirrors.

To avoid Fastly traffic hitting Origin when Origin is down (potentially making the problem worse), we can [fall back to AWS CloudFront](/manual/fall-back-to-aws-cloudfront.html), which serves all content using the GOV.UK mirrors.

Alternatively, we can stop [Nginx](https://www.nginx.com/) on the cache machines, which will prevent requests hitting GOV.UK applications. Fastly will automatically retry these failed requests against the mirror.

SSH into each cache machine (you can increment box number after the colon to hit each one in turn):

```bash
$ gds govuk connect -e production ssh cache:1
```

Stop Nginx to force use of mirrors:

```bash
$ govuk_puppet --test --disable "fail_to_mirror task (by $USER)"
$ sudo service nginx stop
```

When required you can re-enable puppet, which will restart Nginx:

```bash
$ govuk_puppet --test --enable
```

## Emergency publishing content using the GOV.UK mirror

The escalation on-call contact will tell you if you need to make changes to GOV.UK while Origin is unavailable. To do this, you must change content on the GOV.UK mirrors. Because the mirror is static HTML, it's hard to make broad changes to the site, like putting a banner on every page.

1. If you're outside of GDS premises, connect to the [VPN][gds-vpn].

1. SSH to the mirrorer machine:

    ```bash
    gds govuk connect -e production ssh mirrorer
    ```

1. Disable puppet on the machine:

    ```bash
    govuk_puppet --disable "stopping crawling to avoid mirror changes"
    ```

1. Stop the `govuk_crawler_worker` script:

    ```bash
    initctl stop govuk_crawler_worker
    ```

1. Modify the relevant file in the `/mnt/crawler_worker` directory.

1. Upload the file to the AWS S3 bucket using the AWS console.

1. Upload the file to Google Cloud Storage using the GCP console. Credentials are in the `govuk-secrets` password store, under `google-accounts`.

If you're notified that you can revert the change you've made, you can do this by following the same emergency publishing process.

Once Origin becomes available again, update Origin to reflect the change you made on the mirror.

[govuk_crawler_worker]: https://github.com/alphagov/govuk_crawler_worker
[govuk_seed_crawler]: https://github.com/alphagov/govuk_seed_crawler
[govuk_mirror-puppet]: https://github.com/alphagov/govuk_mirror-puppet
[gds-vpn]: https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To/edit
