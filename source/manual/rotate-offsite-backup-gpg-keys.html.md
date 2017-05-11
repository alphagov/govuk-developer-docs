---
owner_slack: "#2ndline"
title: Rotate offsite backup GPG keys
section: Backups
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/rotate-offsite-backup-gpg-keys.md"
last_reviewed_on: 2016-12-25
review_in: 6 months
---

> **This page was imported from [the opsmanual on GitHub Enterprise](https://github.digital.cabinet-office.gov.uk/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.digital.cabinet-office.gov.uk/gds/opsmanual/tree/master/infrastructure/howto/rotate-offsite-backup-gpg-keys.md)


To encrypt our offsite backups, we use GPG keys which are valid for a year. For
good security practice we rotate these keys each year.

## Generate a new key

1. Pull the [deployment repo](https://github.digital.cabinet-office.gov.uk/gds/deployment).
2. `cd deployment/puppet`
3. `gpg2 --batch --gen-key gpg_templates/offsite_backup_gpg_template.txt`
4. Ensure you make a copy of the password you use.
5. Get the key ID you just generated with `gpg2 --list-keys --fingerprint`, and make a copy of the full fingerprint ID.
6. Copy the output of `gpg2 --export-secret-key --armor <key id>`

## What do I need to update?

The following files need to be updated with the new key details:

Update the [govuk-puppet hieradata](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/production.yaml),
updating the `_: &offsite_gpg_key` key with the new fingerprint value

Update the [encrypted deployment repo hieradata](https://github.digital.cabinet-office.gov.uk/gds/deployment/blob/master/puppet/hieradata/production_credentials.yaml),
updating both `backup::assets::backup_private_gpg_key` and `backup_private_gpg_key_passphrase` with
the relavant values.
