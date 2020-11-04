---
owner_slack: "#govuk-2ndline"
title: Rotate offsite backup GPG keys
section: Backups
layout: manual_layout
parent: "/manual.html"
---

To encrypt our offsite backups, we use GPG keys which are valid for a year. For
good security practice we rotate these keys each year.

## Generate a new key

When creating a new key it is important you reuse the existing `passphrase` as
otherwise the incremental backup will fail as historical data is unable to be
access/unencrypted previous diffs.

1. Pull the [govuk-secrets repo](https://github.com/alphagov/govuk-secrets).
2. `cd puppet`
3. `gpg2 --batch --gen-key gpg_templates/offsite_backup_gpg_template.txt`
4. Ensure you make a copy of the password you use.
5. Get the key ID you just generated with `gpg2 --list-keys --fingerprint`, and make a copy of the full fingerprint ID.
6. Export _secret_ key: Copy the output of `gpg2 --export-secret-key --armor <key id>`
7. Export _public_ key: Copy the output of `gpg2 --export --armor <key id>` to a public key server, for instance <https://pgp.mit.edu/>

> **NOTE**
>
> Steps 6 and 7 above use different commands for exporting.

## What do I need to update?

The following files need to be updated with the new key details:

- Update the [govuk-puppet hieradata](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/production.yaml),
  updating the `_: &offsite_gpg_key` key with the new fingerprint value.
- Update the [encrypted govuk-secrets repo hieradata](https://github.com/alphagov/govuk-secrets/blob/master/puppet/hieradata/production_credentials.yaml),
  updating both `backup::assets::backup_private_gpg_key` and `backup::assets::backup_private_gpg_key_passphrase` with
  the relevant values.
