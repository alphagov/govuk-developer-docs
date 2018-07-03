---
owner_slack: "#govuk-2ndline"
title: Upload HMRC PAYE files
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-28
review_in: 6 months
---

HMRC have a [desktop application to submit
PAYE](https://www.gov.uk/basic-paye-tools). This is available on Windows,
Linux, and OS X.

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

The files are currently stored in our asset host. This can be seen as
follows:

    ssh asset-master-1.backend.production ls /mnt/uploads/whitehall/clean/uploaded/hmrc

Also see [the Puppet definition for how these files are
served](https://github.com/alphagov/govuk-puppet/blob/b97161bb04a9602fabc80db2a65c923fca27cb42/modules/govuk/manifests/apps/whitehall.pp#L94-L110).

The files are:

-   `payetools-{linux,osx,win}.zip` - the full binary
-   `payetools-rti-$version-{linux,osx,win}.zip` - the binary patch
    updates
-   `realtimepayetools-update-vXX.xml` - a manifest file describing the
    patch update locations and versions
-   `test-realtimepayetools-update-vXX.xml` - the next patch release
    test file, used by the software provider to test the end to end
    process

## The process for uploading new versions of the app

The manifest file version vXX is given as an example. You should confirm the
version number to use with HMRC because it must match the URL hard-coded into
the previous version of the software.

1.  HMRC submit a ticket via Zendesk
    ([example](https://govuk.zendesk.com/tickets/771694))
2.  Download all zip files and XML file in the ticket
3.  Upload the ZIP files only:

        ssh asset-master-1.backend.production "mkdir -p /tmp/hmrc-paye && rm -rf /tmp/hmrc-paye/*"
        scp *.zip asset-master-1.backend.production:/tmp/hmrc-paye
        ssh asset-master-1.backend.production
        sudo su - assets
        cp /tmp/hmrc-paye/* /mnt/uploads/whitehall/clean/uploaded/hmrc/

4.  Replace the XML manifest prefixed with `test`:

        scp realtimepayetools-update-vXX.xml asset-master-1.backend.production:/tmp/hmrc-paye/test-realtimepayetools-update-vXX.xml
        ssh asset-master-1.backend.production
        sudo su - assets
        cp /tmp/hmrc-paye/*.xml /mnt/uploads/whitehall/clean/uploaded/hmrc/

5.  Purge the cache for the test file:

        fab $environment class:cache cdn.purge_all:/government/uploads/uploaded/hmrc/test-realtimepayetools-update-vXX.xml

6.  Reply to the Zendesk ticket, providing the `test-*.xml` URL of:

        https://www.gov.uk/government/uploads/uploaded/hmrc/test-realtimepayetools-update-vXX.xml

7.  When Aspire or one of the other suppliers replies that the file
    works fine, the new edition of the [mainstream content
    item](https://www.gov.uk/basic-paye-tools) and [Welsh
    translation](https://www.gov.uk/lawrlwytho-offer-twe-sylfaenol-cthem)
    can be prepped by the content team with the new links, file sizes and version
    number, ready to publish at the launch time.

8.  When the launch time comes (which should be specified in the Zendesk
    ticket), copy the test file over the production file using the
    following commands (the `mv` command can't be used because it
    doesn't update the modified time of the file):

        ssh asset-master-1.backend.production
        cat /mnt/uploads/whitehall/clean/uploaded/hmrc/test-realtimepayetools-update-vXX.xml | sudo -u assets tee /mnt/uploads/whitehall/clean/uploaded/hmrc/realtimepayetools-update-vXX.xml

9. Publish the content items.

10.  Purge the cache, which will otherwise take up to 12 hours to
    expire:

        fab $environment class:cache cdn.purge_all:/government/uploads/uploaded/hmrc/realtimepayetools-update-vXX.xml

10.  Update and resolve the Zendesk ticket
