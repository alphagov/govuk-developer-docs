---
owner_slack: "#govuk-publishing-platform"
title: Configure transition mappings for a site
section: Transition
layout: manual_layout
parent: "/transition-a-site.html"
related_repos: [bouncer, transition]
---

Sometimes the requester will want to specify redirects for specific paths, e.g. if they want to maintain links from old documents to their new equivalent. In these cases, there are a number of steps to follow.

## 1) Consider AKA domains

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

## 2) Get a list of old URLs

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

## 3) Clean up URLs

### Strip paths and pattern

There are lots of file formats we don't want to provide mappings for, like
static assets, images, or common spammy/malicious crawlers. These can be
stripped using the [strip_mappings.sh][smsh] script.

[smsh]: https://github.com/alphagov/transition/blob/main/tools/strip_mappings.sh

### Query parameter analysis

From your set of URLs, you can attempt to identify significant query string
parameter names and then add them to the site configuration. A query string
parameter is considered significant if it significantly changes the content
seen on the old site and/or it would be mapped to a different new URL.

There are some transition scripts to help analyse query param usage:

- [analyse_query_params.sh](https://github.com/alphagov/transition/blob/main/tools/analyse_query_params.sh)
- [analyse_query_usage.sh](https://github.com/alphagov/transition/blob/main/tools/analyse_query_usage.sh)

Some common examples of significant parameters:

- article ID
- attachment ID
- document ID

Some common examples of non-significant parameters:

- pagination
- analytics
- search queries

## 4) Add the old URLs as mappings

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

To allow mappings which redirect away from GOV.UK, you'll need to add the site
into [the allowlisted hosts in Transition][]. You'll need the `admin` permission in Transition to be able to see this page.

[the allowlisted hosts in Transition]: https://transition.publishing.service.gov.uk/admin/whitelisted_hosts

## 5) Get the organisation to do the mapping work

By default, the mappings will present an archive page to users visiting
the old URL. The objective is to get users to somewhere that best serves
the need fulfilled by the old page. Usually this means redirecting them
to the page on GOV.UK or elsewhere. It is really important that this is
done by people who understand the users and content.

## 6) Get the organisation to monitor the traffic data in the Transition app

There are two things that need to be responded to:

- high numbers of 404s - this means a mapping is missing
- high numbers hitting 410s - this means the old page is popular and
  should perhaps be redirected instead
