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

1. Make the changes in [govuk-dns-config][] (see [example](https://github.com/alphagov/govuk-dns-config/pull/851))
1. Use the gds-cli to deploy the changes via the [Deploy_DNS Jenkins job][]

Before you start make sure your machine is set up so you can access AWS and [Google Cloud Platform (GCP)][] using command line tools.

The deployment process is complex, so it's much easier to [use the automation provided by the GDS CLI](#running-govuk-dns-using-gds-cli), although it [can be done manually](#running-govuk-dns-manually-using-jenkins).

### Running govuk-dns using gds-cli

gds-cli provides a command which automates gathering the required credentials and triggering Jenkins. The command authenticates to Jenkins using GitHub, so it expects `GITHUB_USERNAME` / `GITHUB_TOKEN` environment variables to be set. It calls out to the `aws` and `gcloud` command line tools to fetch the other required credentials.

You can get the relevant help for your version of gds-cli with:

```
$ gds govuk dns --help
NAME:
   gds govuk dns - deploy DNS via Jenkins

USAGE:
   gds govuk dns [command options] [arguments...]

OPTIONS:
...
```

For example, to have Jenkins run a terraform plan of changes to service.gov.uk against AWS, run:

```
$ gds govuk dns --provider aws --zone service.gov.uk --action plan --role govuk-production-poweruser
```

This will trigger a build in Jenkins. Check the build output to see what terraform has done / would do.

### Deploying a change

Deploying is a multi-step process

1. Run a `plan` of the deployment, against the `aws` provider.
1. Check that the output is what you expect.
1. Now run a `plan` of the deployment against the `gcp` provider.
1. Check that the output is what you expect.
  - It's normal to see changes in TXT records relating to escaping of quotes. You can safely ignore these if they don't change any of the content of the record. This is a bug in the way we handle splitting long TXT records between AWS and GCP in our [YAML -> Ruby -> Terraform process](https://github.com/alphagov/govuk-dns).
1. Finally, run an `apply` deployment for both `aws` AND `gcp`. (The order doesn't matter).
  - Sometimes, the GCP deployment requires multiple runs. This is because, in order to change a DNS record, the Google provider deletes and re-adds that record. This can cause a [race condition](https://github.com/alphagov/govuk-dns/issues/67) where Google tries to create the new one before it has successfully deleted the old one. In this case, the build will fail, and you just need to re-run the GCP `apply` job.

### Running govuk-dns manually using Jenkins

If you run into issues using the `gds govuk dns` command, you can trigger a build of the [Deploy_DNS Jenkins job][] directly.

You will need AWS credentials whichever provider you're targetting. You can get these by running:

```
gds aws govuk-production-poweruser -e
```

To plan or apply using the `gcp` provider, you will also need a Google OAuth access token. Once you [have gcloud set up][Google Cloud Platform (GCP)] you can get these by running:

```
gcloud config set project govuk-production && gcloud auth login --brief && gcloud auth print-access-token
```

You'll be prompted to login to your Google account to allow Google Cloud SDK access your Google Account.

## DNS for `govuk.digital` and `govuk-internal.digital`

Currently these zones are only used in environments running on AWS.

These DNS zones are hosted in Route53 and managed by Terraform. Changes can be
made in the [govuk-aws](https://github.com/alphagov/govuk-aws/) and
[govuk-aws-data](https://github.com/alphagov/govuk-aws-data/) repositories.
While GOV.UK migrates to AWS speak with GOV.UK Replatforming for support
making your changes.

## DNS for the `publishing.service.gov.uk` domain

To make a change to this zone, begin by adding the records to the yaml file for
the zone held in the [DNS config repo](https://github.com/alphagov/govuk-dns-config).

We use a Jenkins job that publishes changes to `publishing.service.gov.uk`. The
job uses [Terraform](https://www.terraform.io/) and pushes changes to the
selected provider.

## DNS for the `gov.uk` top level domain

[Jisc](https://www.jisc.ac.uk/) is a non-profit which provides networking to
UK education and government. They control the `gov.uk.` top-level domain.

Requests to modify the DNS records for `gov.uk.` should be sent by
email to `naming@ja.net` from someone on Jisc's approved contacts
list. Speak to a member of the senior tech team or someone in
GOV.UK Replatforming if you need to make a change and don't have
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

Some of these are not managed by Terraform. If you can't find a configuration file for the zone in [govuk-dns-config][], then you'll need to update it manually in the AWS console.

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

[Deploy_DNS Jenkins job]: https://deploy.blue.production.govuk.digital/job/Deploy_DNS/
[Google Cloud Platform (GCP)]: /manual/google-cloud-platform-gcp.html
[govuk-dns-config]: https://github.com/alphagov/govuk-dns-config
