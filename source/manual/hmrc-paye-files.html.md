---
owner_slack: "#govuk-2ndline"
title: Upload HMRC PAYE files
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-05-10
review_in: 6 months
---

[Basic PAYE Tools](https://www.gov.uk/basic-paye-tools) is a free software package HMRC provide for small employers to run their payroll. This is available on Windows, Linux, and OS X.

It's updated annually at the start of April with 'uprated' tax rates and thresholds for the new tax year. These updates are critical for employers as if they're using the wrong version their employees could end up paying the wrong amount of tax. Sometimes HMRC release minor updates during the tax year but these are less regular.

HMRC should submit the ticket to request updates to the exe files at least 2 weeks before the new versions are scheduled to go live. If you get a request with a tighter deadline than this, contact the 'green' content support team through their [Slack channel](https://gds.slack.com/messages/CADGKPQHJ/).

As part of the initial tranche of ministerial department migration their
upload site was switched off. However, we don't currently allow `exe`
files or other executable binary types to be uploaded to GOV.UK.
Therefore we determined the quickest course of action to meet the user
need of keeping their desktop software up to date was to manually upload
and host the files ourselves.

This document describes the process by which this is actioned.

The way the updates work:

-   Binaries are provided for Windows, OS X and Linux
-   Deltas of the binaries are also provided for partial updates
-   The software hits a manifest file
    (`realtimepayetools-update-vXX.xml`) to determine which files
    to download. This manifest contains the version number and partial
    paths to each of the available binaries. This manifest URL is
    hard-coded in the desktop software and only changes with each major version.
-   The software downloads the relevant binaries from our asset host and
    updates itself
-   There is also a [mainstream content
    item](https://www.gov.uk/basic-paye-tools) and a [Welsh
    translation](https://www.gov.uk/lawrlwytho-offer-twe-sylfaenol-cthem)
    which should be updated to link to the full downloads of the new versions

## Where are the files?

The files are stored in S3, along with the rest of our uploaded assets.

## The process for uploading new versions of the app

The manifest file version vXX is given as an example. You should confirm the
version number to use with HMRC because it must match the URL hard-coded into
the previous version of the software.

1.  HMRC submit a ticket via Zendesk
    ([example](https://govuk.zendesk.com/tickets/771694))
1.  Check that GOV.UK content teams are aware of the ticket.  They may
    need to request further tickets to be raised to cover the content updates.
1.  Download all zip files and XML file in the ticket
1.  Upload the new files:

        ssh backend-1.production "mkdir -p /tmp/hmrc-paye && rm -rf /tmp/hmrc-paye/*"
        scp *.zip backend-1.production:/tmp/hmrc-paye
        scp *.xml backend-1.production:/tmp/hmrc-paye

1.  Load the files into the Asset Manager, with "test-" at the start of the manifest file's name:

        ssh backend-1.production
        cd /var/apps/asset-manager
        sudo -udeploy govuk_setenv asset-manager bundle exec rake govuk_assets:create_hmrc_paye_zips[/tmp/hmrc-paye]
        sudo -udeploy govuk_setenv asset-manager bundle exec rake govuk_assets:create_hmrc_paye_asset[/tmp/hmrc-paye/realtimepayetools-update-vXX.xml,test-realtimepayetools-update-vXX.xml]

1.  [Purge the cache](https://docs.publishing.service.gov.uk/manual/cache-flush.html#assets) for the test file.

1.  Reply to the Zendesk ticket, providing the `test-*.xml` URL of:

        https://www.gov.uk/government/uploads/uploaded/hmrc/test-realtimepayetools-update-vXX.xml

1.  When Aspire or one of the other suppliers replies that the file
    works fine, the new edition of the [mainstream content
    item](https://www.gov.uk/basic-paye-tools) and [Welsh
    translation](https://www.gov.uk/lawrlwytho-offer-twe-sylfaenol-cthem)
    can be prepped by the content team with the new links, file sizes and version
    number, ready to publish at the launch time. Pass the Zendesk ticket over to content support by reassigning it to '3rd line--GOV.UK Content' and adding the green team tag, 'business_defence_environment' .

1.  When the launch time comes (which should be specified in the Zendesk
    ticket), re-load the test file to the production path:

        ssh backend-1.production
        cd /var/apps/asset-manager
        sudo -udeploy govuk_setenv asset-manager bundle exec rake govuk_assets:create_hmrc_paye_asset[/tmp/hmrc-paye/realtimepayetools-update-vXX.xml]

    You will have to copy the file to the server again if it has been deleted since it was first uploaded.

1. Publish the content items.

1. [Purge the cache](https://docs.publishing.service.gov.uk/manual/cache-flush.html#assets) for the new file.

1.  Update and resolve the Zendesk ticket
