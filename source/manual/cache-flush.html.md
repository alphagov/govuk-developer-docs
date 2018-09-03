---
owner_slack: "#govuk-2ndline"
title: Purge a page from cache
section: CDN & Caching
layout: manual_layout
parent: "/manual.html"
important: true
last_reviewed_on: 2018-09-03
review_in: 6 months
---


The `www.gov.uk` domain is served through Fastly, which honours the
cache control headers sent by Varnish.

-   Publishing a page at a page previously unseen by Fastly will be
    available immediately.
-   Content published and seen by Fastly may be cached for an hour
    (depending on the Varnish cache headers).
-   Purges are for named URLs only, wildcard purges aren't supported by
    default (though [Fastly do support it if set up in
    advance](https://docs.fastly.com/guides/purging/wildcard-purges))

## Purging a page from Fastly (with Fabric)

The easiest way to purge an item from the cache (cachebust) is to use
[Fabric](https://github.com/alphagov/fabric-scripts/blob/master/cdn.py)
which assumes that our Production infrastructure is working. If it
isn't, then see instructions below regarding purging from a mirror
machine.

This can be used as::

    fab $environment class:cache cdn.purge_all:'/one,/two,/three'

This will purge the page from all our origin cache nodes and the CDN
cache.

Each page that's purged will output 3 kinds of things. First are
responses from each of our origin Varnish nodes confirming the purge:

    $ fab $environment class:cache cdn.purge_all:'/bank-holidays'
    [cache-1.router] run: curl -s -I -X PURGE http://localhost:7999/bank-holidays | grep '200 Purged'
    [cache-1.router] out: HTTP/1.1 200 Purged

    [cache-2.router] run: curl -s -I -X PURGE http://localhost:7999/bank-holidays | grep '200 Purged'
    [cache-2.router] out: HTTP/1.1 200 Purged

    [cache-3.router] run: curl -s -I -X PURGE http://localhost:7999/bank-holidays | grep '200 Purged'
    [cache-3.router] out: HTTP/1.1 200 Purged

Second is a purge from Fastly for `www.gov.uk`:

    [cache-1.router] run: curl -s -X PURGE -H 'Host: www.gov.uk' http://www-gov-uk.map.fastly.net/bank-holidays | grep 'ok'
    [cache-1.router] out: {"status": "ok", "id": "175-1426788291-3713988"}

Third is a purge from Fastly for `assets.publishing.service.gov.uk`:

    [cache-1.router] run: curl -s -X PURGE -H 'Host: assets.publishing.service.gov.uk' http://www-gov-uk.map.fastly.net/bank-holidays | grep 'ok'
    [cache-1.router] out: {"status": "ok", "id": "292-1426787371-4043665"}

We purge from both hostnames as some parts of GOV.UK are available from
both hostnames, and we want to be certain that pages are no longer
cached.

If the `grep` fails on an individual response then the task will exit
early.

You can purge multiple URLs with a single command; in this case all the
Varnish purges will happen before any of the Fastly purges:

    $ fab $environment class:cache cdn.purge_all:'/bank-holidays,/another/url'

## Purging a page from Fastly manually (e.g. if GOV.UK Production is dead)

> **warning**
>
> The following command *must* be run from one of the mirror boxes
>
> :   because we restrict which IP addresses PURGE requests are
>     accepted from.
>
To purge content on the Fastly cache nodes, use the PURGE method against
the URL you wish to purge. For instance:

    curl -XPURGE https://www.gov.uk/bank-holidays

You should receive "ok" returned as a response. If not, you may wish to
request more verbose output using the -i switch:

    curl -i -XPURGE https://www.gov.uk/bank-holidays

You can manually flush the cache from the following machines:

> -   mirror0.mirror.provider1.\$environment.govuk.service.gov.uk
> -   mirror1.mirror.provider1.\$environment.govuk.service.gov.uk

## Purging a page from our origin server varnish cache

Use the Fabric command from
[fabric-scripts](https://github.com/alphagov/fabric-scripts). Note that
you can if necessary specify multiple URLs in one go:

    fab $environment class:cache class:draft_cache cache.purge:'/bank-holidays,/some-other-url'

## Automatic purging on publication

The intention is for the backend to automatically purge Fastly on
publication.

We probably can't do this without requiring authentication for cache
purging.

## Full Edge Flush on Fastly

There are two steps involved in flushing *everything*; our origin (the
cache servers) followed by Fastly.

To flush our origin run the following Fabric command::

    fab $environment class:cache class:draft_cache cache.ban_all

Once this is done move on to Fastly. This can only be done through the
Fastly UI - the credentials are in the 2nd line store. If possible,
speak to a member of the senior tech team before doing this, to
evaluate the risk.

Within the UI you reach the purge all functionality.

-   click "configure"
-   chose the correct service in the service drop down
-   click on the "Purge" drop down
-   click on "Purge All"
