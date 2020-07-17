---
owner_slack: "#govuk-2ndline"
title: Upload an asset to asset-manager
section: Assets
layout: manual_layout
parent: "/manual.html"
---

Some publishing apps such as [Mainstream Publisher](/apps/publisher.html) do not provide the facility for editors to upload
assets such as images and PDFs. In these rare cases, we can upload assets to asset-manager manually
and give the URL to content editors to embed.

Production assets are replicated to staging and integration nightly, so it is best to simply perform
the upload directly in production. First, upload the asset to a backend machine:

```
gds govuk connect scp-push -e production aws/backend:1 my_file.jpg /tmp
```

Then SSH to the same machine and run the upload command:

```
gds govuk connect ssh -e production aws/backend:1
cd /var/apps/asset-manager
sudo -u deploy govuk_setenv asset-manager bin/create_asset /tmp/my_file.jpg
```

Note the `basepath` the script outputs. This should be appended to the asset host, for example:

```
https://assets.publishing.service.gov.uk/media/57358658ed915d58bd000000/my_file.jpg
```
