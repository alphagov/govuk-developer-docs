---
owner_slack: "#2ndline"
title: Upload an asset to asset-manager
section: Assets
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-10-09
review_in: 6 months
---

Some publishing apps such as Mainstream Publisher do not provide the facility for editors to upload
assets such as images and PDFs. In these rare cases, we can upload assets to asset-manager manually
and give the URL to content editors to embed.

This only works for apps which use the asset manager. See the [alternative
instructions for whitehall](upload-asset-to-whitehall.html) if you need to
attach a file to a whitehall page.

Production assets are replicated to staging and integration nightly, so it is best to simply perform
the upload directly in production. First, upload the asset to a backend box:

```
scp my_file.jpg backend-1.backend.production:/tmp/
```

Then SSH to the same box and run the upload command:

```
ssh backend-1.backend.production
cd /var/apps/asset-manager
sudo -u deploy govuk_setenv asset-manager bin/create_asset /tmp/my_file.jpg
```

Note the `basepath` the script outputs. This should be appended to the asset host, for example:

```
https://assets.publishing.service.gov.uk/media/57358658ed915d58bd000000/my_file.jpg
```
