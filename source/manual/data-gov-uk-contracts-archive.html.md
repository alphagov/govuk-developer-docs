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

The contracts archive currently sits on a publically accessible IP address on
AWS.

Credentials for the AWS account are in the `govuk-secrets` repository under
`2ndline/datagovuk/contracts-finder-archive-aws-console-pass`. Once logged in to the AWS
console, you'll be able to list the EC2 instances and find the IP of the
contracts archive finder.

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
ssh -i "aws-dd.pem" ubuntu@ip-address.eu-west-1.compute.amazonaws.com
```

## On data.gov.uk

A database of the contracts archive is also accessible in a sqlite database on
[data.gov.uk](https://data.gov.uk/dataset/97c75a0c-dd9b-42f9-969c-5e667d8c80f1/contracts-finder-archive-2011-to-2015)
