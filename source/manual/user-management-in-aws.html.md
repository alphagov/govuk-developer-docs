---
owner_slack: "#govuk-2ndline"
title: User Management in AWS
section: AWS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-03
review_in: 6 months
---

To work with [govuk-aws](https://github.com/alphagov/govuk-aws) and [govuk-aws-data](https://github.com/alphagov/govuk-aws-data),
you will require an account in AWS.

## GDS central users account

GDS maintains a central account for AWS access. You will need to [request an account](https://gds-request-an-aws-account.cloudapps.digital/) from the Technology and Operations team. To sign in, go to [the gds-users account page](https://gds-users.signin.aws.amazon.com/console), and use the following credentials:

- Account ID or alias: "gds-users"
- Username: your Cabinet Office email address
- Password: your password

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

 - Add you to the list of users found in [the data for the infra-security project](https://github.com/alphagov/govuk-aws-data/tree/master/data/infra-security).
 - Deploy the `infra-security` project

When this has been deployed, you should also gain access to edit this data.

### Switch role

To switch role to a GOV.UK account, you can either do this through the console or command line.

See [details for GOV.UK accounts](https://github.com/alphagov/govuk-aws-data/blob/master/docs/govuk-aws-accounts.md).

#### Console

To switch to the role using the console, see [guidance published by Amazon](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-console.html).

#### CLI

There are two methods to assume roles using the CLI.

Both methods require the following:

 - Role ARN: `arn:aws:iam::<Account ID>:role/<Role Name>` ([Account IDs are here](https://github.com/alphagov/govuk-aws-data/blob/master/docs/govuk-aws-accounts.md) and [Role Names are here](https://github.com/alphagov/govuk-aws/blob/master/terraform/projects/infra-security/main.tf))
 - MFA ARN: the ARN assigned to the MFA device in your account (**be careful not to use your User ARN!**)

Both methods will allow a valid session up to eight hours. Once the hour has
elapsed, you will need to rerun the `assume-role` command. If you want to switch
between environments, you will need to re-authenticate with MFA.

##### Storing credentials on disk

Create `~/.aws/config`:

```
[profile govuk-<environment>]
role_arn = <Role ARN>
mfa_serial = <MFA ARN>
source_profile = gds
region = eu-west-1

[profile gds]
mfa_serial = <MFA ARN>
region = eu-west-1
```

Create `~/.aws/credentials`:

```
[gds]
aws_access_key_id = <access key id>
aws_secret_access_key = <secret access key>
```

> You can get the key ID and secret by following the instructions for IAM based
> access keys
> [here](https://www.cloudberrylab.com/blog/how-to-find-your-aws-access-key-id-and-secret-access-key-and-register-with-cloudberry-s3-explorer/)

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
  --duration-seconds 28800 \
  --token-code <MFA token>
```

If successful, this will output some credentials. Store them in your environment using
the following environment variables. Refresh them when they expire after eight
hours with another `aws sts assume-role` command.

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```
