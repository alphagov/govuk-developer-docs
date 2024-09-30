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

## Set up OTP from 2FA seed

Some of our 'secrets' are for shared accounts which require 2FA to log in. They may have a "2fa-seed" part of the secret that looks a bit like this: `otpauth://totp/YOUR_IDENTIFICATION?secret=YOUR_SECRET`.

You can get a One-Time-Password by copying and pasting the secret (`YOUR-SECRET` in the example above) into totp-cli (installed via `brew install totp-cli`):

```
totp-cli instant
# paste the secret, hit Enter
```

The above approach requires getting the secret from Secrets Manager every time you want to log into the shared account. If you anticipate logging in regularly, you can set up the OTP in your authenticating app by generating an ASCII QR code from the 2fa-seed:

```
# needed for `display` command
brew update && brew install imagemagick

# needed for qrencode
brew install qrencode

qrencode -o- -d 300 -s 10 "otpauth://totp/YOUR_IDENTIFICATION?secret=YOUR_SECRET" | display
```

The above outputs a QR code you can take a picture of from your authenticator app. You can then get a new OTP from the authenticator app whenever you want to log in.

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
