---
owner_slack: "#govuk-platform-health"
title: Transition a site to GOV.UK
section: Transition
layout: manual_layout
parent: "/manual.html"
related_applications: [bouncer, transition]
---

When a site is going to move to GOV.UK, there are two ways that the old site
can be redirected. They can do it themselves, or they can repoint the domain at
us. This page is about the latter.

The [Transition][] app exists to allow editing of mapping of old URLs to pages
on GOV.UK. These mappings are stored in a database and used by [Bouncer][] to
handle requests to those old domains.

This page covers adding a site so that we can handle traffic to
it, or changing the configuration of an existing site in the Transition app.

## Changing the configuration of a site that is already in the Transition app

The [transition-config README][transition-config] gives more details on how to
edit the relevant [transition configuration file].

[transition configuration file]: https://github.com/alphagov/transition-config/tree/master/data/transition-sites

## Checklist for transitioning a new site

### 1) Ensure the department is aware of the technical limitation of HTTPS enabled sites

Unless the domain being transitioned is a subdomain of one of our wildcard
[SANs][], we [do not support HTTPS][https] for transitioned sites.

[SANs]: https://en.wikipedia.org/wiki/Subject_Alternative_Name
[https]: /manual/transition-architecture.html#https-support-for-transitioned-sites

If a domain is not in our SAN but wants to keep HTTPS integrity, the best
alternative is to set up redirects on their own server.

The content team might ask a developer to offer the department some guidance
around this.

### 2) Add a site to the Transition app

Follow the instructions in the [transition-config README][transition-config].

### 3) Consider AKA domains

If the department want to use the side-by-side browser to preview how their
redirects will appear after transitioning they will need to set up AKA domains.

They will need one new CNAME DNS entry for each domain/subdomain they wish to
preview according to the following pattern:

- www.domain.gov.uk → aka.domain.gov.uk
- sub.domain.gov.uk → aka-sub.domain.gov.uk

There are lots of examples of these in [hosts currently configured in
Transition][transition-hosts].

These AKA domains should be CNAMEd to: `bouncer-cdn.production.govuk.service.gov.uk`

Previously we used a `redirector-cdn` address which reached its capacity and will now fail if added as the
CNAME record for any new domains.

[transition-hosts]: https://transition.publishing.service.gov.uk/hosts

### 4) Get a list of old URLs

In order for us to redirect anything but the homepage, we need a list of URLs
for the old site so that they can be mapped. In the past, this is something
GDS did for the organisation as it requires some technical skill and
experience.

Getting traffic logs from a transitioning organisation is the best option, as
we can get a list of URLs we know are actively used. If we can't get this then
there are other options.

One option is to get a list of the URLs from the Internet Archive. The
[archive_lister](https://github.com/rgarner/archive_lister) gem can do this for
you. Sometimes the Internet Archive doesn't have any data, so try the domain
name with `http` or `https`, or with and without the `www.`.

An alternative is to crawl the site with a crawler like
[Anemone](https://github.com/chriskite/anemone), though for a large site this
might take several hours. This will give you a list of URLs for a domain:

```sh
$ anemone url-list 'transitioning-site.gov.uk'
```

> **Note:** This will include 404s, 301s, etc.

### 5) Clean up URLs

#### Strip paths and pattern

There are lots of file formats we don't want to provide mappings for, like
static assets, images, or common spammy/malicious crawlers. These can be
stripped using the [strip_mappings.sh][smsh] script.

[smsh]: https://github.com/alphagov/transition-config/blob/master/tools/strip_mappings.sh

#### Query parameter analysis

From your set of URLs, you can attempt to identify significant query string
parameter names and then add them to the site configuration file in
`transition-config`. A query string parameter is considered significant if it
significantly changes the content seen on the old site and/or it would be
mapped to a different new URL.

There are some transition-config scripts to help analyse query param usage:

- [analyse_query_params.sh](https://github.com/alphagov/transition-config/blob/master/tools/analyse_query_params.sh)
- [analyse_query_usage.sh](https://github.com/alphagov/transition-config/blob/master/tools/analyse_query_usage.sh)

Some common examples of significant parameters:

- article ID
- attachment ID
- document ID

Some common examples of non-significant parameters:

- pagination
- analytics
- search queries

### 6) Add the old URLs as mappings

Ideally, any significant query string parameters should be identified and
added to the site before adding the mappings. This is because URLs are
canonicalised and then deduplicated before being saved and part of
canonicalisation is to remove non-significant parameters. However,
significant query string parameters can be added later; after they have
been imported adding old URLs which include the parameters will be
canonicalised using the new list of significant parameters. Note that mappings
created under the previous list won't be removed and in some (complicated)
situations won't be used by Bouncer.

To add or edit mappings, you will need the "GDS Editor" permission in
GOV.UK Signon for the Transition app. This lets you edit any site,
rather than just ones belonging to your organisation. You can then go
the [transition app](https://transition.publishing.service.gov.uk), find
the site and click `Add mappings` to add them in bulk.

### 7) Get the organisation to do the mapping work

By default, the mappings will present an archive page to users visiting
the old URL. The objective is to get users to somewhere that best serves
the need fulfilled by the old page. Usually this means redirecting them
to the page on GOV.UK or elsewhere. It is really important that this is
done by people who understand the users and content.

### 8) Get the organisation to lower the TTL on the DNS records a day ahead

In order to cleanly switch the domain from the old site, the TTL needs
to be low enough that there isn't a significant period where some users
will get the old site and some get the new one. This is important for
several reasons, including user experience and giving a professional
impression to stakeholders. We normally ask for this to be done a day in
advance, and to be lowered to 300 seconds (5 minutes). It can be raised
again once everyone is happy there is no need to switch back - normally
the day after.

### 9) Point the domain at us

Once the site has been imported successfully, the domain can be pointed
at us by the organisation. For hostnames which can have a `CNAME`
record, this is `bouncer-cdn.production.govuk.service.gov.uk`.
Domains at the root of their zone can't use `CNAME` records, so must use
an `A` record and point at one of the [Fastly GOV.UK IP
addresses](https://github.com/alphagov/transition/blob/016c3d30e190c41eaa912ed554384a49f3418a91/app/models/host.rb#L22).

If the site is one that was [administered by GDS](https://github.com/alphagov/gds-dns-config/tree/master/zones)
(e.g. theorytest.direct.gov.uk), you will need to [update and re-deploy the DNS config](/manual/dns.html#making-changes-to-publishing-service-gov-uk).

### 10) Get the organisation to monitor the traffic data in the Transition app

There are two things that need to be responded to:

- high numbers of 404s - this means a mapping is missing
- high numbers hitting 410s - this means the old page is popular and
  should perhaps be redirected instead

## Further reading

The transition checklist covers the whole process of transitioning a site from the technical side. There’s a [full version for complex sites](https://docs.google.com/document/d/1SiBwYtV_d_D9pPcqzpqvRWs0kscUtB7yqxN8Ub_uRSA/edit) and a [slightly simplified one](https://docs.google.com/document/d/1gIJBUuPaZqtYsrgwqMBSrU4lpr2e93tuhQcgylnSHb4/edit) - we probably only need the simpler one for upcoming transitions.

[Transition]: /apps/transition.html
[Bouncer]: /apps/bouncer.html
[transition-config]: https://github.com/alphagov/transition-config/blob/master/README.md
