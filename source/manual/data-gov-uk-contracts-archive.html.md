---
owner_slack: "#govuk-platform-health"
title: Data.gov.uk Contracts Archive
section: data.gov.uk
layout: manual_layout
type: learn
parent: "/manual.html"
last_reviewed_on: 2019-04-05
review_in: 6 months
---

## Contracts archive finder application

Visit the [contracts archive finder](https://data.gov.uk/data/contracts-finder-archive)

Credentials for the AWS account are in the `govuk-secrets` repository under
`2ndline/datagovuk/contracts-finder-archive-aws-console-pass`.

Once logged in to the AWS console, you'll be able to list the EC2 instances and find the IP of the
contracts archive finder. Currently the assigned elastic IP is 34.249.103.20.

If you need to `ssh` on to the machine, you can do so by grabbing the private
key from `govuk-secrets` under
`2ndline/datagovuk/contracts-finder-archive-cert`.

You will need to put the private key into a file and change the permissions to
so it is not publically viewable. For example, if you name the file `aws-dd.pem`
then you can set the permissions as follows:

```
chmod 400 aws-dd.pem
```

You will then be able to `ssh` onto the machine in aws by using the `.pem` file:

```
ssh -i "aws-dd.pem" ubuntu@ec2-34-249-103-20.eu-west-1.compute.amazonaws.com
```

Remember this is an elastic IP and might change - log into the AWS web console
to find the current IP address assigned.

## On data.gov.uk

A database of the contracts archive is also accessible in a sqlite database on
[data.gov.uk](https://data.gov.uk/dataset/97c75a0c-dd9b-42f9-969c-5e667d8c80f1/contracts-finder-archive-2011-to-2015)

## Contract takedown requests

To take down a contract, [`ssh`](#contracts-archive-finder-application) onto the
contracts archive machine and then move the relevant contract attachements to
the redacted folder.

Contracts are located on the machine at `~/src/contracts-archive/instance/documents`. Find the directory for the contract you are trying to redact.
It will be `~/src/contracts-archive/instance/documents/<contract_id>`.

For example if the contract id is `12345` then you will find all the files under
the directory `~/src/contracts-archive/instance/documents/12345`.

Create a new directory in `~/src/contracts-archive/instance/redacted`. Name the
directory the same as the contract id.

Move all the attachments from the `documents/<contract_id>` into the `redacted/<contract_id>` folder.

Note that this method will remove the downloadable attachments, but leave the
contract page available to view on the website. This is fine. You can confirm
that you've redacted the documents by navigating to the contract in the
contracts archive finder application and clicking on the download links for each
attachment. It should return a 404 Not Found.

You should also remove it from Google cache (this will only work
once we've reinstated the [contracts archive
url](https://trello.com/c/T1aZMkTy/510-make-contracts-archive-accessible-on-former-url) and validated with google) using this page:

https://www.google.com/webmasters/tools/url-removal?hl=en&siteUrl=https://data.gov.uk

Click “Temporarily Hide” and provide the URL and then Submit.
