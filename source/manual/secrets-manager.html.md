---
owner_slack: "#govuk-platform-engineering"
title: Retrieve shared credentials from AWS Secrets Manager
section: 2nd line
layout: manual_layout
parent: "/manual.html"
---

> ⚠️ To keep GOV.UK secure, please do not create new shared credentials or
> shared user accounts.
>
> For any new service, all human users should have individual accounts and
> these should be linked to the person's identity via single-sign-on.
>
> If in doubt, ask
> [govuk-platform-engineering@](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-platform-engineering/members).

Sharing user accounts is bad for security and you must avoid doing so where
possible. Sometimes shared accounts are unavoidable, for example where a legacy
application lacks support for single-sign-on.

In cases where shared credentials are a necessary evil, we use [AWS Secrets
Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/)
to control access to them. This is the same system that we use for
machine-readable secrets.

## Retrieve a credential from Secrets Manager

1. Log into the __production__ AWS account.
1. Choose [Secrets
   Manager](https://eu-west-1.console.aws.amazon.com/secretsmanager/listsecrets?region=eu-west-1)
   from the Services menu.
1. Search for `2ndline`.
1. Choose the credential that you need.
1. Under __Secret value__, choose the __Retrieve secret value__ button on the
   right-hand side.

You can also access Secrets Manager via AWS CLI commands, for example [aws
secretsmanager
get-secret-value](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/secretsmanager/get-secret-value.html).

## Rotate a credential

Retrieve the credential, then press __Edit__.

## Further information

For any further detail about using Secrets Manager, see the inline
documentation in the AWS console or the [User
Guide](https://docs.aws.amazon.com/secretsmanager/latest/userguide/).

## Rationale for Secrets Manager

Secrets Manager replaced the previous [govuk-secrets shared password
store](https://github.com/alphagov/govuk-secrets/) in February 2024. Using
Secrets Manager gives us:

- a durable audit trail, so in a security event we can at least find out
  retrospectively all the times any given item was accessed and by whose IAM
  credentials
- access control via our existing IAM roles, so access is updated automatically
  for leavers and joiners, which eliminates error-prone manual processes

The Secrets Manager user interface is not primarily designed for this use case
of a shared password store for teams, but it's arguably no worse than
govuk-secrets was.
