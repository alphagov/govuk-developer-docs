---
owner_slack: "#govuk-2ndline"
title: Licensify - supporting licensing
parent: "/manual.html"
layout: manual_layout
section: 2nd line
type: learn
---

GOV.UK runs a Scala application ([Licensify](/apps/licensify.html)) which allows users to apply and pay for licences from local authorities and other competent authorities.

## Overview

There is a [PDF user manual](https://licensify-admin.publishing.service.gov.uk/assets/manual.pdf) available which includes a lot of detail about the backend (administration) facilities available through the GOV.UK Licensing service.

### Applications

The Licensing service consists of [three separately deployed applications](https://github.com/alphagov/govuk-puppet/blob/f45e303e4e2555ac8cdc003898f17e4dbe86add5/hieradata_aws/common.yaml#L132-L140):

- `licensify` (on the `licensing_frontend` machine): the interface used by citizens and businesses who want to apply for a license. Allows them to download the relevant forms, submit them once completed, and also handles redirection to the relevant payment service if a fee is required.
- `licensify-admin` (on the `licensing_backend` machine): administrative interface for LAs to allow them to view and download applications from users. Also provides the ability for LA admin users to set up customisations (the specifics of the licence types) for their LA, and for GDS admins to control which licence types are available for each LA, and configuration like which payment provider the LA uses.
- `licensify-feed` (on the `licensing_backend` machine): backend (asynchronous) processing of application uploads and processing (via Apto), email notifications (via GOV.UK Notify), and expiry and purging of old applications. Also provides an interface for some debugging-type reporting.

### Finding a licence

Users use [Licence Finder](https://www.gov.uk/licence-finder) to locate licences on the GOV.UK frontend, but from a technical perspective this is separate from Licensify.

Licence Finder sends users to a "Licence" page served by [Frontend](/apps/frontend.html). Users enter their postcode and Frontend uses [Mapit](/apps/mapit.html) to [find their local authority](https://github.com/alphagov/frontend/blob/8dbe0f0f6ca0f5a777a0d6ca77b858fe5adc2494/app/controllers/licence_controller.rb#L83). Frontend makes a request to a Licensify API to find out whether the licence is available on GOV.UK.

### Applying for a licence

Licence applications handled by Licensify are processed as follows:

1. User downloads a PDF application form and completes it either in Adobe Reader or by hand.
1. User uploads the completed application form to Licensify, and provides their email address and consents to a legal declaration.
1. User is provided with receipt of application by email, and an email is sent to the relevant authority to inform them that an application is available for viewing.
1. Licensing authorities check [Licensify's admin interface](https://licensify-admin.publishing.service.gov.uk/login) for new applications, then process them and either confirm or deny the application.

## Testing

There is an example licence that you can use to test Licensify. Note that the following instructions are safe to run any number of times in production:

1. Go to <https://www.gov.uk/apply-for-a-licence/test-licence/gds-test/apply-1>
1. Download the PDF application form
1. Click 'Submit application'
1. Enter your email address, upload the application form you just downloaded and tick the checkbox to accept the declaration
1. Click 'Continue to pay fee'
1. Click 'Continue to WorldPay website'
1. Enter a [test card number](http://support.worldpay.com/support/kb/bg/testandgolive/tgl5103.html)
1. Make payment
1. You should see a confirmation page and receive an email with same details
1. Login to Licensify's admin interface to verify that your application is visible

You can give the application reference to Kibana in the relevant environment to see the logs and any error messages. The application should speak to both the frontend and backend app servers at least once during the transaction. It may take up to five minutes to process the licence application, so it might be worth waiting for a few minutes before checking Kibana.

## Debugging

The Feeds application has a UI that runs on port `9400`, but that isn't exposed publicly, so you need to tunnel to it. For example, the following will tunnel to the production instance of the Feeds admin and make it available via `localhost:9400`:

```bash
gds govuk connect -e production ssh licensing_backend

# Look at the output and grab the IP address, e.g.
# Running command: ssh -J username@jumpbox.production.govuk.digital username@ip-10-13-5-62.eu-west-1.compute.internal

# now exit the machine and run this command locally, replacing the IP
ssh username@ip-10-13-5-62.eu-west-1.compute.internal -J username@jumpbox.production.govuk.digital -L 9400:localhost:9400 -N
```

Once the tunnel above has been set up, the following pages are available:

- [Unprocessed applications](http://localhost:9400/licence-management/feed/process-applications)
- [Collected applications, ready to be purged](http://localhost:9400/licence-management/feed/applications/purge-expired)
- [Uncollected applications, ready to expire](http://localhost:9400/licence-management/feed/uncollected-applications-to-expire)
- [Uncollected applications, ready to purge](http://localhost:9400/licence-management/feed/uncollected-applications-to-purge)
- [Submitted applications report](http://localhost:9400/licence-management/feed/submittedApplicationsReport)

## Email

Mail from Licensify is handled by GOV.UK Notify using the HTTP API. Authentication is via an API key, which is provided as a [configuration parameter](https://github.com/alphagov/alphagov-deployment/blob/master/elms/deploy/config/gds-licensing-config.properties.production#L47) to the backend app servers by Puppet.

## Apto Solutions

Apto Solutions is a third-party organisation who take the completed application forms uploaded as PDFs and convert the input into a format which can be read by the Licensify Admin application.

In order for this to work, the PDF forms are sent away from GOV.UK to Apto's infrastructure. This means that Apto must have a firewall rule in place to allow connections from the outbound (SNAT) GOV.UK IP address.

## Data

Licensing data is stored in MongoDB and synced from production to staging. We don't sync the data to integration automatically because it contains personally-identifiable information.

You can manually copy data from staging to integration. These collections do not contain personal information so they're safe to copy:

```bash
for c in counters eula; do mongodump -d licensify -c $c -o ~/licensifydump; done
for c in authorities authorityLicenceInteraction customisations departments elmsLicences settings; do mongodump -d licensify-refdata -c $c -o ~/licensifydump; done
tar cvzf licensifydump.tar.gz licensifydump/
```

You can then copy this file onto an integration machine (possibly via your local machine) and restore the data:

```bash
tar xvzf licensifydump.tar.gz
mongorestore licensifydump/
```

Confusingly, some collections exist in both the `licensify` and the `licensify-refdata` database. If `db.collectionName.count() == 0` in one database, and `db.collectionName.count() != 0` in the other, then you should assume that the one with objects is the source of truth.

### Application Files

All newly-uploaded documents are stored within an S3 bucket; the credentials for this are provided to the application as environment variables. This feature was enabled on 2016-10-18; any documents uploaded before then are stored in GridFS (Mongo).

### Anti-virus scans of uploaded documents

All documents uploaded as part of the application process are scanned using ClamAV. There is also a nightly process that runs on a cron to re-check any previously uploaded files against the latest definitions, but this [process is currently disabled](https://github.com/alphagov/alphagov-deployment/blob/master/elms/deploy/config/gds-licensing-config.properties.production#L42). The risks disabling this poses are mitigated due to the fact that we are purging all applications after 90+7 days.
