---
owner_slack: "#govuk-content-apis"
title: Configure transition mappings for a site
section: Transition
layout: manual_layout
parent: "/transition-a-site.html"
related_repos: [bouncer, transition]
---

Sometimes the requester will want to specify redirects for specific paths, e.g. if they want to maintain links from old documents to their new equivalent. In these cases, there are a number of steps to follow.

## 1) Set up AKA domains if required

If the department want to preview how their redirects will appear after transitioning they will need to set up AKA domains.

They will need one new CNAME DNS entry for each domain/subdomain they wish to preview according to the following pattern:

- www.domain.gov.uk → aka.domain.gov.uk
- sub.domain.gov.uk → aka-sub.domain.gov.uk

There are lots of examples of these in [hosts currently configured in Transition](https://transition.publishing.service.gov.uk/hosts).

These AKA domains should have a single DNS record added as a CNAME to: `bouncer-cdn.production.govuk.service.gov.uk`.

Once the DNS on the AKA domains have been updated, the "Add the domain to Fastly" and "Obtain a TLS certificate" steps of the [main transition guidance](/manual/configure-transition-mappings.html) will need to be run again, but specifically for the AKA domains.

## 2) Set up user accounts for the department

Ask the requester for names and email addresses of users who need access to the Transition app.

Give the user(s) the "Site Manager" permission in Signon for the Transition app.

> If they do not have a Signon account in production already, create one for them at 'Normal' level with access to Transition and Support only (i.e. no ability to publish or preview documents, which may be granted by default when creating an account).

## 3) Add the old URLs as mappings

Ask the department to add mappings to the Transition app themselves.

These can be added in bulk using a CSV file. An example of the format is given in the app prior to upload.

To allow mappings which redirect away from GOV.UK, you'll need to add the site into [the allowlisted hosts in Transition](https://transition.publishing.service.gov.uk/admin/whitelisted_hosts). You'll need the `admin` permission in Transition to be able to see this page and should be done by GDS, not the department. You may wish to seek advice from the Policy & Strategy team before adding a domain the the external allowlist.

## 4) Switch the DNS once all mappings are created

Follow the remaining steps in the [main transition guidance](/manual/configure-transition-mappings.html).

## 5) Get the organisation to monitor the traffic data in the Transition app

There are two things that need to be responded to:

- high numbers of 404s: this means a mapping is missing
- high numbers hitting 410s: this means the old page is popular and should perhaps be redirected instead of being marked as archived

These metrics can be viewed in the Transition app.
