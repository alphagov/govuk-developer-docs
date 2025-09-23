---
owner_slack: "#govuk-platform-engineering"
title: Convert an unencrypted AWS RDS instance into an encrypted one
section: Backups
layout: manual_layout
parent: "/manual.html"
---

This playbook describes how to convert an AWS RDS instance which does not have encryption at rest enabled, into an encrypted at rest instance.

These instructions will incur around 1 to 2 hours of downtime. It is possible to do this with only a minute or so downtime, but this requires
manually setting up logical replication to a secondary RDS instance which is beyond the scope of this guide.

## Overview

The general process of converting to an encrypted database is

1. [Take your app(s) offline and ensure there are no possible writes to the RDS instance](#take-your-app-offline)
2. [Make an encrypted snapshot of your RDS instance](#make-an-encrypted-snapshot-of-your-rds-instance). This cannot be done in 1 step so you will need to:
    1. Take an unencrypted snapshot of the RDS instance; and then
    2. Copy the unencrypted snapshot to a new snapshot while enabling encryption
4. [Recreate the RDS instance from the encrypted snapshot](#recreate-the-rds-instance-from-the-encrypted-snapshot)
5. [Bring your app(s) back online](#bring-your-app-back-online)

## Take your app offline

Follow the [instructions for disabling an app in EKS](https://docs.publishing.service.gov.uk/kubernetes/how-to-disable-or-re-enable-an-app/#disabling-an-app).

If multiple apps can write to the RDS instance you will need to disable all of them.

Once your app is offline you need to check that there are no database connections to your RDS instance. AWS CloudWatch has a DatabaseConnections metric
which will show you how many connections are open, this should show 0 (or possibly, if you have read replicas 1 per read replica).

## Make an encrypted snapshot of your RDS instance

In the [tfc-configuration](https://github.com/alphagov/govuk-infrastructure/tree/main/terraform/deployments/tfc-configuration) terraform root you should edit
the `variables-<env>.tf` file for the environment in question and add the following parameters to your database instance:

1. `create_encrypted_snapshot = true`
1. `deletion_protection = false` (This isn't strictly required at this stage, but in the next step we will make terraform recreate the database which will need to destroy it).

For example, to create an encrypted snapshot of `account_api` in integration, edit `variables-integration.tf` with the following change

```
     databases = {
       account_api = {
         engine         = "postgres"
         ...SNIP...
         encryption_at_rest           = false
+        create_encrypted_snapshot    = true
+        deletion_protection          = false
       }
```

The terraform will handle the whole process of making an unencrypted snapshot, and then copying it to an encrypted snapshot encrypted with the `govuk/rds` KMS key.

Once you have merged your PR you will need to apply the [tfc-configuration workspace](https://app.terraform.io/app/govuk/workspaces/tfc-configuration), and after this is applied the appropriate rds-&lt;environment> workspace (either [rds-integration](https://app.terraform.io/app/govuk/workspaces/rds-integration), [rds-staging](https://app.terraform.io/app/govuk/workspaces/rds-staging), or [rds-production](https://app.terraform.io/app/govuk/workspaces/rds-production)).

The terraform plan should show a single change to the
`aws_db_instance.instance["<your instance name>"]` resource showing
deletion protection being disabled, and should show additional unencrypted, and
encrypted snapshots being created.

## Recreate the RDS instance from the encrypted snapshot

In the [tfc-configuration](https://github.com/alphagov/govuk-infrastructure/tree/main/terraform/deployments/tfc-configuration) terraform root you should edit
the `variables-<env>.tf` file for the environment in question and add the following parameters to your database instance:

* Set `snapshot_identifier = "<name of the encrytped snapshot>"`. The name of this snapshot will be `<name-of-your-instance>-postgres-post-encryption`, e.g. for account_api `account-api-postgres-post-encryption`
* Change `encryption_at_rest` from false to true

For example, to recreate `account_api` in integration after the previous step was completed, edit `variables-integration.tf` with the following change:

```
     databases = {
       account_api = {
         engine         = "postgres"
         ...SNIP...
         project                      = "GOV.UK - Web"
-        encryption_at_rest           = false
+        encryption_at_rest           = true
         create_encrypted_snapshot    = true
         deletion_protection          = false
+        snapshot_identifier          = "account-api-postgres-post-encryption"
       }
```

These two changes will force terraform to destroy and recreate the instance from the snapshot taken in the previous step.

Once you have merged your PR you will need to apply the [tfc-configuration workspace](https://app.terraform.io/app/govuk/workspaces/tfc-configuration),
and after this is applied the appropriate rds-&lt;environment> workspace (either
[rds-integration](https://app.terraform.io/app/govuk/workspaces/rds-integration),
[rds-staging](https://app.terraform.io/app/govuk/workspaces/rds-staging), or
[rds-production](https://app.terraform.io/app/govuk/workspaces/rds-production)).

The terraform plan should show the `aws_db_instance.instance["<your instance name>"]` resource being recreated,
with the detail showing that `kms_key_id`,`snapshot_identifier`, and `encyption_at_rest` forcing recreation.

## Bring your app back online

Follow the [instructions for re-enabling an app in EKS](https://docs.publishing.service.gov.uk/kubernetes/how-to-disable-or-re-enable-an-app/#re-enabling-an-app).

If multiple apps were taken offline at the start, you will need to re-enable all of them.
