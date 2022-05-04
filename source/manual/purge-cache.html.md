---
owner_slack: "#govuk-2ndline-tech"
title: Purge a page from cache
section: CDN & Caching
layout: manual_layout
parent: "/manual.html"
important: true
---

The `www.gov.uk` domain is served through Fastly, which honours the
cache control headers sent by GOV.UK's running instance of [Varnish][].
Most pages are set with cache headers of 5 minutes, so when new changes
are published it may take 5 minutes for users to see those changes.

[Varnish]: https://varnish-cache.org/

You can check the cache headers of a page with a curl command:

```bash
$ curl -sI https://www.gov.uk/vat-rates | grep "cache-control: \|age: \|x-cache"
age: 107
cache-control: max-age=300, public,private
x-cache: MISS, HIT
x-cache-hits: 1
```

Where:

- `age` is time since the resource was cached
- `cache-control` dictates how long a resource can be cached for
- `x-cache` indicates whether the request was served from a cache (the two
  values are GOV.UK's internal varnish and Fastly CDN - a result of MISS, HIT
  indicates that Fastly CDN was a cache hit, and when Fastly CDN originally
  requested GOV.UK's varnish this was a cache miss),
- `x-cache-hits` is the amount of cache hits on the CDN point of presence.

If an item is seemingly cached longer than expected or needs to be urgently
removed from the cache, you can manually remove it by purging our caches.

## Purging a page from the cache

There is a Jenkins task to clear an item from the Fastly CDN and GOV.UK internal
varnish cache.

If you enter a path (e.g. `/vat-rates`) it will remove the item from both
caches. For resources that are not on `www.gov.uk`, such as assets,
you can enter a full URL (e.g. `https://assets.example.gov.uk/your-path-here`)
and this will remove them from Fastly - these items are not stored in the
GOV.UK internal varnish.

- [Clear CDN cache on Integration](https://deploy.integration.publishing.service.gov.uk/job/clear-cdn-cache/build)
- [Clear CDN cache on Staging](https://deploy.blue.staging.govuk.digital/job/clear-cdn-cache/build)
- [Clear CDN cache on Production](https://deploy.blue.production.govuk.digital/job/clear-cdn-cache/build)

## Purging a page from Fastly manually (e.g. if GOV.UK Production is dead)

To purge content on the Fastly cache nodes, SSH onto a `cache` machine and use the
PURGE method against the URL you wish to purge. For instance:

```sh
$ curl -XPURGE https://www.gov.uk/bank-holidays
```

You should receive `ok` returned as a response. If not, you may wish to request
more verbose output using the `-i` switch:

```sh
$ curl -i -XPURGE https://www.gov.uk/bank-holidays
```

## Full Edge Flush on Fastly

There are two steps involved in flushing *everything*; our origin (the cache
servers) followed by Fastly.

If possible, speak to a member of the senior tech team before doing this, to
evaluate the risk.

To flush our origin, ssh onto each cache and draft_cache box in turn and run
the following command:

```sh
$ sudo varnishadm 'ban req.url ~ .'
```

This invalidates all current cached objects in varnish.
Note that this will not delete existing objects but does present them from being served.
We use it instead of purging because it's more efficient when invalidating a large
number of objects, i.e. all objects.

See: https://www.varnish-cache.org/docs/3.0/tutorial/purging.html

Once this is done move on to Fastly. This can only be done through the Fastly
UI - if you don't have access, speak to a member of the senior tech team.

Within the UI you reach the purge all functionality.

- Click "Configure"
- Choose the correct service in the service drop down
- Click on the "Purge" drop down
- Click on "Purge All"
