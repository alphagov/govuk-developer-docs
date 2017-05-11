---
owner_slack: '#navigation'
review_by: 2017-07-26
title: Transition a site to GOV.UK
section: Transition
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/howto-transition-a-site-to-govuk.md"
last_reviewed_on: 2017-01-26
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.com/alphagov/govuk-legacy-opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.com/alphagov/govuk-legacy-opsmanual/tree/master/2nd-line/howto-transition-a-site-to-govuk.md)


When a site is going to move to GOV.UK, there are broadly two ways that
the old site can be redirected. They can do it themselves, or they can
repoint the domain at us. This page is about the latter.

The [Transition](https://github.com/alphagov/transition) app exists to
allow editing of mapping of Old URLs to pages on GOV.UK. These mappings
are stored in a database and used by
[Bouncer](https://github.com/alphagov/bouncer) to handle requests to
those old domains.

This page covers the details of adding a site so that we can handle
traffic to it.

## Adding the site to the Transition app

Follow the instructions in the [transition-config
README](https://github.com/alphagov/transition-config/blob/master/README.md).

## Next steps

A product/project management orientated overview of this needs to
created, but here is an overview from a technical perspective in the
mean time.

### 1) Getting a list of old URLs

In order for us to redirect anything but the homepage, we need a list of
URLs for the old site so that they can be mapped. In the past, this is
something GDS did for the organisation as it requires a fair bit of
technical skill and experience.

Getting traffic logs from a transitioning organisation is the best
option, as we can get a list of URLs we know are actively used. If we
can't get this then there are other options.

One option is to get a list of the URLs from the Internet Archive. The
[archive\_lister](https://github.com/rgarner/archive_lister) gem can do
this for you. Sometimes the Internet Archive doesn't have any data, so
try the domain name with `http` or `https`, or with/without the `www.`.
Sometimes it still won't have any data.

An alternative would be to crawl the site with a crawler like
[Anemone](https://github.com/chriskite/anemone), though for a large site
this might take several hours. With Anemone running this will give you a
list of URLs for a domain:

    $ anemone url-list 'transitioning-site.gov.uk'

Note: This will include 404s, 301s, etc.

### 2) Cleaning up URLs

**Strip paths and pattern**

There are lots of file formats we don't want to provide mappings for,
like static assets, images, or common spammy/malicious crawlers. These
can be stripped with using the
[strip\_mappings.sh](https://github.com/alphagov/transition-config/blob/master/tools/strip_mappings.sh)
script.

**Query parameter analysis**

From your set of URLs, you can attempt to identify significant
querystring parameter names and then add them to the site configuration
file in transition-config. A querystring parameter is considered
significant if it significantly changes the content seen on the old site
and/or it would be mapped to a different new URL.

There are some transition-config scripts to help analyse query param
usage:

-   [analyse\_query\_params.sh](https://github.com/alphagov/transition-config/blob/master/tools/analyse_query_params.sh)
-   [analyse\_query\_usage.sh](https://github.com/alphagov/transition-config/blob/master/tools/analyse_query_usage.sh)

Some common examples of significant parameters:

-   article ID
-   attachment ID
-   document ID

Some common examples of non-significant parameters:

-   pagination
-   Analytics
-   search queries

### 3) Adding the old URLs as mappings

Ideally, any significant querystring parameters should be identified and
added to the site before adding the mappings. This is because URLs are
canonicalised and then deduplicated before being saved and part of
canonicalisation is to remove non-significant parameters. However,
significant querystring parameters can be added later; after they have
been imported adding old URLs which include the parameters will be
canonicalised using the new list of significant parameters. There is a
slight gotcha that mappings created under the previous list won't be
removed and in some (complicated) situations won't be used by Bouncer.

To add/edit mappings, you will need the "GDS Editor" permission in
GOV.UK Signon for the Transition app. This lets you edit any site,
rather than just ones belonging to your organisation. You can then go
the [transition app](https://transition.publishing.service.gov.uk), find
the site and click `Add mappings` to add them in bulk.

### 4) Get the organisation to do the mapping work

By default, the mappings will present an archive page to users visiting
the old URL. The objective is to get users to somewhere that best serves
the need fulfilled by the old page. Usually this means redirecting them
to the page on GOV.UK or elsewhere. It is really important that this is
done by people who understand the users and content.

### 5) Get the organisation to lower the TTL on the DNS records a day ahead

In order to cleanly switch the domain from the old site, the TTL needs
to be low enough that there isn't a significant period where some users
will get the old site and some get the new one. This is important for
several reasons, including user experience and giving a professional
impression to stakeholders. We normally ask for this to be done a day in
advance, and to be lowered to 300 seconds (5 minutes). It can be raised
again once everyone is happy there is no need to switch back - normally
the day after.

### 6) Pointing the domain at us

Once the site has been imported successfully, the domain can be pointed
at us by the organisation. For hostnames which can have a `CNAME`
record, this is `redirector-cdn.production.govuk.service.gov.uk`.
Domains at the root of their zone can't be CNAMEd, so must use an `A`
record and point at one of the [Fastly GOV.UK IP
addresses](https://github.com/alphagov/transition/blob/master/app/models/host.rb#L18).

### 7) Get the organisation to monitor the traffic data in the Transition app

There are two things that need to be responded to:

-   high numbers of 404s - this means a mapping is missing
-   high numbers hitting 410s - this means the old page is popular and
    should perhaps be redirected instead

## Checklist

The transition checklist covers the whole process of transitioning a site from the technical side. There’s a [full version for complex sites](https://docs.google.com/document/d/1SiBwYtV_d_D9pPcqzpqvRWs0kscUtB7yqxN8Ub_uRSA/edit) and a [slightly simplified one](https://docs.google.com/document/d/1gIJBUuPaZqtYsrgwqMBSrU4lpr2e93tuhQcgylnSHb4/edit) - we probably only need the simpler one for upcoming transitions.
