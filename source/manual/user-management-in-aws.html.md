---
owner_slack: "#govuk-infrastructure"
title: User Management in AWS
section: AWS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-01-11
review_in: 3 months
---

To work with [govuk-aws](https://github.com/alphagov/govuk-aws) and [govuk-aws-data](https://github.com/alphagov/govuk-aws-data),
you will require an account in AWS.

## GDS central users account

GDS maintain a central account for AWS access. Please see the [guidance]() for further information.

Ensure that you create both [MFA](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication)
and [access keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) once
you have access to your account.

Make a note of the ARN of the "Assigned MFA device". The format will be:

`arn:aws:iam::<account-id>:mfa/firstname.lastname@digital.cabinet-office.gov.uk`

## Switching roles to GOV.UK accounts

### Add your ARN to GOV.UK account role

Find your "User ARN". This is located under your users profile within IAM in the central account.

The format will be:

`arn:aws:iam::<account-id>:user/firstname.lastname@digital.cabinet-office.gov.uk`

You will need someone who already has access to the account you wish to get access to.

They will need to:

 - add you to the list of users found in [the data for the infra-security project](https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security).
 - deploy the `infra-security` project

When this has been deployed, you should also gain access to edit this data.

### Switch role

To switch role to a GOV.UK account, you can either do this through the console or command line.

See [details for GOV.UK accounts](https://github.com/alphagov/govuk-aws-data/blob/master/docs/govuk-aws-accounts.md).

#### Console

To switch to the role using the console, see [guidance published by Amazon](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-console.html).

#### CLI

There are two methods to assume roles using the CLI.

Both methods require the following:

 - Role ARN: this is the ARN of the role that you are using for the GOV.UK specific account, eg govuk-administrators
 - MFA ARN: this is the ARN assigned to the MFA device in your own account

Both methods will allow a valid session up to an hour. After one hour, you will be prompted
for an MFA token again.

##### Storing credentials on disk

Create `~/.aws/config`:

```
[profile govuk-<environment>]
role_arn = <Role ARN>
mfa_serial = <MFA ARN>
source_profile = gds
region = eu-west-1
```

Create `~/.aws/credentials`:

```
[gds]
aws_access_key_id = <access key id>
aws_secret_access_key = <secret access key>
```

To test the configuration, use [`awscli`](https://aws.amazon.com/cli/).

`aws --profile govuk-<environment> s3 ls`

You should be prompted for an MFA token. If successful, you should receive some output.

##### Exporting credentials to environment

Ensure [`awscli`](https://aws.amazon.com/cli/) is installed. Ensure you have your
MFA token ready, and run:

```
aws sts assume-role \
  --role-session-name "$(whoami)-$(date +%d-%m-%y_%H-%M)" \
  --role-arn <Role ARN> \
  --serial-number <MFA ARN> \
  --token-code <MFA token>
```

If successful, this will output some credentials. Store them in your environment using
these environment variables:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```
