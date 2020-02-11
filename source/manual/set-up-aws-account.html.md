---
owner_slack: "#govuk-developers"
title: Set up your AWS account
section: AWS accounts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-24
review_in: 6 months
old_paths:
  - /manual/user-management-in-aws.html
---

To work with [govuk-aws](https://github.com/alphagov/govuk-aws) and [govuk-aws-data](https://github.com/alphagov/govuk-aws-data),
you will require an account in AWS.

If you already have an AWS user associated with a different team's account, you can continue using it to log in to the AWS console, and then switch roles where necessary using the [`gds-cli`][access-aws-console].

## 1. Request a GDS AWS account

GDS maintains a central account for AWS access. You will need to request an account from the Technology and Operations team.

👉 [Request an AWS account](https://gds-request-an-aws-account.cloudapps.digital)

You'll want to click "Request user access" - NOT "Request an account". After submitting the form, you should receive an email to say your account creation is in progress, and later another email saying the work has been completed. You can then move onto step 2.

## 2. Sign in to AWS

To sign in, go to [the GDS AWS Sign page](https://gds-users.signin.aws.amazon.com/console), and use the following credentials:

- "Account ID or alias": `gds-users`
- Username: your `@digital.cabinet-office.gov.uk` email address
- Password: your password

👉 [Sign in to AWS GDS account](https://gds-users.signin.aws.amazon.com/console)

## 3. Set up your MFA

You have to set up [Multi-Factor Authentication (MFA)][MFA].

1. [Sign in to AWS GDS account](https://gds-users.signin.aws.amazon.com/console)
2. Select or go to IAM service.
3. Click on "Users" in the menu bar on the left hand side
4. Enter your name
5. Click on the link for your email address
6. Click on the security credentials tab
7. Click on the "Manage" link next to "Assigned MFA device"
8. Follow the steps to set up your MFA device

## 4. Generate a pair of access keys

You have to generate an AWS Access Key and Secret Key to be able to
perform operations with AWS on the command-line.

1. [Sign in to the gds-users AWS Console](https://gds-users.signin.aws.amazon.com/console).
1. Click on your email address in the top right.
1. Click 'My Security Credentials'.
1. Click 'Create access key'.
1. Copy/paste them into the inputs that the gds-cli provides for you,
   if you're following [the setup instructions](/manual/access-aws-console.html).

### Changing your MFA device

Follow steps 1 - 7 in [Set up your MFA](#3-set-up-your-mfa). Then:

1. Choose one of the two options (Remove or Resync)
2. Click on the "Manage" link next to "Assigned MFA device"
3. Follow the steps to set up your MFA device. If you're using a
   Yubikey, you must choose "TOTP" device, not "U2F" device, for the
   gds-cli to continue working.

## 4. Get the appropriate access

An account in AWS doesn't give you access to anything, you'll need to be given rights.

Add yourself to a lists of users found in [the data for the infra-security project][infra-terra]. There are 5 groups:

- `govuk-administrators`: people in Reliability Engineering who are working on GOV.UK infrastructure
- `govuk-internal-administrators`: people in GOV.UK who are working on GOV.UK infrastructure including Architects, Lead Developers and anyone else working on the AWS migration
- `govuk-powerusers`: anyone else who can have production access on GOV.UK
- `govuk-platformhealth-powerusers`: as above but for members of the GOV.UK Platform Health team
- `govuk-users`: anyone else who needs integration access on GOV.UK

> Note: There is a limit on the number of people that can be in each group. If you find that the limit has been hit, try and identify any users who no longer need access and can be removed. Otherwise, a new group will need to be created.

The identifier you need to add is called the "User ARN". You can find this by going
to the [users page in AWS IAM][iam] and selecting your profile.

```
arn:aws:iam::<account-id>:user/<firstname.lastname>@digital.cabinet-office.gov.uk
```

After your PR has been merged, someone from the `govuk-administrators`
or `govuk-internal-administrators` group needs to deploy the
`infra-security` project.


## 5. Do your thing 🚀

You can now:

👉 [Deploy AWS infrastructure with Terraform](/manual/deploying-terraform.html)

👉 [Access AWS via the web interface or on the command line][access-aws-console]

[access-aws-console]: /manual/access-aws-console.html
[infra-terra]: https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security
[MFA]: https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication
[iam]: https://console.aws.amazon.com/iam/home?region=eu-west-1#/users
