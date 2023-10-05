---
owner_slack: "#govuk-publishing-platform"
title: Transition a site to GOV.UK
section: Transition
layout: manual_layout
parent: "/manual.html"
related_repos: [bouncer, transition]
---

When a site is going to move to GOV.UK, there are two ways that the old site
can be redirected. They can do it themselves, or they can repoint the domain at
us. This page is about the latter.

The [Transition][] app exists to allow old URLs to be mapped to pages
on GOV.UK. These mappings are stored in a database and used by [Bouncer][] to
handle requests to those old domains.

This page covers adding a site so that we can handle traffic to
it, or changing the configuration of an existing site in the Transition app.

## Changing the configuration of a site that is already in the Transition app

If you have the Site Manager permission for Transition, you will see an Edit button on each site page (for example, [the site page for Department for Education's old domain](https://transition.publishing.service.gov.uk/sites/dfe)). This form will allow you to change the configuration of the site.

## Checklist for transitioning a new site

### Prerequisites

Before you start, you need to know:

- the domain name being transitioned and any aliases
- the organisation that owns the site (and any additional organisations that should have access)
- the new homepage for the old site - often this is the organisation's page on GOV.UK, but sometimes it can be a different page on GOV.UK

The organisation that owns the site determines several things:

- where the site is found in the Transition app
- who has access to edit and create mappings for the site
- what organisation name and branding is used on pages served by Bouncer for URLs which aren't redirected

Extra organisations can be added later.

### 1) Add a site to the Transition app

If you have the Site Manager permission for Transition, you will see an "Add a transition site" button on each organisation page (for example, [Department for Education’s organisation page](https://transition.integration.publishing.service.gov.uk/organisations/department-for-education). Follow the instructions on that form to add a site.

### 2) Consider AKA domains

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

### 3) Get a list of old URLs

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

### 4) Clean up URLs

#### Strip paths and pattern

There are lots of file formats we don't want to provide mappings for, like
static assets, images, or common spammy/malicious crawlers. These can be
stripped using the [strip_mappings.sh][smsh] script.

[smsh]: https://github.com/alphagov/transition/blob/main/tools/strip_mappings.sh

#### Query parameter analysis

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

### 5) Add the old URLs as mappings

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

### 6) Get the organisation to do the mapping work

By default, the mappings will present an archive page to users visiting
the old URL. The objective is to get users to somewhere that best serves
the need fulfilled by the old page. Usually this means redirecting them
to the page on GOV.UK or elsewhere. It is really important that this is
done by people who understand the users and content.

### 7) Get the organisation to lower the TTL on the DNS records a day ahead

In order to cleanly switch the domain from the old site, the TTL needs
to be low enough that there isn't a significant period where some users
will get the old site and some get the new one. This is important for
several reasons, including user experience and giving a professional
impression to stakeholders. We normally ask for this to be done a day in
advance, and to be lowered to 300 seconds (5 minutes). It can be raised
again once everyone is happy there is no need to switch back - normally
the day after.

### 8) Add the domain to Fastly

#### Verify the subdomain (for a *.gov.uk subdomain only)

For security reasons, *.gov.uk subdomains are delegated upon request. When the steps below are not completed, there will be a `Domain 'gov.uk' is owned by another customer` error when the terraform apply command runs.

We need to:

1. Obtain the TXT record by submitting a Fastly support request. You will need to provide the 'Production bouncer' service ID and the subdomain you want to add. See an [example of support request](https://support.fastly.com/hc/en-us/requests/700875).

2. Add the DNS record to [govuk-dns-tf](https://github.com/alphagov/govuk-dns-tf) and apply terraform configuration.

  It's not possible to add additional records on a subdomain if a CNAME already exists. In such case Fastly accepts setting the record on a subdomain prefixed with `_fastly` as a proof of ownership. See an [example code change][code change].

#### Apply govuk-fastly terraform configuration

Manually trigger govuk-fastly 'Plan and apply' run in [Terraform Cloud UI](https://app.terraform.io/app/govuk/workspaces/govuk-fastly/runs). Review the plan with changes to `module.bouncer-production.fastly_service_vcl.service` and apply the configuration.

### 9) Point the domain at us

Once the site has been imported successfully, the domain can be pointed
at us by the organisation. For hostnames which can have a `CNAME`
record, this is `bouncer-cdn.production.govuk.service.gov.uk`.
Domains at the root of their zone can't use `CNAME` records, so must use
an `A` record and point at one of the [Fastly GOV.UK IP
addresses](https://github.com/alphagov/transition/blob/016c3d30e190c41eaa912ed554384a49f3418a91/app/models/host.rb#L22).

If the site is one that was [administered by GDS](https://github.com/alphagov/gds-dns-config/tree/master/zones)
(e.g. theorytest.direct.gov.uk), you will need to [update and re-deploy the DNS config](/manual/dns.html#dns-for-the-publishingservicegovuk-domain).

You'll need to create a TLS certificate in Fastly for HTTPS domains, otherwise
users will see a certificate error when being redirected from an external
HTTPS URL to GOV.UK via Bouncer. Read how to [request a Fastly TLS certificate][]

### 10) Get the organisation to monitor the traffic data in the Transition app

There are two things that need to be responded to:

- high numbers of 404s - this means a mapping is missing
- high numbers hitting 410s - this means the old page is popular and
  should perhaps be redirected instead

## Further reading

> The documents below may contain outdated information.

The transition checklist covers the whole process of transitioning a site from the technical side. There’s a [full version for complex sites](https://docs.google.com/document/d/1SiBwYtV_d_D9pPcqzpqvRWs0kscUtB7yqxN8Ub_uRSA/edit) and a [slightly simplified one](https://docs.google.com/document/d/1gIJBUuPaZqtYsrgwqMBSrU4lpr2e93tuhQcgylnSHb4/edit) - we probably only need the simpler one for upcoming transitions.

[Transition]: /repos/transition.html
[Bouncer]: /repos/bouncer.html
[request a Fastly TLS certificate]: /manual/request-fastly-tls-certificate.html
[code change]: https://github.com/alphagov/govuk-dns-tf/compare/0cf283b6...18471c36
