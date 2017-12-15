---
owner_slack: "#govuk-infrastructre"
title: Migrate zone from Dyn DNS
section: DNS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-10-26
review_in: 6 months
---

## Migrate a zone from DynDNS

GOV.UK Infrastructure are currently responsible for managing several DNS zones
in [DynDNS](www.dyn.com/dns). This is a step-by-step guide to migrate these zones
to using [Google Cloud DNS](https://cloud.google.com/dns/docs/) and/or [Amazon Route 53](https://aws.amazon.com/route53/).

We would also make changes and deploy these zones in the future using [govuk-dns](https://github.com/alphagov/govuk-dns).

### Export the zonefile from DynDNS

1. Log into [DynDNS](https://manage.dynect.net/)
2. Find the zone you wish to export and click "manage"
3. Go to the "Zone Reports" tab
4. Click the download link on "Zone File" and it should start the download

### Convert the zonefile to YAML

1. Get the `govuk-dns` repository:

`git clone https://github.com/alphagov/govuk-dns`

2. Get the `govuk-dns-config` repository:

`git clone https://github.com/alphagov/govuk-dns-config`

3. Move into the `govuk-dns` repository and run the following to convert to YAML:
```
cd govuk-dns
bundle install
export ZONE=zone.example.com
OUTPUTFILE=../govuk-dns-config/$ZONE.yaml ZONEFILE=/path/to/zonefile bundle exec rake import_bind
```

This should create a the zonefile in YAML configuration.

4. Validate the YAML by running:
```
ZONEFILE=../govuk-dns-config/$ZONE.yaml bundle exec rake validate_yaml
```

5. Move into the `govuk-dns-config` repository and commit to git.

### Create zone in Amazon Route 53 and/or Google Cloud DNS

#### Amazon Route 53

1. Login in to the [AWS Management Console](https://aws.amazon.com/console/).
2. Click "Services" and select "Route 53".
3. On the left, click "Hosted Zones".
4. Click "Create Hosted Zone" and fill in the zone name.
5. When created, make a note of the "Hosted Zone ID".

#### Google Cloud DNS

1. Login to the [Google Cloud Platform Management Console](https://console.cloud.google.com/).
2. In the search bar at the top, search for "Cloud DNS" and select it.
3. Select "Create Zone", fill in a zone name and DNS name, and click "Create".
4. Make a note of the "zone name".

#### Update deployment configuration

Add the following to the top of the YAML zonefile:

```
deployment:
  aws:
    zone_id: <zone id>
  gcp:
    zone_name: <zone name>
```

Enter the values that were noted during the zone creation step.

#### Update Puppet

If the zone is new, you may need to add it to the list of zones that we manage.

Edit encrypted hieradata in [govuk-secrets](https://github.com/alphagov/govuk-secrets), and add the zone
to the list under the parameter `govuk_jenkins::job::deploy_dns::zones:`.

Ensure that Puppet is deployed to update the Jenkins job.

### Deploy the zone

Go to the [Deploy DNS](https://deploy.publishing.service.gov.uk/job/Deploy_DNS/) job in Jenkins.

Select the zone you wish to deploy, enter your AWS access details, and choose "plan" as the action,
using the provider you wish to deploy to.

When you are happy with the output, rebuild the job, but this time selecting "apply".

### Updating nameserver records

We do not manage root nameserver records.

These are provided automatically by the DNS provider. If you are serving a zone from
dual providers, you must manually add the nameserver records for the other provider.

For example, in Amazon Route 53, you need to add the Google Cloud DNS nameservers, and vice versa.

### Updating the registrar

TODO
