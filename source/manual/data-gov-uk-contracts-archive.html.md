---
owner_slack: "#govuk-datagovuk"
title: Data.gov.uk Contracts Archive
section: data.gov.uk
layout: manual_layout
type: learn
parent: "/manual.html"
---

## Application

Visit the [contracts archive finder](https://data.gov.uk/data/contracts-finder-archive).

Credentials for the AWS account are in the `govuk-secrets` repository under
`2ndline/datagovuk/contracts-finder-archive-aws-console-pass`.

Once logged in to the AWS console, you'll be able to list the EC2 instances and
find the IP of the contracts archive finder.

If you need to `ssh` on to the machine, you can do so by grabbing the private
key from `govuk-secrets` under
`2ndline/datagovuk/contracts-finder-archive-cert`.

You will need to put the private key into a file and change the permissions so
it is not publicly viewable before you can use it.

You can do this as follows:

```sh
$ cd ~/govuk/govuk-secrets
$ PASSWORD_STORE_DIR=~/govuk/govuk-secrets/pass/2ndline pass datagovuk/contracts-finder-archive-cert > govuk-contracts-archive.pem
$ chmod 400 govuk-contracts-archive.pem
```

You will then be able to `ssh` onto the machine in AWS by using the `.pem`
file:

```sh
$ ssh -i "govuk-contracts-archive.pem" ubuntu@<ip address>
```

## Snapshot

There is a point in time snapshot of the contracts archive finder, should you
need to access older log files.

This is setup on the same AWS account as an EC2 instance called
`2019-contracts-archive`. To access this machine, use the same certificate as
above and `ssh` in as follows:

```sh
$ ssh -i "govuk-contracts-archive.pem" ubuntu@<ip address>
```

This machine includes Nginx logs from two periods:

* June 9 to June 26 2018 - available at `/mount-old-arch/var/log/nginx`
* March 9 to March 19 2019 - available at `/var/log/nginx`

The machine was created from two snapshots that are sitting in the AWS account.
These have the following descriptions:

* contract-finder (started June 26 2018)
* snapshot_contracts_20190319 (started March 19 2019)

## On data.gov.uk

A database of the contracts archive is also accessible in a sqlite database on
[data.gov.uk][dataset]

[dataset]: https://data.gov.uk/dataset/97c75a0c-dd9b-42f9-969c-5e667d8c80f1/contracts-finder-archive-2011-to-2015

## Takedown requests

To take down a contract, [`ssh`](#contracts-archive-finder-application) onto
the contracts archive machine and then move the relevant contract attachments
to the redacted folder.

Contracts are located on the machine at
`~/src/contracts-archive/instance/documents`. Find the directory for the
contract you are trying to redact. It will be
`~/src/contracts-archive/instance/documents/<contract_id>`.

For example if the contract id is `12345` then you will find all the files
under the directory `~/src/contracts-archive/instance/documents/12345`.

Create a new directory in `~/src/contracts-archive/instance/redacted`. Name the
directory the same as the contract id.

Move all the files from the `documents/<contract_id>` into the
`redacted/<contract_id>` folder.

Note that this method will remove the downloadable attachments, but leave the
contract page available to view on the website. This is fine. You can confirm
that you've redacted the documents by navigating to the contract in the
contracts archive finder application and clicking on the download links for
each attachment. It should return a 404 Not Found.  This may require adding a
cachebust string to the download URL.

You should also remove it from Google cache (this will only work once we've
reinstated the using this page:

<https://www.google.com/webmasters/tools/url-removal?hl=en&siteUrl=https://data.gov.uk>

Click “Temporarily Hide” and provide the URL and then Submit.
