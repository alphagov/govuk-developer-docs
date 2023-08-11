---
owner_slack: "#govuk-2ndline-tech"
title: Validate_published_DNS
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

# Validate_published_DNS

This alert checks that published DNS records match those defined in the
govuk-dns-config repo.

The check runs as a [Jenkins job](https://deploy.blue.production.govuk.digital/job/Validate_published_DNS/). The logic of the check is [defined in the govuk-dns repo](https://github.com/alphagov/govuk-dns/blob/master/spec/validate_published_dns_spec.rb).

#### Possible causes

* There are unapplied changes in the [govuk-dns-config repo](https://github.com/alphagov/govuk-dns-config/).
* There might be an issue with the check itself.
* Changes might have been made manually (outside of Terraform) to the DNS records in Route53.

#### Investigation

Check the output of the Jenkins job for information about what didn't match, or what might have failed.

Re-run the Jenkins job. Does it produce the same result?

If the test seems to be reporting genuine differences, look for [recent changes to govuk-dns-config](https://github.com/alphagov/govuk-dns-config/commits/master) and [run a terraform plan](/manual/dns.html#dns-for-the-publishingservicegovuk-domain) for the affected DNS zone.
