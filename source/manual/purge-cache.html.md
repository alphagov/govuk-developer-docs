---
owner_slack: "#govuk-platform-engineering"
title: Purge a page from cache
section: CDN & Caching
layout: manual_layout
parent: "/manual.html"
important: true
---

## Background

[Fastly](https://www.fastly.com/products/cdn) caches HTTP resources such as
HTML pages, images and scripts on `www.gov.uk` and
`assets.publishing.service.gov.uk` based on the [Cache-Control
headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)
that we serve from our origin site. Most pages are cached for 5 minutes, so
when changes are published it may take up to 5 minutes for users to see those
changes.

## Check the cache headers of a page

You can check the cache headers of a page or any other HTTP resource using
[curl](https://curl.se/docs/manpage.html):

```sh
$ curl -sI https://www.gov.uk/vat-rates | grep -Ei 'cache-control|age:|x-cache'
age: 107
cache-control: max-age=300, public,private
x-cache: HIT
x-cache-hits: 1
```

- `age` is time in seconds since the resource was cached
- `cache-control` defines where and when a resource can be cached and for how long
- `x-cache` indicates whether the request was served from cache
- `x-cache-hits` is the number of cache hits at that particular Fastly [point
   of presence](https://developer.fastly.com/learning/concepts/pop/)

## Purge a page from the Fastly CDN

If an item urgently needs to be removed from the cache, you can issue a purge
request.

> If something was published that should not have been published, consider
> whether there has been a notifiable data breach and if so, make sure that
> someone is handling the matter.

1. Log into <https://manage.fastly.com/>. If you don't have an account, ask
   your tech lead or a member of the [senior tech team].
1. Under [All services](https://manage.fastly.com/services/all), choose the
   appropriate service. For example, `Production GOV.UK` for www.gov.uk or
   `Production Assets` for assets.publishing.service.gov.uk.
1. From the "Purge" drop-down button near the top left of the page, choose
   "Purge URL".
1. Enter the full path of the resource to purge (that is, everything after the
   hostname in the URL) and choose Purge.

## Purging all objects from the Fastly CDN

If possible, check with a member of the [senior tech team] before doing this in
production.

1. Log into <https://manage.fastly.com/>.
1. Under [All services](https://manage.fastly.com/services/all), choose the
   appropriate service. For example, `Production GOV.UK` for www.gov.uk or
   `Production Assets` for assets.publishing.service.gov.uk.
1. From the "Purge" drop-down button near the top left of the page, choose
   "Purge all".
1. The UI will ask you for confirmation before issuing the purge request.

## Purge a page from the standby CloudFront CDN

In addition to our primary CDN (Fastly), we also have a standby CDN set up on
CloudFront. This standby CDN is only intended to be used during a Fastly
outage, so there's a limited number of situations in which you would need to
purge its cache.

If an item urgently needs to be removed from the cache, you can create an
invalidation from the AWS console.

1. Log into the AWS console with `gds aws govuk-production-developer -l`.
1. Under the [CloudFront distributions page](https://us-east-1.console.aws.amazon.com/cloudfront/v4/home?region=eu-west-1#/distributions),
   choose the appropriate distribution: `WWW` for www.gov.uk or `Assets` for assets.publishing.service.gov.uk.
1. Select the "Invalidations" tab, and click "Create invalidation".
1. Enter the full paths of all resources to purge (that is, everything after
   the hostname in the URL). You can optionally use wildcards (`*`). To purge
   all objects, enter the path `/*`.
1. Click "Create invalidation".

## Further reading

See [Fastly's documentation on purging](https://developer.fastly.com/learning/concepts/purging/).

[senior tech team]: /manual/ask-for-help.html#contact-senior-tech
