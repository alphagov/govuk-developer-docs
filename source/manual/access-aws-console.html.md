---
owner_slack: "#govuk-developers"
title: Access the AWS Console
section: AWS accounts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-08
review_in: 6 months
---

Accessing AWS is done via a command-line tool called the GDS CLI.

It's a tool that's developed and supported by Reliability Engineering, but open to anyone inside GDS to contribute to. It's written in Go. It's used by many teams across GDS to make daily AWS-related tasks easier.

The (private) GitHub repo is [alphagov/gds-cli](https://github.com/alphagov/gds-cli). There's a [comprehensive README](https://github.com/alphagov/gds-cli#readme).

## Installation

1. Install [Homebrew](https://brew.sh) on macOS or Linux.
1. Run `brew install alphagov/gds/gds-cli` to install from the [GDS Homebrew tap](https://github.com/alphagov/homebrew-gds).
1. Run `gds config yubikey false` if you type AWS MFA codes from your phone.

### First run

You'll be asked for credentials on first run:

```shell
$ gds aws govuk-integration-poweruser -l
Welcome to the GDS CLI! We will now store your AWS credentials in the keychain using aws-vault.
Enter Access Key ID: AK-YOUR-ACCESS-KEY-ID
Enter Secret Access Key: blah blah
Added credentials to profile "gds-users" in vault
Successfully initialised gds-cli
Enter token for arn:aws:iam::123456789012:mfa/firstname.lastname@digital.cabinet-office.gov.uk: 123456
```

Your Access Key is from the AWS console:

![AWS Access Key](images/aws/access-key.png)

If you've forgotten the secret, regenerate it and save your key's secret somewhere safe!

You'll also be prompted to save credentials to your Mac's Keychain as `aws-vault` and set a password for it. Save that password somewhere safe too, like a password manager.

> Note:  If you see `fatal: yubikey: no such path in the working tree`, it's because you're using ZSH, which has `gds` set up as a Git alias. You can either remove that alias by adding `unalias gds` to your `~/.zshrc`, or use `gds-cli` instead of `gds` for all the commands below.

If you have `bash-completion` installed and configured, the gds-cli tab completions will work out of the box. They're especially useful for long commands like AWS account names.

## Re-initialising

If you forget your `aws-vault` password:
1. delete the aws-vault keychain with `rm ~/Library/Keychains/aws-vault-keychain-db`
2. re-initialise the `gds-cli` by changing in `~/.gds/config.yml`:
  ```yaml
  initialised: true
  ```
  to
  ```yaml
  initialised: false
  ```
3. Then re-run the "First run" commands above.


## Get Your Role

Work out which [list of users you're part of in govuk-aws-data][govuk-aws-data-users-group].
You're about to use it in the 'Web Console' section below.

## Usage


### Web Console

If you're new to GOV.UK and want to look around in integration:

        gds aws govuk-integration-readonly -l

If it's the first time you've run this, you'll be prompted for some
access keys and an aws-vault keychain password. Follow the
instructions [on the Set Up AWS Account page](/manual/set-up-aws-account.html).

Replace `readonly` with the non-pluralised version of your role name. For example,
if you want to assume the `govuk-powerusers` role on Staging, you would run
`gds aws govuk-staging-poweruser -l`.

`-l` opens the web browser and logs you in. For a full list of CLI parameters,
consult the [gds-cli README](https://github.com/alphagov/gds-cli).


### Terraform

👉 [Deploy AWS infrastructure with Terraform](/manual/deploying-terraform.html)

### Terminal Commands

You can also chain commands, like this one to list S3 buckets in integration:

        gds aws govuk-integration-poweruser aws s3 ls

[govuk-aws-data-users-group]: /manual/set-up-aws-account.html#4-get-the-appropriate-access
