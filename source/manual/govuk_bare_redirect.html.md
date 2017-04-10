---
title: GOV.UK Bare Redirect
section: infrastructure
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/govuk_bare_redirect.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/govuk_bare_redirect.md)


# GOV.UK Bare Redirect

## Purpose

Respond to requests for `http://gov.uk` and `https://gov.uk` with an
HTTP 301 redirect to `https://www.gov.uk`. The path and query parameters
of the original request must be preserved in the redirect target. It is
equivalent to the following in Nginx:

    return 301 https://www.gov.uk$request_uri;

This is necessary because the `www` prefix is often omitted in:

-   our GOV.UK branding
-   people typing URLs by hand
-   link shorterners (even if only for display)

## Complications

The service must be fronted by a CDN, like `www.gov.uk`, so that our own
infrastructure doesn't become the target of a DDoS attack.

CDNs normally require you to use a `CNAME` record to point your traffic
at them, so that they can use Global Server Load Balancers and retain
the freedom of changing their IP addresses without asking you.

However [RFC 1034](https://tools.ietf.org/html/rfc1034#section-3.6.2)
states that `CNAME` records cannot exist at a node that has other record
types and `gov.uk` is the zone apex which always has `SOA` and `NS`
records.

## Setup

Our CDN provider (Fastly at the time of writing) has set up the
following for us:

-   a service which responds with the 301 redirect without needing us to
    provide an origin server behind it
-   several [AnyCast](http://en.wikipedia.org/wiki/Anycast) IP addresses
    which aren't specific to a single point-of-presence and have been
    added as round-robin `A` records


