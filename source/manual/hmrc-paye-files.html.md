---
owner_slack: "#govuk-2ndline"
title: Upload HMRC PAYE files
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

[Basic PAYE Tools](https://www.gov.uk/basic-paye-tools) is a free software package HMRC provide for small employers to run their payroll. This is available on Windows, Linux, and OS X.

It's updated annually at the start of April with 'uprated' tax rates and thresholds for the new tax year. These updates are critical for employers as if they're using the wrong version their employees could end up paying the wrong amount of tax. Sometimes HMRC release minor updates during the tax year but these are less regular.

HMRC should submit the ticket to request updates to the exe files at least 2 weeks before the new versions are scheduled to go live. If you get a request with a tighter deadline than this, contact the 'green' content support team through their [Slack channel](https://gds.slack.com/messages/CADGKPQHJ/).

As part of the initial tranche of ministerial department migration their
upload site was switched off. However, we don't currently allow `exe`
files or other executable binary types to be uploaded to GOV.UK.
Therefore we determined the quickest course of action to meet the user
need of keeping their desktop software up to date was to manually upload
and host the files ourselves, bundled inside ZIP files.

This document describes the process by which this is actioned.

The way the updates work:

- Binaries are provided for Windows, OS X and Linux
- Deltas of the binaries are also provided for partial updates
- The software hits a manifest file
  (`realtimepayetools-update-vXX.xml`) to determine which files
  to download. This manifest contains the version number and partial
  paths to each of the available binaries. This manifest URL is
  hard-coded in the desktop software and only changes with each major version.
- The software downloads the relevant binaries from our asset host and
  updates itself
- There is also a [mainstream content item](https://www.gov.uk/basic-paye-tools)
  and a [Welsh translation](https://www.gov.uk/lawrlwytho-offer-twe-sylfaenol-cthem)
  which should be updated to link to the full downloads of the new versions

## Where are the files?

The files are stored in S3, along with the rest of our uploaded assets.

## The process for uploading new versions of the app

The manifest file version vXX is given as an example. You should confirm the
version number to use with HMRC because it must match the URL hard-coded into
the previous version of the software.

1. HMRC submit a ticket via Zendesk
   ([example](https://govuk.zendesk.com/tickets/771694))
1. Check that GOV.UK content teams are aware of the ticket. They may
   need to request further tickets to be raised to cover the content updates.
1. Download all zip files and XML file in the ticket
1. Log into a backend machine: `gds govuk connect ssh -e production aws/backend:1`.
   **Yes, production - don't use integration or staging to test. There's a test procedure on production.**
1. Create a directory for the files to go into: `mkdir /tmp/hmrc-paye`
1. Either `exit` to return to your dev machine, or open another shell
1. Upload the new files:

   ```shell
   $mac gds govuk connect scp-push -e production aws/backend:1 *.zip /tmp/hmrc-paye
   $mac gds govuk connect scp-push -e production aws/backend:1 *.xml /tmp/hmrc-paye
   ```

1. SSH back into the machine if you exited earlier:
   `gds govuk connect ssh -e production aws/backend:1`

1. Verify that the files copied over correctly: `ls /tmp/hmrc-paye`

1. Upload the ZIP files into Asset Manager

   ```shell
   cd /var/apps/asset-manager
   sudo -udeploy govuk_setenv asset-manager bundle exec rake govuk_assets:create_hmrc_paye_zips[/tmp/hmrc-paye]
   ```

   The command should take a few seconds to run, and the output will look something like this
   (it can be safely ignored):
    > `/home/yourname` is not writable.
    > Bundler will use `/tmp/user/2899/bundler/home/deploy' as your home directory temporarily.

1. You should be able to access your zip, e.g. at
   https://assets.publishing.service.gov.uk/government/uploads/uploaded/hmrc/payetools-rti-[version-and-os].zip
   You may also see some "high memory for asset-manager app" alerts in the meantime.

1. Now upload the manifest, **but with "test-" at the start of the filename**:

   ```shell
   sudo -udeploy govuk_setenv asset-manager bundle exec rake \
   govuk_assets:create_hmrc_paye_asset[/home/yourname/hmrc-paye/realtimepayetools-update-vXX.xml,test-realtimepayetools-update-vXX.xml]
   ```

1. [Purge the cache](https://docs.publishing.service.gov.uk/manual/purge-cache.html#assets) for the test file.

1. Reply to the Zendesk ticket, providing the `test-*.xml` URL of:

   https://www.gov.uk/government/uploads/uploaded/hmrc/test-realtimepayetools-update-vXX.xml

1. Wait for HMRC to confirm that it (and/or its suppliers) have tested the file
   and would like to proceed. Pass the Zendesk ticket over to content support by
   reassigning it to `3rd line--GOV.UK Content` and adding the green team tag,
   `business_defence_environment`.
   In your handover comment, link to the [mainstream content item](https://www.gov.uk/basic-paye-tools)
   ([publisher link](https://publisher.publishing.service.gov.uk/editions/5e7e2e44e5274a6fbfebfbc2))
   and [Welsh translation](https://www.gov.uk/lawrlwytho-offer-twe-sylfaenol-cthem)
   ([publisher link](https://publisher.publishing.service.gov.uk/editions/5d72732f40f0b66279dc1ce8)).
   The content team will prep these pages with the new links, file sizes and
   version number, ready to publish at the launch time.

1. When the launch time comes (which should be specified in the Zendesk ticket),
   re-load the test file to the production path:

   ```shell
   gds govuk connect ssh -e production <aws_machine_ip_address>
   cd /var/apps/asset-manager
   sudo -udeploy govuk_setenv asset-manager bundle exec rake govuk_assets:create_hmrc_paye_asset[/tmp/hmrc-paye/realtimepayetools-update-vXX.xml]
   ```

   If the SSH connection fails, or if the file is missing, the machine has
   likely been rebooted and you'll need to repeat some of the earlier steps
   to copy the XML file onto the machine again.

1. [Purge the cache](https://docs.publishing.service.gov.uk/manual/purge-cache.html#assets)
   for the new file.

1. Reassign back to the content team to publish the content items. They will
   then resolve the Zendesk ticket.
