---
owner_slack: "#2ndline"
title: Replicate application data locally for development
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-11-22
review_in: 6 months
---

Dumps are generated from production data in the early hours each day, and can
then be downloaded from integration (AWS).  The process is managed by the
[replicate-data-local.sh](https://github.com/alphagov/govuk-puppet/blob/master/development-vm/replication/replicate-data-local.sh)
script within the [govuk-puppet
repository](https://github.com/alphagov/govuk-puppet).

> The Licensify and Signon databases aren't synced out of production because of
> security concerns. Mapit's database is downloaded in the Mapit repo, so won’t
> be in the backups folder.

## Caveat

If the download process takes longer than an hour it will stop due to your AWS token expiring. When this happens simply restart the process, which will generating a new token, it should resume downloading from where it left off.

## Pre-requisites to importing data

To get production data on to your local VM, you'll need to have either:

* access to integration via aws; or
* database exports from someone that does.

## AWS access

The [AWS setup guide](/manual/user-management-in-aws.html) covers using the interface in full, however if you only
want to do developer replication you will need to:

### Log into AWS

You should have received a email requesting you do this. If you have multiple AWS accounts ensure you are logged into `gds-users`

### Setup MFA/2FA on your device

Navigate to `IAM -> Users -> <Your username>`

If you don't see an ARN ID next to `Assigned MFA device` click the edit button and set one up.

### Create an access token

Under `Access keys` click `Create access key` – you will secret is only displayed once, however if you fail to note it down just remove it and create another.

### Install the AWS CLI application locally

On macOS this can be done using `brew install awscli`. This is being installed locally with the assumption you will be doing a two step backup process, i.e. download the files on your local machine and then update you VM. This is the recommended process as the download is quicker to you local machine for most users.

### Setup your AWS access config and credentials files

I am repeating the instructions described in the [AWS setup guide](/manual/user-management-in-aws.html) with one difference. In the credentials file the setting must be under default as otherwise they are not found by the replication script.

Create a `~/.aws/config` file:

```
[profile govuk-integration]
role_arn = <Role ARN>
mfa_serial = <MFA ARN>
source_profile = gds
region = eu-west-1
```

#### Role ARN
Should be one of the following depending on the level of access you have been configured with [here](https://github.com/alphagov/govuk-aws-data/blob/master/data/infra-security/integration/common.tfvars):

  * govuk-admins

    ```
    arn:aws:iam::<ACCOUNT-ID>:role/govuk-administrators
    ```

  * govuk-poweruser:

    ```
    arn:aws:iam::<ACCOUNT-ID>:role/govuk-poweruser
    ```

  * govuk-users:

    ```
    arn:aws:iam::<ACCOUNT-ID>:role/govuk-users
    ```

  The account IDs are in the govuk-aws-data repo's [docs on govuk-aws-accounts](https://github.com/alphagov/govuk-aws-data/blob/master/docs/govuk-aws-accounts.md)

####MFA ARN

This is the long string next to `Assigned MFA device` in the AWS console

Create a `~/.aws/credentials` file

```
[gds]
aws_access_key_id = <access key id>
aws_secret_access_key = <secret access key>
```

**AWS access key id**: This is the ID that we created earlier

**AWS secret access key**: This is the secret associated with the key we created earlier. If you didn't note these down you can simply create a new one.

## If you have integration access

If you have integration access, you can download and import the latest data by running:

    mac$ cd ~/govuk/govuk-puppet/development-vm/replication
    mac$ ./replicate-data-local.sh -u $USERNAME -F ../ssh_config -n

> You may be able to skip the -u and -F flags depending on your setup

The data will download to a folder named with today's date in `./backups`, for example `./backups/2018-01-01`.

then

    dev$ cd /var/govuk/govuk-puppet/development-vm/replication
    dev$ ./replicate-data-local.sh -d path/to/dir -s

> You can skip the -d flag if you do this on the say day as the download

> Databases will take a long time to download. They'll also take up a lot of
> disk space (up to ~30GB uncompressed). The process will also take up a bunch
> of compute resource as you import the data.

## If you don't have integration access

If you don't have integration access, ask someone to give you a copy of their
dump. Then, from `govuk-puppet/development-vm/replication` run:

    dev$ ./replicate-data-local.sh -d path/to/dir -s

## Downloading data for later import

You may want to download the data while in the office and restore it overnight
to minimise disruption (or to provide to someone who doesn't have integration
access).  First, do the download on your host, as the unzipping is a lot
quicker when not run over NFS:

    mac$ ./replicate-data-local.sh -u $USERNAME -n

Then follow the instructions above for importing using the `-s` flag.

## If you're running out of disk space

See [running out of disk space in development](/manual/development-disk-space.html).

## If you get a curl error when restoring Elasticsearch data

Check the service is running:

    dev$ sudo service elasticsearch-development.development start

## Can't take a write lock while out of disk space (in MongoDB)

You may see such an error message which will prevent you from creating or even dropping collections. So you won't be able to replicate the latest data.

You will need to delete large Mongo collections to free up space before they can be re-imported. Follow this [guide on how to delete them, and ensure that Mongo honours their removal](https://caffinc.github.io/2014/07/mongodb-cant-take-a-write-lock-while-out-of-disk-space/).

Find your biggest Mongo collections by running:

```
dev$ sudo ncdu /var/lib/mongodb
```

You can re-run the replication but skip non-Mongo imports like MySQL if it's already succesfully imported. Use
```
replicate-data-local.sh --help
```
to see the options.

For example, to run an import but skip MySQL and Elasticsearch:

```
dev$ replicate-data-local.sh -q -e -d backups/2017-06-08 -s
```

## Upgrading to Elasticsearch 2.4.6

If you have been running Elasticsearch 1.x.x in the development machine at some point the puppet run will install version 2.4.6. After this you will need to remove some plugins and the re-import the data in order for it to work with this version. In the `govuk-puppet/development-vm` you can run the script `fix-elasticsearch-2.4.sh`. This will remove any incompatible plugins and also delete the data from the previous version. After this you can replicate the Elasticsearch data again by running `./replicate-data-local.sh -u $USERNAME -m -p -q -t` from the `replication` directory.
