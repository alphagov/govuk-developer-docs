---
owner_slack: "#govuk-developers"
title: Google Cloud Platform (GCP)
section: AWS
layout: manual_layout
parent: "/manual.html"
---

GOV.UK uses Google Cloud Platform (GCP) for three main things:

- [Static mirrors of GOV.UK](/manual/fall-back-to-mirror.html) (these are hosted in AWS and GCP).
- [DNS](/manual/dns.html) (DNS for www.gov.uk, service.gov.uk and other domains we manage is mirrored to name servers in AWS Route53 and Google CloudDNS)
- Various data science tasks such as [BigQuery](/manual/view-extract-feedback-data-bigquery.html)

## GCP access

Access to GCP is managed through the [GOV.UK GCP access Google Group](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-gcp-access).

Access to this group is granted manually once [permanent Production access](/manual/rules-for-getting-production-access.html) is
approved and merged to [GOV.UK user reviewer](https://github.com/alphagov/govuk-user-reviewer) repository.

If you should have access but don't, the Technical 2nd Line team should be able to add you to the Google Group.

### Accessing the console

You can login to the GCP console at [https://console.cloud.google.com/](https://console.cloud.google.com/) using
your `@digital.cabinet-office.gov.uk` email address.

There are four main GCP projects in GOV.UK:

- [GOVUK Production](https://console.cloud.google.com/home/dashboard?project=govuk-production)
- [GOVUK Integration](https://console.cloud.google.com/home/dashboard?project=govuk-integration)
- [GOVUK Staging](https://console.cloud.google.com/home/dashboard?project=govuk-staging-160211)
- [GOVUK Test](https://console.cloud.google.com/home/dashboard?project=govuk-test)

The interesting services are:

- [Google Cloud Storage](https://console.cloud.google.com/storage/browser?project=govuk-production) - where the static mirrors are stored
- [Google Cloud DNS](https://console.cloud.google.com/net-services/dns/zones?project=govuk-production) - where the DNS is configured

### Using the CLI

As with AWS, you can access GCP using the command line. The standard GCP command line interface is `gcloud`.

You can install `gcloud` with `brew install --cask google-cloud-sdk` or by following the instructions at [google's installation instructions][].

NOTE: By default `gcloud` doesn't put itself on your PATH, so there's an extra manual step to add it.
Make sure you follow all of the instructions from [homebrew's google-cloud-sdk cask](https://formulae.brew.sh/cask/google-cloud-sdk)
or [google's installation instructions][].

Once you've installed `gcloud` you can check it's working using some of these commands:

- `gcloud help` - get help
- `gcloud auth login` - sign in
- `gcloud config set project govuk-production` - select the GOVUK Production project
- `gcloud dns managed-zones list` - list the managed DNS zones
- `gcloud dns record-sets list --zone alpha-gov-uk` - list the DNS record sets for the alpha.gov.uk. zone

If you need to interact with the Cloud Storage (e.g. for the mirrors) from the CLI, you need to install the separate `gsutil` CLI.

## Support tasks which involve GCP

You may need login to GCP to [remove an asset](/manual/howto-manually-remove-assets.html) or
to [emergency publish content using the static mirrors](/manual/fall-back-to-mirror.html#emergency-publishing-using-the-static-mirror).

You will also need GCP access to update DNS if you need to [Fall back to the secondary CDN (AWS CloudFront)](/manual/fall-back-to-aws-cloudfront.html.md).

[google's installation instructions]: https://cloud.google.com/sdk/docs/quickstart#mac
