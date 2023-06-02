---
owner_slack: "#govuk-2ndline-tech"
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

## Further reading

See [Fastly's documentation on purging](https://developer.fastly.com/learning/concepts/purging/).

[senior tech team]: https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-senior-tech-members/members
