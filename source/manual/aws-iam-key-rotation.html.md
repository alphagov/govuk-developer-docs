---
owner_slack: "#govuk-developers"
title: AWS IAM Key Rotation
parent: "/manual.html"
layout: manual_layout
type: learn
section: AWS
---

## Overview

GOV.UK uses [AWS IAM] accounts to manage applications access to our AWS
infrastructure. The [Access Keys] associated with these accounts need to be
[rotated] every 3 months.

Rotating AWS IAM keys requires permissions which are available with the `admin`,
`internal-admin`, `platformhealth-poweruser` or `poweruser` roles. You'll be
able to rotate keys only if you can assume one of these roles.

## How to rotate Access Keys

Log in to the [IAM Management Console] in the environment you want to rotate
keys for and you'll see a list of users and the age of their access keys.

### 1. Find users access key

- Click on the user whose key you want to rotate.
- Click on the `Security Credentials` tab.

Users should always only have one access key. The only time a user should have
two keys is when we are in the process of rotating the key that is in use. For
this reason, AWS allow users to have a maximum of two Access Keys at the same
time.

- Make a note of the `Access Key ID`.
- Proceed to [find out if the key is used](#2-find-out-if-the-key-is-used).

> **Note**
>
> If a user has two keys, the first task is to remove one of them.
>
> If one key [is not in use](#2-find-out-if-the-key-is-used), you can
> [remove it](#6-remove-the-old-key) and rotate the other key (keep reading to
> see how).
>
> If both keys are in use, you need to pick one and
> [replace all uses of it](#3-find-where-the-key-is-used) with the other key.
> Then, once it's no longer in use, you can [remove it](#6-remove-the-old-key)
> and rotate the other key (keep reading to see how).

### 2. Find out if the key is used

- Check the `Last used` value.
- If the value is a date,
  [find where the key is used](#3-find-where-the-key-is-used).
- If it's `N/A`, you can safely [remove the key](#6-remove-the-old-key) as it
  isn't used.

### 3. Find where the key is used

The first place you should look is the [GOV.UK AWS User Keys spreadsheet][user-keys-list].
Someone may already have done the work of logging where the key is used.
If they haven't, you'll need to follow the manual steps below (and should
update the spreadsheet with your findings when you're done).

When searching for keys, keep in consideration that they may be present in
[govuk-secrets] or in the control panel of 3rd party services, such as Fastly or
Logit. Keys may also be shared across AWS and Carrenza environments.

Firstly, search for the key in [govuk-secrets]:

- Enter [govuk-secrets/puppet] in your machine.
- Run the appropriate [Puppet AWS common actions] considering the following:
  - The command to run is related to the environment you need to target. For
    example, to edit global staging credentials in the `govuk::apps` namespace,
    you need to run `bundle exec rake 'eyaml:edit[staging,apps]'`.
  - You may need to run more than one command. For example, to edit the global
    integration credentials both in and out of the `govuk::apps` namespace, you
    need run both `$ bundle exec rake 'eyaml:edit[integration]'` and
    `$ bundle exec rake 'eyaml:edit[integration,apps]'`.
- Search for the `Access Key ID` in the result.

Repeat the previous steps for [govuk-secrets/puppet_aws]:

- Enter [govuk-secrets/puppet_aws].
- Run the same command(s) again.
- Search for the `Access Key ID` in the result.

Keys may also be defined in more then one place. For example, the hieradata
values `govuk::apps::support::aws_access_key_id` and
`govuk::apps::support_api::aws_access_key_id` contain the same key.

Secondly, search for the key in the control panel of 3rd party services we use,
for example, Fastly or Logit.

If it isn't present in `govuk-secrets` hieradata, nor in any 3rd party services,
you can safely [remove the key](#6-remove-the-old-key).

### 4. Create and deploy new key

- Click `Create access key` in `Security credentials`.
- If the key to change was in a 3rd party service:
  - Replace the old `Access Key ID` and `Secret access key` with the new ones.
- If the key to change was in `govuk-secrets`:
  - Replace the old `Access Key ID` and `Secret access key` with the new ones.
  - Redeploy [govuk-puppet] so it picks up the new key.
  - Either wait up to 30 minutes for this to take effect or run
  `govuk_puppet --verbose` in the machine that uses that key.

#### Rotating SES SMTP credentials

The SMTP credentials for SES are connected to a user in IAM, but they are
separate to the security credentials. As of August 2020, to rotate SMTP
credentials, the user needs to be re-created and the new credentials will
be displayed. They cannot be rotated after that point.

When creating the new user, it's sensible to append the current date
(such as `.YYYYMMDD`) to the username so it's easy to see when the user
was created and the username won't conflict with the existing user. This
allows both credentials to be available at the same time while switching over.
The old user can be deleted once the app is using the new credentials.

See [this PR][smtp-rotation-pr] for an example and the relevant [AWS documentation
on obtaining SES credentials][aws-ses-credentials].

[smtp-rotation-pr]: https://github.com/alphagov/govuk-secrets/pull/1032
[aws-ses-credentials]: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-credentials.html

### 5. Ensure new key is being used

Ensure that the `Last used` values change to show that the new key is being
used and the old key is not used. Keys that are used infrequently may take a
while to update and updates can take a few minutes to show in the control panel.

If the `Last used` time of the old key continues to change, the key has not been
completely removed so you'll need to
[find where the key is used](#3-find-where-the-key-is-used) again.

If the `Last used` time of the old key doesn't change anymore, you can
[remove the key](#6-remove-the-old-key).

### 6. Remove the old key

Old keys can either be deleted or made inactive. Making the key inactive will
prevent the key from being used, but it can quickly be made active again. This
is useful if you are not confident that all uses of the key have been updated.
In production systems, this could prevent minor outages scaling into incidents.

- Notify [2ndline] that you are about to delete a key or make a key inactive.
- Click `Make inactive` to inactivate the key or click the `X` to delete it.

## Command Line Interface

It's also possible to view and update access keys with the [AWS CLI].

[AWS IAM]: https://docs.aws.amazon.com/en_pv/IAM/latest/UserGuide/id_users.html
[Access Keys]: https://docs.aws.amazon.com/en_pv/IAM/latest/UserGuide/id_credentials_access-keys.html
[rotated]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_RotateAccessKey
[IAM Management Console]: https://console.aws.amazon.com/iam/home?region=eu-west-1#/users
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
[govuk-secrets/puppet]: https://github.com/alphagov/govuk-secrets/tree/master/puppet
[Puppet AWS common actions]: https://github.com/alphagov/govuk-secrets/tree/master/puppet_aws#common-actions
[govuk-secrets/puppet_aws]: https://github.com/alphagov/govuk-secrets/tree/master/puppet_aws
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[2ndline]: /manual/2nd-line.html
[AWS CLI]: https://aws.amazon.com/blogs/security/how-to-rotate-access-keys-for-iam-users/
[user-keys-list]: https://docs.google.com/spreadsheets/d/1L6H3-wh9J1p18fjnODmit2WbGOA8wZgr5wL-5wN0IgE/edit#gid=0
