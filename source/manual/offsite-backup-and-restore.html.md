---
owner_slack: "#2ndline"
title: Offsite backups
section: Backups
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/offsite-backup-and-restore.md"
last_reviewed_on: 2017-01-28
review_in: 6 months
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/2nd-line/offsite-backup-and-restore.md)


# Offsite backups

We use [duplicity](http://duplicity.nongnu.org/) to perform offsite backups. Some
backups are encrypted with GPG before being shipped to an Amazon S3 bucket.

The fingerprint of the key can be found in `hieradata/production.yaml` within
the [govuk-puppet](https://github.com/alphagov/govuk-puppet) repository as
`_: &offsite_gpg_key `.
The key and passphrase are both stored in encrypted hieradata in the
[deployment repository](https://github.gds/gds/deployment),
as `backup::assets::backup_private_gpg_key` and `backup::assets::backup_private_gpg_key_passphrase`
respectively (the same private key is used for all offsite backups).

## Rotating offsite backups GPG keys

Please see
<https://github.gds/pages/gds/opsmanual/infrastructure/howto/rotate-offsite-backup-gpg-keys>

## Restoring offsite backups of a datastore

This requires access to 'production credentials hieradata' to retrieve the
AWS credentials and GPG key to decrypt the backups.

Connect to the machine where you want to restore the backup. For this example,
we will try to restore and unpack a MySQL database on a vagrant vm.

On a fresh VM, you may require the following packages for this exercise,
installing using apt-get:

```
sudo apt-get install duplicity python-pip python-boto mysql-server
```

Using pip:

`sudo pip install s3cmd`

Retrieve the keys and credentials from `github.gds/gds/deployment`
following [these instructions](https://github.gds/gds/deployment/tree/master/puppet#common-actions)

You are looking for:

```
backup::offsite::job::aws_access_key_id
backup::offsite::job::aws_secret_access_key
backup::assets::backup_private_gpg_key
backup::assets::backup_private_gpg_key_passphrase
```

Ensure that you can connect to the S3 bucket:

```
export AWS_ACCESS_KEY_ID=<access_key_id>
export AWS_SECRET_ACCESS_KEY=<secret_access_key>
s3cmd ls s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/govuk-datastores/
```

It may be required to install `awscli` or `s3cmd` onto the machine you're on;
these are both provided by `pip`.

If you receive a `403` error:

`s3cmd ls s3://govuk-offsite-backups-production/govuk-datastores/`

If you can view objects inside the bucket you should have access.

Now you'll be able to see the status of duplicity:

`duplicity collection-status s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/govuk-datastores/`

Create a file containing the GPG key obtained above (`backup::assets::backup_private_gpg_key`)

Import it with:

`gpg --allow-secret-key-import --import <path to GPG key file>`

You can confirm the key has been imported correctly with:

`gpg --list-secret-keys`

Once the key is imported, you'll be able to list files:

`duplicity list-current-files s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/govuk-datastores/`

Download the latest backup with:

`duplicity restore --file-to-restore data/backups/whitehall-mysql-backup-1.backend.publishing.service.gov.uk/var/lib/automysqlbackup/latest.tbz2 s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/govuk-datastores/ /tmp/latest.tbz2`

When this completes you may see the following 'error':

`Error '[Errno 1] Operation not permitted: '/tmp/latest.tbz2'' processing .`

This doesn't seem to have any significant consequences.

When the backup has downloaded extract it:

```
cd /tmp
tar xvjf latest.tbz2
```

Extract the dump that you want to restore:

```
bunzip2 latest/foo.sql.bz2
```

Restore with:

`sudo mysql < foo.sql`

This will restore the contents of file `foo.sql` to the database name that the
dump was taken from, creating it if it doesn't exist (at least that's how the Whitehall test behaved)

## Restoring offsite backups of assets

This shows the example process of restoring files for Whitehall attachments.

SSH to the machine where you want to restore the backup, eg
`asset-master-1.backend`.

Ensure that you can connect to the S3 bucket using the supplied access keys.
To do this, you'll need to use the access keys
which are in the production credentials hieradata as:

```
backup::offsite::job::aws_access_key_id
backup::offsite::job::aws_secret_access_key
```

It may be required to install `awscli` or `s3cmd` onto the machine you're on;
these are both provided by `pip`.

Try to `ls` the destination bucket as described in `hieradata/production.yaml`
in the [govuk-puppet](https://github.com/alphagov/govuk-puppet) repo.

If you're using `s3cmd`, you may have to use global S3 URL.

For example:

```
export AWS_ACCESS_KEY_ID=<access_key_id>
export AWS_SECRET_ACCESS_KEY=<secret_access_key>
aws s3cmd ls s3://govuk-offsite-backups-production/assets-whitehall/
```

If you can view objects inside the bucket you should have access.

Now you'll be able to see the status of duplicity:

`asset-master-1:~$ duplicity collection-status s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/assets-whitehall/`

Import the GPG secret key from the credentials store with:

`asset-master-1:~$ gpg --allow-secret-key-import --import 12345678_secret_key.asc`

You can confirm the key has been imported correctly:

`asset-master-1:~$ gpg --list-secret-keys`

Once the key is imported, you'll be able to list files:

`asset-master-1:~$ duplicity list-current-files s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/assets-whitehall/`

In order to restore the files, you may need to change the owner of the
`/mnt/uploads/whitehall` directory to your user temporarily, and remove
any files that already exist in that directory.

Then run a restore with:

`asset-master-1:~$ duplicity restore --file-to-restore mnt/uploads/whitehall/ s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/assets-whitehall/ /mnt/uploads/whitehall`

Once the backup has restored correctly, make sure you revert all the
manual actions you've taken. These may include:

1.  Changing the owner of the assets files
2.  Removing the secret key from the GPG keyring
    (`gpg --delete-secret-key 12345678`)
