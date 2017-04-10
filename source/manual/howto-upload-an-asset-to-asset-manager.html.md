---
title: Upload an asset to asset-manager
section: howto
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/howto-upload-an-asset-to-asset-manager.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/howto-upload-an-asset-to-asset-manager.md)


# Upload an asset to asset-manager

Some publishing apps such as Mainstream Publisher do not provide the facility for editors to upload
assets such as images and PDFs. In these rare cases, we can upload assets to asset-manager manually
and give the URL to content editors to embed.

Production assets are replicated to staging and integration nightly, so it is best to simply perform
the upload directly in production. First, upload the asset to a backend box:

```
scp my_file.jpg backend-1.backend.production:/tmp/
```

Then ssh to the same box and run the upload command:

```
ssh backend-1.backend.production
cd /var/apps/asset-manager
sudo -u deploy govuk_setenv asset-manager bin/create_asset /tmp/my_file.jpg
```

Note the `basepath` the script outputs. This should be appended to the asset host, for example:

```
https://assets.publishing.service.gov.uk/media/57358658ed915d58bd000000/my_file.jpg
```

