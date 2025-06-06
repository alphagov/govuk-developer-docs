---
owner_slack: "#govuk-publishing-platform"
title: Transition a site to GOV.UK
section: Transition
layout: manual_layout
parent: "/manual.html"
related_repos: [bouncer, transition]
---

When a site is going to move to GOV.UK, there are two ways that the old site can be redirected. They can do it themselves, or they can repoint the domain at us. This page is about the latter.

The [Transition][] app exists to allow old URLs to be mapped to pages on GOV.UK. These mappings are stored in a database and used by [Bouncer][] to handle requests to those old domains.

This page covers adding a site so that we can handle traffic to it, or changing the configuration of an existing site in the Transition app.

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

### 1) Verify the domain (for *.gov.uk domains only)

For security reasons, Fastly require that *.gov.uk domains are verified before they can be added to our Fastly account.

> When the steps below are not completed, there will be a `Domain 'gov.uk' is owned by another customer` error when the terraform apply command runs.
>
> This error results in any further transitioned sites being blocked until the verification is completed. Therefore this step must be completed before moving onto the next step.

We need to:

1. Obtain the TXT record by submitting a Fastly support request. You will need to provide the 'Production bouncer' service ID and the subdomain you want to add.

    Support requests are created on the [Fastly Support Case Management](https://support.fastly.com/s/case-management) website. You must login before creating the request, to verify you can perform actions on GOV.UK's account.

    You will need the 'Service ID', which is obtained by logging into [Fastly](https://manage.fastly.com/home) and navigating to the 'Production Bouncer' service, then locating the value labelled 'ID' on the service page.

    For the request type, select 'Other' and the subject can be 'Verify a subdomain'.

    An example request may be as follows:

    > Hi,
    >
    > Similar to our previous requests, we would like to add a new *.gov.uk domain to our service and understand that you now require explicit verification.
    >
    > Can you please provide me with the details of a TXT record we need to add to manually verify the addition?
    >
    > Details below:
    >
    > Service ID: [add the service ID here]
    >
    > Subdomain: [add the domain here]
    >
    > Kind regards,
    >
    > [your name]

1. If the domain's DNS is managed by GOV.UK: add the DNS record to [govuk-dns-tf](https://github.com/alphagov/govuk-dns-tf) and apply terraform configuration. If the domain's DNS is managed by the department: send the TXT record to the department and ask them to add this record to the DNS.

   > It's not possible to add additional records on a subdomain if a CNAME already exists. In such case Fastly accepts setting the record on a subdomain prefixed with `_fastly` as a proof of ownership. See an [example code change][code change].

### 2) Add a site to the Transition app

If you have the Site Manager permission for Transition, you will see an "Add a transition site" button on each organisation page. Follow the instructions on that form to add a site, using the following as guidance for common cases.

> Note: the Transition app only displays organisations that have existing transitioned sites. To add a domain to an organisation without any existing transition sites, navigate to `https://transition.publishing.service.gov.uk/organisations/[organisation-slug]`, where the slug is that from the organisation's public page on GOV.UK.

#### If the organisation would like all paths redirecting to the same domain

Use the following settings for the site. All other form fields can be ignored.

- TNA timestamp: get the latest timestamp as advised by the form guidance. Otherwise use the default specified on the form.
- Homepage: the URL where all requests will be redirected to.
- Hostname: the old domain that the requests come from (do not add `www`).
- Global type: select 'Redirect'.
- Global new URL: the URL where all requests will be redirected to.
- Global redirect append path: check this option if the requester would like the path appended to the redirect (e.g. they want `https://www.my-old-domain.gov.uk/some-path` to redirect to `https://www.my-new-domain.gov.uk/some-path`). When this option is not checked, `https://www.my-old-domain.gov.uk/some-path` will redirect to `https://www.my-new-domain.gov.uk`.
- Aliases: add the www version of the domain to this list.

#### If the organisation would like all paths to return an 'archived' page

Use the following settings for the site. All other form fields can be ignored.

- TNA timestamp: get the latest timestamp as advised by the form guidance. Otherwise use the default specified on the form.
- Homepage: the URL for the organisation's homepage.
- Hostname: the old domain that the requests come from (do not add `www`).
- Homepage title: the name for the website that will appear on the 'archived' page.
- Homepage full URL: the URL where that will be given as an alternative on the 'archived' page.
- Global type: select 'Archive'.
- Aliases: add the www version of the domain to this list.

#### If the organisation would like to manually specify paths

See the ['Configure transition mappings for a site' guidance](/manual/configure-transition-mappings.html).

### 3) Get the domain owner to lower the TTL on the DNS records a day ahead

> This step is only required if the domain currently has DNS records.

In order to cleanly switch the domain from the old site, the TTL needs to be low enough that there isn't a significant period where some users will get the old site and some get the new one. This is important for several reasons, including user experience and giving a professional impression to stakeholders. We normally ask for this to be done a day in advance, and to be lowered to 300 seconds (5 minutes). It can be raised again once everyone is happy there is no need to switch back - normally the day after.

### 4) Add the domain to Fastly

Manually trigger `govuk-fastly-bouncer-production` 'Plan and apply' run in [Terraform Cloud UI](https://app.terraform.io/app/govuk/workspaces/govuk-fastly-bouncer-production/runs). Review the plan with changes to `module.bouncer-production.fastly_service_vcl.service` and apply the configuration.

> If the domain currently has no DNS entries (e.g. it is brand new), this process will not set up the domain in Fastly (due to [this line of code](https://github.com/alphagov/transition/blob/8a532735ce8e61731986fd580a5d6ca1552e095f/app/controllers/hosts_controller.rb#L3C14-L3C49)). Instead you should request the domain's owner point the DNS to us (see next step) before running this project.

### 5) Change the domain's DNS to point at Bouncer

Once the transition is ready to be deployed, the domain must be pointed at Bouncer.

This is done is one of two ways:

- Adding a 'CNAME' record: `bouncer-cdn.production.govuk.service.gov.uk` (preferred, where possible).
- Adding an 'A' record pointing at one of the [Fastly GOV.UK IP addresses](https://github.com/alphagov/transition/blob/016c3d30e190c41eaa912ed554384a49f3418a91/app/models/host.rb#L22) (discouraged, as this hardcodes Fastly IP addresses that may change in the future).

If the domain is [administered by GDS](https://github.com/alphagov/govuk-dns-tf/tree/main/zones), you will need to [update and re-deploy the DNS config](/manual/dns.html#dns-for-the-publishingservicegovuk-domain). See an [example PR](https://github.com/alphagov/govuk-dns-tf/pull/405/files) for adding a new domain with a CNAME.

If the domain is administered by the requester, you must send them the new DNS details and ask them to update the DNS records.

### 6) Obtain a TLS certificate

You'll need to create a TLS certificate in Fastly, otherwise users will see a certificate error when being redirected from an external HTTPS URL to GOV.UK via Bouncer. Read how to [request a Fastly TLS certificate][].

## Further reading

> The documents below may contain outdated information.

The transition checklist covers the whole process of transitioning a site from the technical side. There’s a [full version for complex sites](https://docs.google.com/document/d/1SiBwYtV_d_D9pPcqzpqvRWs0kscUtB7yqxN8Ub_uRSA/edit) and a [slightly simplified one](https://docs.google.com/document/d/1gIJBUuPaZqtYsrgwqMBSrU4lpr2e93tuhQcgylnSHb4/edit) - we probably only need the simpler one for upcoming transitions.

[Transition]: /repos/transition.html
[Bouncer]: /repos/bouncer.html
[request a Fastly TLS certificate]: /manual/request-fastly-tls-certificate.html
[code change]: https://github.com/alphagov/govuk-dns-tf/compare/0cf283b6...18471c36
