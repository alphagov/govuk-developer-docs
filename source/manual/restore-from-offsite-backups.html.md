---
owner_slack: "#2ndline"
title: Restore from offsite backups
section: Backups
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/2nd-line/offsite-backup-and-restore.md"
last_reviewed_on: 2017-10-09
review_in: 6 months
---

We use [Duplicity][duplicity] to perform offsite backups. Some backups are
encrypted with GPG before being shipped to an Amazon S3 bucket.

You will find the fingerprint of the key in `hieradata/production.yaml` within
the [govuk-puppet][govuk-puppet] repository. The key and passphrase are both
stored in encrypted hieradata in the [govuk-secrets repository][govuk-secrets].
The same private key is used for all offsite backups.

## Prerequisites for restoring backups

On the machine where you want to restore the backup:

### VM requirements

For the backup and restore drill, you will restore and unpack a MySQL database
on a Vagrant VM.

On a fresh VM, you may require the following packages for this exercise:

#### Packages via `apt-get`

```shell
sudo apt-get install duplicity python-pip python-boto mysql-server
```

#### Python libs via `pip`

```shell
sudo pip install s3cmd
```

### Set up GPG keys to decrypt backups

You will need access to production hieradata credentials to retrieve the AWS
credentials and GPG key to decrypt the backups.

1. Retrieve the keys and credentials from the
   [govuk-secrets repo][govuk-secrets] following
   [these instructions](https://github.com/alphagov/govuk-secrets/tree/master/puppet#common-actions)

  * You are looking for:

    ```yaml
    backup::offsite::job::aws_access_key_id
    backup::offsite::job::aws_secret_access_key
    backup::assets::backup_private_gpg_key
    backup::assets::backup_private_gpg_key_passphrase
    ```

  * If you are performing the 2nd line backup drill, you will want to use the
    production credentials

2. Ensure that you can connect to the S3 bucket:

    ```bash
    export AWS_ACCESS_KEY_ID=<access_key_id>
    export AWS_SECRET_ACCESS_KEY=<secret_access_key>
    s3cmd ls s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/govuk-datastores/
    ```

  * If you receive a `403` error, try:

    ```bash
    s3cmd ls s3://govuk-offsite-backups-production/govuk-datastores/
    ```

    If you can view objects inside the bucket you now have access.

3. Now you can see the status of duplicity:

    ```bash
    duplicity collection-status s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/govuk-datastores/
    ```

#### Import key on machine

On the machine where you'll be running the restore:

1. Create a file containing the `backup::assets::backup_private_gpg_key`
   [GPG key](#gpg-keys-for-decrypting-backups).

2. Import it with:

    ```bash
    gpg --allow-secret-key-import --import <path to GPG key file>
    ```

    * Confirm the key has been imported correctly with:

      ```bash
      gpg --list-secret-keys
      ```

3. Once the key is imported, you'll be able to list files:

    ```bash
    duplicity list-current-files s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/govuk-datastores/
    ```

    This will take a long time to complete and you will need to enter the
    password found in `backup::assets::backup_private_gpg_key_passphrase`.

## Restore datastore from offsite backups

### Download a backup

1. Download the latest backup with:

    ```bash
    duplicity restore --file-to-restore data/backups/whitehall-mysql-backup-1.backend.publishing.service.gov.uk/var/lib/automysqlbackup/latest.tbz2 s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/govuk-datastores/ /tmp/latest.tbz2
    ```

    * When this completes you may see the following 'error':

      ```
      Error '[Errno 1] Operation not permitted: '/tmp/latest.tbz2'' processing .
      ```

      This doesn't seem to have any significant consequences and can be
      ignored.

### Restore a backup

**Note**: If performing this as part of the 2nd line drill with the whitehall
backup above, please note that this may require a lot of free disk space as
the whitehall database is large - ~10GB as of Sept 2017.

To make space, first drop your dev VM's `whitehall_development` database. Note
after you import the sql, you will end up with a `whitehall_production`
database.

1. Extract the downloaded backup

    ```bash
    cd /tmp
    tar xvjf latest.tbz2
    ```

2. Extract the dump that you want to restore:

    ```bash
    bunzip2 latest/foo.sql.bz2
    ```

3. Restore with:

    ```bash
    sudo mysql < foo.sql
    ```

This will restore the contents of file `foo.sql` to the database name that the
dump was taken from, creating it if it doesn't exist.

## Restore assets from offsite backups

This shows the example process of restoring files for Whitehall attachments.

**Note**: Ensure that you can connect to the S3 bucket using the supplied
access keys. To do this, follow the
[Prerequisites for restoring backups](#prerequisites-for-restoring-backups)
section.

1. SSH to the machine where you want to restore the backup, for example
   `asset-master-1.backend`.

2. `ls` the destination bucket

    ```bash
    export AWS_ACCESS_KEY_ID=<access_key_id>
    export AWS_SECRET_ACCESS_KEY=<secret_access_key>
    s3cmd ls s3://govuk-offsite-backups-production/assets-whitehall/
    ```

    * If you can view objects inside the bucket you should have access.
    * The buckets are as described in [`hieradata/production.yaml` in the
      govuk-puppet repo][hieradata-production-yaml].

3. Now you'll be able to see the status of duplicity:

    ```bash
    duplicity collection-status s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/assets-whitehall/
    ```

4. Import the GPG secret key from the credentials store as per the section to
[Set up GPG keys to decrypt backups](#set-up-gpg-keys-to-decrypt-backups).

5. Once the key is imported, you can list files:

    ```bash
    duplicity list-current-files s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/assets-whitehall/
    ```

5. In order to restore the files, you may need to change the owner of the
`/mnt/uploads/whitehall` directory to your user temporarily, and remove any
files that already exist in that directory.

6. Run a restore:

    ```bash
    duplicity restore --file-to-restore mnt/uploads/whitehall/ s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-production/assets-whitehall/ /mnt/uploads/whitehall
    ```

#### Clean up

Once the backup has restored correctly, make sure you revert all the manual
actions you've taken. These may include:

1. Changing the owner of the assets files.

2. Removing the secret key from the GPG keyring
   (`gpg --delete-secret-key 12345678`).

## Rotating offsite backups GPG keys

Please see [Rotating offsite backup GPG keys][rotate-offsite-backup-gpg-keys].

[duplicity]: http://duplicity.nongnu.org
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[hieradata-production-yaml]: https://github.com/alphagov/govuk-puppet/blob/master/hieradata/production.yaml
[rotate-offsite-backup-gpg-keys]: rotate-offsite-backup-gpg-keys.html
