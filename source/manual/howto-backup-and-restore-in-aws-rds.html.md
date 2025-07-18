---
owner_slack: "#govuk-platform-engineering"
title: Backup and restore databases in AWS RDS
section: Backups
layout: manual_layout
parent: "/manual.html"
---

This playbook describes how to restore a database instance using Amazon's [RDS Backups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html) feature.

We use RDS Backups to give us fully nightly backups and point-in-time recovery (PITR) (also known as continuous data protection or CDP).

> We only run RDS Backup in the production environment. To run a test restore in staging or integration, you must first take a manual snapshot from the AWS console or via the AWS CLI.
>
> Make sure the snapshot's name contains the name of the app (e.g. `local-links-manager`), and remember to delete it afterwards.

## Restore an RDS instance via the AWS CLI

This documentation will illustrate how to restore a database (DB) instance from a DB Snapshot with AWS CLI.

Before you get started you need to know:

* The environment in which you are restoring the database - replace <environment> throughout the scripts
* The name of the database which needs to be restored - if you are restoring multiple databases, you will need to carry out these steps again for it

For more information, read the [AWS documentation on Restoring from a DB Snapshot](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_RestoreFromSnapshot.html).

### 1. Retrieve a list of all snapshot ARNs for your application

In this example we are using `local-links-manager`:

```sh
environment=production
gds-cli aws govuk-${environment?}-fulladmin \
  aws rds describe-db-snapshots \
    --query 'DBSnapshots[].DBSnapshotArn' \
  | grep local-links-manager
```

Choose the ARN of the most recent backup, and store it in an environment variable:

```sh
snapshot_arn="<e.g. arn:aws:rds:eu-west-1:210287912431:snapshot:rds:local-links-manager-postgres-2022-07-05-01-09>"
```

If no snapshots are available on Integration for the drill you can manually take a snapshot. You can do this in the [RDS Snapshots](https://eu-west-1.console.aws.amazon.com/rds/home?region=eu-west-1#take-snapshots:) section of the AWS Console. Simply pick the DB instance you want in the `DB instance` select and give it a `Snapshot name`.

Alternatively, you can take a snapshot via the AWS CLI:

```sh
gds-cli aws govuk-${environment?}-fulladmin \
  aws rds create-db-snapshot \
    --db-instance-identifier ${db-instance-name} \
    --db-snapshot-identifier ${your-snapshot-name}
```

You can check the snapshot progress by running:

```sh
gds-cli aws govuk-${environment?}-fulladmin \
  aws rds describe-db-snapshots \
    --db-snapshot-identifier ${your-snapshot-name} \
    --query 'DBSnapshots[DBSnapshotArn,Status,PercentProgress]'
```

Once the snapshot has been created, copy the ARN.

### 2. Find which database the snapshot was generated by

For example:

```sh
gds-cli aws govuk-${environment?}-fulladmin \
  aws rds describe-db-snapshots \
    --db-snapshot-identifier ${snapshot_arn} \
    --query 'DBSnapshots[].DBInstanceIdentifier'
```

Store the `DBInstanceIdentifier` as a variable:

```sh
db_instance_identifier="<e.g. local-links-manager-postgres>"
```

### 3. Ensure the restored database has the same security groups

The restored database must have the same security groups and be in the same VPC (that's the "subnet group name" parameter) as the original one, otherwise, apps won't be able to connect to it. Therefore the database needs to be restored in the same VPC and with the same security groups as the original instance the snapshot came from.

After running the command below, you now have all the parameters you need (snapshot-arn, db-instance-identifier, security-group-id, db-parameter-group-name, and db-subnet-group-name) to restore the database and change the restored database's security groups to match the original's.

```sh
gds-cli aws govuk-${environment?}-fulladmin \
  aws rds describe-db-instances \
    --db-instance-identifier ${db_instance_identifier?} \
    --query 'DBInstances[].[VpcSecurityGroups[].VpcSecurityGroupId,DBParameterGroups[].DBParameterGroupName,DBSubnetGroup.DBSubnetGroupName]'
```

Example of the output:

* vpc-security-group-id = sg-XXXXXXXX
* db-parameter-group-name = local-links-manager-postgres-XXXXXXXXXX
* db-subnet-group-name = blue-govuk-rds-subnet

Store the output as environment variables:

```sh
vpc_security_group_id="<replace_with_previous_output>"
db_parameter_group_name="<replace_with_previous_output>"
db_subnet_group_name="<replace_with_previous_output>"
```

### 4. Restore the database instance from a snapshot

Using the stored variables from the previous steps:

```sh
gds-cli aws govuk-${environment?}-fulladmin \
  aws rds restore-db-instance-from-db-snapshot \
    --db-subnet-group-name ${db_subnet_group_name?} \
    --db-instance-identifier restored-${db_instance_identifier?} \
    --db-snapshot-identifier ${snapshot_arn?}
```

To see the newly created database instance, log into AWS Console > RDS > Databases > filter for your database name. You should see the original and newly created one.

### 5. Test the database has been fully restored

Before moving on to the next step we need to ensure that the database has been fully restored and is ready to be used:

```sh
gds-cli aws govuk-${environment?}-fulladmin \
  aws rds wait db-instance-available \
    --db-instance-identifier restored-${db_instance_identifier?}
```

This command will wait until the database is ready, and then exit without any output.

### 6. Get the new database's hostname

Once the database is ready, fetch its hostname:

```sh
gds-cli aws govuk-${environment?}-fulladmin \
  aws rds describe-db-instances \
    --db-instance-identifier "restored-${db_instance_identifier?}" \
    --query 'DBInstances[].Endpoint.Address'
```

Make a note of this.

### 7. Connect to the restored backup database

This requires updating the `govuk/local-links-manager/postgres` secret in AWS Secrets Manager.

1. Log in to AWS in the correct environment: `gds aws govuk-${environment?}-fulladmin -l`
1. In AWS Secrets Manager, search for and click on `govuk/local-links-manager/postgres`.
1. Under the "Overview" tab, in the "Secret Value" section, select "Retrieve Secret Value".
1. Make a note of the existing value, in case you need to revert the changes (for example, if performing a drill).
1. Click "Edit", and replace the value of the "host" and "dbInstanceIdentifier" fields with the URL and identifier of the new database instance. Click "Save".

    > Some of our apps currently refer to their database directly (e.g. `app-name.hex-string.eu-west-1.rds.amazonaws.com`), some of them refer to their database indirectly via a `CNAME` record (e.g. `app-name.blue.staging.govuk-internal.digital`). In either case, you can replace this with the URL of the new database instance.

1. Log into Argo CD in the correct environment ([integration](https://argo.eks.integration.govuk.digital/),
    [staging](https://argo.eks.staging.govuk.digital/), [production](https://argo.eks.production.govuk.digital/)).
1. Navigate to the `external-secrets` app, locate the `local-links-manager-postgres` external secret, select the "..." menu, and select "Refresh".
1. After refreshing this secret, the app's pods should automatically be restarted pointing at the correct database instance. To confirm that this happened, navigate to the `local-links-manager` app, locate the `local-links-manager` deployment, and check the uptime of the pods.

    > If the pods were not automatically restarted, select the "..." menu next to the deployment, and select "Restart".

### 8. Check that the app is now using the restored database

Open a Rails console on the target app:

```sh
kubectl exec -n apps -it deploy/local-links-manager -- bundle exec rails c
```

Check which database ActiveRecord is connected to, and ensure it matches the hostname of the restored database:

```ruby
ActiveRecord::Base.connection_db_config.host
```

## Delete an obsolete database

> PLEASE BE CAREFUL WHEN EXECUTING THIS COMMAND AS IT CANNOT BE UNDONE

For reference, here is the [AWS documentation for deleting a database instance](https://docs.aws.amazon.com/cli/latest/reference/rds/delete-db-instance.html#delete-db-instance).

It is likely that the restored database is missing data since the snapshot was taken and you
will want to have a copy of the original database for comparison before deleting it.

If you are drilling this, then make sure you revert to the previous db credentials prior to deleting the database.

The command below will create a DB snapshot before the DB instance is deleted. If you don't want this, replace the `--final-db-snapshot-identifier` parameter with `--skip-final-snapshot`.

```sh
environment=production
db_instance_identifier=<e.g. local-links-manager-postgres>
snapshot_name=<e.g. local-links-manager-postgres-final-snapshot>
gds-cli aws govuk-${environment?}-fulladmin \
  aws rds delete-db-instance \
    --db-instance-identifier ${db_instance_identifier?} \
    --final-db-snapshot-identifier ${snapshot_name?}
```

You can check the snapshot is available by navigating to RDS > Snapshots in the AWS console.
