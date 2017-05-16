---
owner_slack: "#2ndline"
title: Purge a page from cache
section: CDN & Caching
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/cache-flush.md"
important: true
last_reviewed_on: 2017-01-08
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.com/alphagov/govuk-legacy-opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.com/alphagov/govuk-legacy-opsmanual/tree/master/2nd-line/cache-flush.md)


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

    fab $environment cdn.purge_all:'/one,/two,/three'

This will purge the page from all our origin cache nodes and the CDN
cache.

Each page that's purged will output 3 kinds of things. First are
responses from each of our origin Varnish nodes confirming the purge:

    $ fab $environment cdn.purge_all:'/bank-holidays'
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

    $ fab $environment cdn.purge_all:'/bank-holidays,/another/url'

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

    fab $environment cache.purge:'/bank-holidays,/some-other-url'

## Automatic purging on publication

The intention is for the backend to automatically purge Fastly on
publication.

We probably can't do this without requiring authentication for cache
purging.

## Full Edge Flush on Fastly

There are two steps involved in flushing *everything*; our origin (the
cache servers) followed by Fastly.

To flush our origin run the following Fabric command::

    fab $environment cache.ban_all

Once this is done move on to Fastly. If you need to do this please speak
to the on-call escalation person and they will evaluate the risk and
guide you through the required contacts who can action this. Access to
the Fastly UI is limited to the infrastructure team, and a few senior
technical staff. There is currently no way to do it via the command
line.

Within the UI you reach the purge all functionality.

-   click "configure"
-   chose the correct service in the service drop down
-   click on the "Purge" drop down
-   click on "Purge All"
