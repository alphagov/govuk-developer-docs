---
owner_slack: "#govuk-developers"
title: Our content delivery network (CDN)
section: CDN & Caching
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK uses Fastly as a CDN. Public users aren't accessing GOV.UK servers directly, they connect via the CDN. This is better because:

- The CDN "edge nodes" (webservers) are closer to end users. Fastly has servers all around the world but our "origin" servers are only in the AWS eu-west-1 region (Ireland).
- It reduces load on our origin. Fastly uses Varnish to cache responses.

The CDN is responsible for retrying requests against the [static mirror](/manual/fall-back-to-mirror.html).

![image](images/cdn-mirror-configuration.png)

## CDN configuration

Most of the CDN config is versioned and scripted:

- [govuk-cdn-config](https://github.com/alphagov/govuk-cdn-config/)
- [govuk-cdn-config-secrets](https://github.com/alphagov/govuk-cdn-config-secrets)

Some configuration isn't scripted, such as logging. The www, bouncer and assets services send logs to S3 which can be [queried](/manual/query-cdn-logs.html). These logging endpoints are configured directly in the Fastly UI.

### Deploying Fastly

To deploy Fastly, you'll need to run the `Deploy_CDN` job on the relevant Jenkins environment: [integration][integration_cdn], [staging][staging_cdn] or [production][production_cdn]. This job deploys the public and secret CDN configuration referenced above.

Note that there are two configurations: one for `www` and one for `assets`.
Choose the correct `vhost` for the configuration you'd like to deploy.

You'll need to provide a `FASTLY_API_KEY`. To do this:

1. Log into your Fastly account.
1. Click on "Account", under your name in the top right corner.
1. Click "[Personal API tokens](https://manage.fastly.com/account/personal/tokens)"
1. Click "Create Token"

Then follow the steps to create a token with the minimum privileges required for the task at hand:

1. The token name is unimportant; you'll be deleting it shortly.
1. For "Service Access", choose the service you'll be deploying,
   e.g. "Integration GOV.UK" (for `www`) or "Integration Assets" (for `assets`).
1. For "Scope", you'll need to pick "Global API access" (i.e. the most permissive)
1. Under "Expiration", choose tomorrow's date
1. Click "Create Token"

You can now copy and paste the token into the `FASTLY_API_KEY` in the Jenkins job.
Once you've run the job successfully, you can delete the token.

[integration_cdn]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_CDN/
[staging_cdn]: https://deploy.blue.staging.govuk.digital/job/Deploy_CDN/
[production_cdn]: https://deploy.blue.production.govuk.digital/job/Deploy_CDN/

## Fastly Caching

The main www.gov.uk cache is [Varnish](https://varnish-cache.org/docs/2.1/index.html), which Fastly runs for us.

Varnish lets us configure our caching logic with VCL (Varnish config language).

It also lets us do fancy things, like [only allowing connections to staging from permitted IPs](https://github.com/alphagov/govuk-cdn-config/blob/f6cf15e9155f7c2ea89970741d3e03851a00013d/vcl_templates/www.vcl.erb#L202), [forcing SSL](https://github.com/alphagov/govuk-cdn-config/blob/f6cf15e9155f7c2ea89970741d3e03851a00013d/vcl_templates/www.vcl.erb#L222) and [blocking IP addresses](https://github.com/alphagov/govuk-cdn-config/blob/f6cf15e9155f7c2ea89970741d3e03851a00013d/vcl_templates/www.vcl.erb#L208), among other things.

We set a default TTL of 3600s on cached objects. This means that pages such as the GOV.UK homepage will be cached for 1 hour. 5XX responses get cached for 1s; mirror responses get cached for 15 minutes.

We also set a grace period of 24 hours. So if the homepage server is down, we'll continue to serve a stale homepage for 24 hours.

These are the GET request status codes that Varnish caches automatically: 200, 203, 300, 301, 302, 404 or 410. (See the [Varnish docs](https://varnish-cache.org/docs/2.1/reference/vcl.html#variables) for more detail.)

We have added to these - see the [GOV.UK CDN Config repo](https://github.com/alphagov/govuk-cdn-config/) VCL for [special handling of certain status codes](https://github.com/alphagov/govuk-cdn-config/blob/c37856f5cb463d204ef3926828f35204721eb7e9/vcl_templates/www.vcl.erb#L408-L416), and for the most up-to-date version of what we're running in Fastly. Refer to the Varnish 2.1 documentation when looking at the VCL code.

### Conditional request caching

Fastly will cache HTTP responses that include cache validation headers (such as ETag or Last-Modified) indefinitely. GOV.UK typically serves these headers with [assets uploaded to Asset Manager](/manual/assets.html#uploaded-assets).

When Fastly has a conditional response cached it will modify subsequent requests that it passes to origin to include [conditional HTTP headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Conditional_requests#conditional_headers). This allows origin applications to return a 304 Not Modified status code to indicate the resource is unchanged and avoid an unnecessary data transfer. As Fastly, not the end user, has the resource cached a 304 response will need to be modified by Fastly into a 200 response with the cached resource attached.

If we mistakenly serve invalid responses with cache validation headers we will need to change the validation headers or manually [purge the resource from the Fastly cache](/manual/purge-cache.html), otherwise the incorrect resource could be served for a long time.

### Testing VCL

VCL can be tricky to get right. When making changes to the VCL, add smoke tests [to smokey](https://github.com/alphagov/smokey/blob/master/features/caching.feature) and check that they don't fail in staging.

You can also use Fastly's [Fiddle tool](https://fiddle.fastlydemo.net/) to manually test, and you can also test your changes with cURL by including a debug header:

```sh
$ curl -svo /dev/null -H "Fastly-Debug: 1" https://www.gov.uk/
```

This will give you various debugging headers that may be useful:

```
< Fastly-Debug-Path: <nodes you hit>
< Fastly-Debug-TTL: <nodes with TTL>
< Fastly-Debug-Digest: <hash>
< X-Served-By: <node that responded>
< X-Cache: HIT, HIT
< X-Cache-Hits: 1
< X-Timer: <time it took>
< Vary: Accept-Encoding, Accept-Encoding
```

See the Varnish/Fastly docs for what these mean. Check out the Fastly [debugging guide](https://docs.fastly.com/guides/debugging/checking-cache#using-curl) for more details on testing.

## Access controls on cache clearing

Our [Fastly Varnish config][vcl_config] restricts HTTP purges to specific IP addresses (otherwise anyone would be able to purge the cache).

[vcl_config]: https://github.com/alphagov/govuk-cdn-config/

## Fastly's IP ranges and our access controls on origin servers

Fastly publish their cache node [IP address ranges as JSON from their API][fastly_ips]. We use these IP addresses in two places:

- Origin has firewall rules in place so that only our office and Fastly can connect. This is updated automatically using the [Fastly Terraform provider](https://registry.terraform.io/providers/fastly/fastly/latest/docs) when the [infra-security-groups](https://github.com/alphagov/govuk-aws/tree/master/terraform/projects/infra-security-groups) module is deployed. Triggering the deployment is still a manual step though.

[fastly_ips]: https://api.fastly.com/public-ip-list

## Banning IP addresses at the CDN edge

We occasionally decide to ban an IP address at our CDN edge if they exhibit the following behaviour:

- not respecting [our robots.txt directives][robots]
- repeatedly receiving 429 (rate limit) error responses from origin and not slowing down
- making suspicious requests like attempting SQL injection queries

[robots]: https://www.gov.uk/robots.txt

Banning IPs shouldn't be taken lightly because many users can share the same IP address and the user behind an IP address can change over time, so there's always a chance that we may block legitimate users.

You can change the list of banned IP addresses by modifying the [YAML config file][ip_ban_config] and [deploying the configuration][ip_ban_deploy].

[ip_ban_config]: https://github.com/alphagov/govuk-cdn-config-secrets/blob/master/fastly/dictionaries/config/ip_address_denylist.yaml
[ip_ban_deploy]: https://deploy.blue.production.govuk.digital/job/Update_CDN_Dictionaries/build

## Blocking problematic traffic at the CDN edge

As well as blocking based on source IP address, we can also block abusive traffic based on headers, URL paths or any arbitrary criteria about the request that we can specify using VCL. This requires care and testing, but can be nonetheless a valueable incident response tool for mitigating DoS and spam attacks.

We have a mechanism for including VCL code from the private `govuk-cdn-config-secrets` repo into the Fastly config, so that mitigations we make during an attack are not published to the public repo for the attacker to see and work around. An example of this is [alphagov/govuk-cdn-secrets#133](https://github.com/alphagov/govuk-cdn-config-secrets/pull/133/files).

## Bouncer's Fastly service

A Fastly CDN service can normally handle up to 1000 domains - this limit is currently undocumented.

We have asked them to increase this limit for Bouncer's service a few times as the number of domains it handled grew, and the limit is [currently 3500](https://fastly.zendesk.com/requests/7356). We have [about 2000 domains](https://transition.publishing.service.gov.uk/hosts) so shouldn't need to increase it again for a while.

If we reach the limit then the [Jenkins job to update Bouncer's CDN config](https://deploy.blue.production.govuk.digital/job/Bouncer_CDN/) should fail and new domains won't be added to the service.

Configuring a new site in Transition generally adds at least 4 domains to the service, including the `aka` domain for each real domain. For example:

- `www.foo.gov.uk`
- `aka.foo.gov.uk`
- `foo.gov.uk`
- `aka-foo.gov.uk`

### New solution for Bouncer and Fastly

Fastly's new solution to get around the domain limit is a "service pinned map".

They have created a map which we access using `bouncer-cdn.production.govuk.service.gov.uk`. Domains that need to be transitioned can `CNAME` to this domain. It also has 4 IP addresses assigned, which at the time of writing are the same as the `A` records at that hostname:

- `151.101.2.30`
- `151.101.66.30`
- `151.101.130.30`
- `151.101.194.30`

Domains do not need to be added to the "Production Bouncer" Fastly service like they used to be.
