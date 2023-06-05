---
owner_slack: "#govuk-2ndline-tech"
title: Domain Name System (DNS) records
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

GOV.UK is responsible for managing several DNS zones.

By default, zones are hosted by AWS (Route 53) and Google Cloud Platform (Cloud DNS). We use both for redundancy.

As of December 2022, there are 61 hosted zones. A list is retrievable from a terminal using:

```
gds aws govuk-production-poweruser -- aws route53 list-hosted-zones | grep Name
```

Some individual records within these zones are managed by other teams.

## Records for GOV.UK systems

We use a few domains:

- `alphagov.co.uk` is the old domain name GOV.UK publishing used to live on.
  We maintain records which point to Bouncer so that these URLs redirect.
- `publishing.service.gov.uk` and `govuk.service.gov.uk` are where GOV.UK lives.

## DNS for `*.service.gov.uk` domains

GOV.UK Technical 2nd Line are responsible for delegating DNS to other government services.
Note that we __do not__ manage any other DNS records: if you get a request concerning anything other than `NS` records, it should be rejected. See the [SRE interruptible documentation](https://docs.google.com/document/d/1QzxwlN9-HoewVlyrOhFRZYc1S0zX-pd97igY8__ZLAo/edit#heading=h.wg0s4ugkpdpc) for details.

When you've verified the authenticity of the request as per the SRE docs above, you should:

1. Ensure you have [Terraform Cloud access](#getting-terraform-cloud-access)
1. Commit your changes in [govuk-dns-tf][] (see [example](https://github.com/alphagov/govuk-dns-tf/pull/14))
1. Push your changes to GitHub and open a pull request
1. Terraform Cloud will automatically perform a plan
1. If you are happy with the results of the plan, merge your PR
1. Terraform Cloud will automatically apply your changes when they are merged to `main`

## DNS for `govuk.digital` and `govuk-internal.digital`

Currently these zones are only used in environments running on AWS.

These DNS zones are hosted in Route53 and managed by Terraform. Changes can be
made in the [govuk-aws](https://github.com/alphagov/govuk-aws/) and
[govuk-aws-data](https://github.com/alphagov/govuk-aws-data/) repositories.
While GOV.UK migrates to AWS speak with GOV.UK Platform Engineering for support
making your changes.

## DNS for the `publishing.service.gov.uk` domain

To make a change to this zone, begin by adding the records to the yaml file for
the zone held in the [DNS config repo](https://github.com/alphagov/govuk-dns-tf).

The deployment process is the same as for [`service.gov.uk`](#dns-for-service-gov-uk-domains)

## DNS for the `gov.uk` top level domain

[Jisc](https://www.jisc.ac.uk/) is a non-profit which provides networking to
UK education and government. They control the `gov.uk.` top-level domain.

Requests to modify the DNS records for `gov.uk.` should be sent by
email to `naming@ja.net` from someone on Jisc's approved contacts
list. Speak to a member of the senior tech team or someone in
GOV.UK Platform Engineering if you need to make a change and don't have
access.

You should also make sure that the following groups of people are aware before
requesting any changes:

- Technical 2nd Line (via email)
- GOV.UK's Head of Tech and the senior tech team
- The CDDO domains team (the senior tech team can contact them)

Technical 2nd Line should be notified of any planned changes via email.

- `gov.uk.` is a top-level domain so it cannot contain a CNAME record
  (see [RFC 1912 section 2.4](https://tools.ietf.org/html/rfc1912#section-2.4)).
  Instead, it contains A records that point to anycast IP addresses for our CDN provider.
- `www.gov.uk.` is a CNAME to `www-cdn.production.govuk.service.gov.uk.`, which means we
  do not need to make a request to Jisc if we want to change CDN providers. Just change where
  the CNAME points to.

## DNS for non-`gov.uk` domains

GOV.UK also manages DNS zones for some non-`gov.uk` domains.

These include (but are not limited to):

- `independent-commission.uk`
- `independent-inquiry.uk`
- `public-inquiry.uk`
- `royal-commission.uk`

Some of these are not managed by Terraform. If you can't find a configuration file for the zone in [govuk-dns-tf][], then you'll need to update it manually in the AWS console.

1. Login to the **production** AWS console.

    ```
    $ gds aws govuk-production-poweruser -l
    ```

2. Go to [Route 53 > Hosted zones](https://us-east-1.console.aws.amazon.com/route53/v2/hostedzones) and select the zone for the domain you need to update.

    For example, if you've been asked to delegate `example.independent-inquiry.uk` you'll need the `independent-inquiry.uk` zone.

3. Expand the 'Hosted zone details' and look for any useful comments in the description field.

    For example, the description will hopefully be something like:

    > This zone is managed manually using the AWS console (i.e. click-ops). It's not managed by Terraform.

    This is a clear indicator that it's safe to update these records manually and they won't be overwritten by Terraform.

    However if it's something like this, then you shouldn't update it manually:

    > Managed by Terraform

4. Update the DNS records as required.
5. **For bonus points:** If the zone description wasn't clear, but you're certain it's safe to be updated manually, then consider changing the description field so it's clearer for the next person.

## Getting Terraform Cloud access

You can sign up for Terraform Cloud and join the GOV.UK organisation yourself. You will need to be a member of the [Technical 2nd Line Support](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/2nd-line-support) Google Group, or the [GOV.UK Terraform Cloud Access](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/GOV.UK_Terraform_Cloud_Access/members) group.

1. Follow this link to [join the GOV.UK Terraform Cloud organisation](https://accounts.google.com/o/saml2/initsso?idpid=C01ppujwc&spid=738388265440&forceauthn=false). By connecting your digital.cabinet-office.gov.uk Google account, you'll be granted access to the GOV.UK organisation.
2. After connecting Google, you'll be asked to create a Terraform Cloud account (or sign in if you already have one). You'll need to set an account password – which might feel weird because you've already linked Google, but it turns out that's only used to grant access to the GOV.UK organisation, not for SSO login functionality.
3. You should now have access to [workspaces in the GOV.UK organisation](https://app.terraform.io/app/govuk/workspaces).
4. Open the [govuk-dns-tf][govuk-dns-tf-cloud] workspace. This is where Terraform Cloud will plan & apply changes made to the [govuk-dns-tf][] GitHub repository.

If you have problems following any of the above steps, you might be missing from the required Google Group. Ask over in the [#govuk-platform-engineering](https://gds.slack.com/channels/govuk-platform-engineering) Slack channel for help.

[govuk-dns-tf]: https://github.com/alphagov/govuk-dns-tf
[govuk-dns-tf-cloud]: https://app.terraform.io/app/govuk/workspaces/govuk-dns-tf
