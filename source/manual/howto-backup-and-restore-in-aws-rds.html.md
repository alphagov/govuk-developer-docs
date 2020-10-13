---
owner_slack: "#re-govuk"
title: Backup and restore databases in AWS RDS
section: Backups
layout: manual_layout
parent: "/manual.html"
---

Backups of RDS instances are [taken
nightly](https://github.com/alphagov/govuk-aws/tree/master/terraform/modules/aws/rds_instance).
They are stored in Amazon S3. SQL dumps are also taken nightly from `db_admin`
and `transition_db_admin`, encompassing all the databases on those instances.

### Restore an RDS instance via the AWS Console

Follow [the AWS documentation on Restoring from a DB Snapshot](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_RestoreFromSnapshot.html).

### Restore an RDS instance via the AWS CLI

Retrieve the ARNs (unique identifiers) of the snapshots into a variable.

```
SNAPSHOTS=$(aws rds describe-db-snapshots --query 'DBSnapshots[].DBSnapshotArn' | jq -r '@csv' | tr ',' ' ' | tr -d '"')
```

Loop through the snapshot ARN list and use the `list-tags-for-resource`
parameter to get the tags for the snapshot. The tags have
human-readable "Name" parameters (like blue-mysql-primary). These tell you which
stack and RDS instance the snapshot is from.

```
for SNAPSHOT in $SNAPSHOTS ; do
  echo -ne "\n-- $I -- " ;  aws rds list-tags-for-resource --resource-name $SNAPSHOT | jq -r '.TagList[] | [.Key, .Value] | @csv' | tr -d '"' | grep Name ;
done
```

Databases need to restore into the same VPC and with the same security groups as
the original instance the snapshot came from. To do this, find which database
the snapshot was generated from:

`aws rds describe-db-snapshots --db-snapshot-identifier <snapshot-arn> --query 'DBSnapshots[].DBInstanceIdentifier'`

With the output of the above command - the original database instance ID
(something like `terraform-2017000...`) - find the security groups, parameter
groups and subnet groups for that instance.

The restored database must have the same security groups and be in the same VPC
(that's the "subnet group name" parameter) as the original one, otherwise apps
won't be able to connect to it.

```
aws rds describe-db-instances --db-instance-identifier mydb-xxx \
      --query 'DBInstances[].[VpcSecurityGroups[].VpcSecurityGroupId,DBParameterGroups[].DBParameterGroupName,DBSubnetGroup.DBSubnetGroupName]'
```

You have all the parameters you need (snapshot-arn, restored-db-instance-identifier,
security-group-id, db-parameter-group-name, and db-subnet-group-name) to restore
the database and change the restored database's security groups to match the
original's.

```
aws rds restore-db-instance-from-db-snapshot \
    --db-subnet-group-name <db-subnet-group-name>
    --db-instance-identifier <restored-db-instance-identifier> \
    --db-snapshot-identifier <snapshot-arn>
```

```
aws rds modify-db-instance \
    --db-instance-identifier <restored-db-instance-id \
    --vpc-security-group-ids <security-group-id> \
    --db-parameter-group-name <db-parameter-group-name>
```

Once restored, you will need to update the DNS so that the restored database can
be accessed on the internal domain.

Get the endpoint of the restored instance:

```
aws rds describe-db-instances --db-instance-identifier <restored-db-instance-id --query 'DBInstances[].Endpoint'
```

Get the zone ID of the GOV.UK internal domain name:

```
aws route53 list-hosted-zones-by-name --dns-name <integration-internal-domain> --max-items 1
```

(It'll be in the form `"Id": "/hostedzone/ZXXXXX"` - only the `Z` section is
required.)

Amazon Route53 doesn't have a command line to update just one DNS record. It
requires a file for batch changes (even if there's only one). Create a file,
eg `/var/tmp/update_dns.json`, with the following content.

```
{
    "Comment": "Manual DB restore",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "<database-name>.<stack-name>.<govuk-internal-domain>",
                "Type": "CNAME",
                "TTL": 300,
                "ResourceRecords": [
                    {
                        "Value": "<restored-db-endpoint>",
                    }
                ]
            }
        }
    ]
}
```

Apply these changes with the following command, and then the restore is finished!

```
aws route53 change-resource-record-sets --hosted-zone-id <zone-id> --change-batch file:///var/tmp/update_dns.json
```
