---
owner_slack: "#2ndline"
title: Our content delivery network (CDN)
section: CDN & Caching
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-04-01
review_in: 6 months
---

GOV.UK uses Fastly as a CDN. Citizen users aren't accessing GOV.UK
servers directly, they connect via the CDN. This is better because:

- The CDN "edge nodes" (webservers) are closer to end users. Fastly has
  servers all around the world but our "origin" servers are only in the UK.
- It reduces load on our origin. Fastly uses Varnish to cache responses.

The CDN is responsible for retrying requests against the
[static mirror](/manual/fall-back-to-mirror.html).

![image](images/cdn-mirror-configuration.png)

## CDN configuration

Most of the CDN config is versioned and scripted:

- [Code that uses the Fastly API](https://github.com/alphagov/fastly-configure)
- [Varnish configuration](https://github.com/alphagov/govuk-cdn-config/)
- [Secrets](https://github.com/alphagov/cdn-configs)

These are deployed to [staging][staging_cdn] and [production][production_cdn].
There is no CDN in integration.

Some configuration isn't scripted, such as logging. The www, bouncer and assets
services stream logs to the `logs-cdn-1` box in each environment. bouncer also logs
to `transition-logs-1`. We also log requests for `assets.publishing.service.gov.uk/static/a?`
to S3 for later analysis. These logging endpoints are currently configured directly
in the Fastly UI.

[staging_cdn]: https://deploy.staging.publishing.service.gov.uk/job/Deploy_CDN/
[production_cdn]: https://deploy.publishing.service.gov.uk/job/Deploy_CDN/

## Fastly's IP ranges

Fastly publish their cache node [IP address ranges as JSON from their API][fastly_ips].
We use these IP addresses in 2 places:

- Origin has [firewall rules][] in place so that only our office and Fastly
  can connect.
- Our [Fastly Varnish config][vcl_config] restricts HTTP purges to specific
  IP addresses (otherwise anyone would be able to purge the cache).

[fastly_ips]: https://api.fastly.com/public-ip-list
[firewall rules]: https://github.com/alphagov/govuk-provisioning/blob/master/vcloud-edge_gateway/vars/production_carrenza_vars.yaml
[vcl_config]: https://github.com/alphagov/govuk-cdn-config/

## Banning IP addresses at the CDN edge

We occasionally decide to ban an IP address at our CDN edge if they exhibit
the following behaviour:

- not respecting [our robots.txt directives][robots]
- repeatedly receiving 429 (rate limit) error responses from origin and not
  slowing down
- making suspicious requests like attempting SQL injection queries

[robots]: https://www.gov.uk/robots.txt

Banning IPs shouldn't be taken lightly as IP address can be shared my multiple
user devices and the user behind an IP address can change over time, so there's
always a chance that we may block a legitimate user when we ban IP addresses.

You can change the list of banned IP addresses by modifying the
[YAML config file][ip_ban_config] and [deploying the configuration][ip_ban_deploy].

[ip_ban_config]: https://github.com/alphagov/cdn-configs/blob/master/fastly/dictionaries/config/ip_address_blacklist.yaml
[ip_ban_deploy]: https://deploy.publishing.service.gov.uk/job/Update_CDN_Dictionaries/build

## Bouncer's Fastly service

A Fastly CDN service can normally handle up to 1000 domains (this limit
was undocumented).

We have asked them to increase this limit for Bouncer's service a few
times as the number of domains it handled grew, and the limit is
[currently 3500](https://fastly.zendesk.com/requests/7356). We have
[about 3000 domains](https://transition.publishing.service.gov.uk/hosts)
so shouldn't need to increase it again for a while.

If we reach the limit then the [Jenkins job to update Bouncer's CDN
config](https://deploy.publishing.service.gov.uk/job/Bouncer_CDN/)
should fail and new domains won't be added to the service.

Configuring a new site in Transition generally adds at least 4 domains
to the service, including the `aka` domain for each real domain. For
example:

-   `www.foo.gov.uk`
-   `aka.foo.gov.uk`
-   `foo.gov.uk`
-   `aka-foo.gov.uk`

### New solution for Bouncer and Fastly

Fastly's new solution to get around the domain limit is a
"service pinned map".

They have created a map which we access using
`bouncer-cdn.production.govuk.service.gov.uk`.
Domains that need to be transitioned can `CNAME` to this domain. It
also has 4 IP addresses assigned, which at the time of writing are
the same as the `A` records at that hostname:

- `151.101.2.30`
- `151.101.66.30`
- `151.101.130.30`
- `151.101.194.30`

Domains do not need to be added to the "Production Bouncer" Fastly service
like they used to be.
