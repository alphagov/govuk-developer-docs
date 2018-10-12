---
owner_slack: "#govuk-2ndline"
title: Set up your AWS account
section: AWS accounts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-03
review_in: 6 months
old_paths:
  - /manual/user-management-in-aws.html
---

To work with [govuk-aws](https://github.com/alphagov/govuk-aws) and [govuk-aws-data](https://github.com/alphagov/govuk-aws-data),
you will require an account in AWS.

## 1. Request a GDS AWS account

GDS maintains a central account for AWS access. You will need to request an account from the Technology and Operations team.

👉 [Request an account](https://gds-request-an-aws-account.cloudapps.digital)

## 2. Sign in to AWS

To sign in, go to [the GDS AWS Sign page](https://gds-users.signin.aws.amazon.com/console), and use the following credentials:

- "Account ID or alias": `gds-users`
- Username: your `@digital.cabinet-office.gov.uk` email address
- Password: your password

👉 [Sign in to AWS GDS account](https://gds-users.signin.aws.amazon.com/console)

## 3. Set up your MFA

You have to set up [Multi-Factor Authentication (MFA)][MFA].

## 4. Get the appropriate access

An account in AWS doesn't give you access to anything, you'll need to be given rights.

Add yourself to a lists of users found in [the data for the infra-security project][infra-terra]. There are 3 groups:

- `govuk-administrators`: people in Reliability Engineering who are working on GOV.UK infrastructure, Architects and Lead Developers of GOV.UK and anyone else working on the AWS migration
- `govuk-powerusers`: anyone else who can have production access on GOV.UK
- `govuk-users`: anyone else who needs integration access on GOV.UK

The identifier you need to add is called the "User ARN". You can find this by going
to the [users page in AWS IAM][iam] and selecting your profile.

```
arn:aws:iam::<account-id>:user/<firstname.lastname>@digital.cabinet-office.gov.uk
```

After your PR has been merged, someone from the `govuk-administrators` group needs to deploy the `infra-security` project.

👉 [Deploy AWS infrastructure with Terraform](/manual/deploying-terraform.html)

## 5. Do your thing 🚀

You can now:

👉 [Access a thing in AWS console](/manual/aws-console-access.html)

👉 [Use AWS on the command line](/manual/aws-cli-access.html)

[infra-terra]: https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security
[MFA]: https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication
[iam]: https://console.aws.amazon.com/iam/home?region=eu-west-1#/users
