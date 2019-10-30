---
title: AWS IAM Key Rotation
parent: "/manual.html"
layout: manual_layout
type: learn
section: AWS
owner_slack: "#govuk-developers"
last_reviewed_on: 2019-10-31
review_in: 6 months
---

## Overview

GOV.UK uses AWS [IAM](https://docs.aws.amazon.com/en_pv/IAM/latest/UserGuide/id_users.html)
accounts to manage applications access to our AWS infrastructure. The
[Access Keys](https://docs.aws.amazon.com/en_pv/IAM/latest/UserGuide/id_credentials_access-keys.html)
associated with these accounts need to be [rotated](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_RotateAccessKey)
every 3 months.

## How to rotate Access Keys

Log in to the [IAM Management Console](https://console.aws.amazon.com/iam/home?region=eu-west-1#/users)
for the environment you want to rotate keys for and you'll see a list of users
and the age of their access keys.

### Find users access key

Click on the user who's key you want to rotate, then click on "Security Credentials"
to see their access key.

### 1. Find where the key is used

Make a note of the Access Key ID and find where this access key is defined in
[govuk-secrets](https://github.com/alphagov/govuk-secrets). Keys may also be
defined in control panels for 3rd party services such as Fastly or Logit. Keys
may also be defined in more then one place, for example the hieradata values
`govuk::apps::support::aws_access_key_id` and
`govuk::apps::support_api::aws_access_key_id` contain the same key. Keys may
also be shared across AWS and Carrenza environments.

### 2. Create and deploy new key

Now create a new access key and update the Access Key ID and Secret access key
in [govuk-secrets](https://github.com/alphagov/govuk-secrets/tree/master) or the
3rd party service. If the change is in `govuk-secrets` then
[govuk-puppet](https://github.com/alphagov/govuk-puppet) will need to redeployed
to pick up the new keys.

Users can have a maximum of 2 access keys. If a user already has 2 keys then one
key will need to be removed before a new key can be added. If this key is still
active then you'll need to
[find where the key is used](#1-find-where-the-key-is-used) and then
[remove the key](#4-remove-the-old-key).

### 3. Ensure new key is being used

Once the new key have been deployed wait until the “Last used” values change
to show that the new key is being used and the old key is not used. Infrequently
used keys may take a while to update, and updates can take a few minutes to show
in the control panel.

If the last used time of the old key continues to change this indicates it
has not been completely removed so you'll need to
[find where the key is used](#1-find-where-the-key-is-used) before it can be
[safely deleted](#4-remove-the-old-key).

### 4. Remove the old key

The old key can either be deleted or made inactive. Making the key inactive will
prevent the key from being used, but it can quickly be made active again. This
is useful if you are not confident that all uses of the key have been updated or
in production systems this could prevent a minor outage scaling into an
incident.

Notify [2ndline](/manual/2nd-line.html) before deleting or making any production
key inactive.

## Command Line Interface

It's also possible to view and update access keys with the
[AWS CLI](https://aws.amazon.com/blogs/security/how-to-rotate-access-keys-for-iam-users/).
