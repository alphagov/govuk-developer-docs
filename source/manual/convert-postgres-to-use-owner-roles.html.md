---
owner_slack: "#govuk-platform-engineering"
title: Convert Postgres Instances to use Owner Roles
section: Databases
layout: manual_layout
parent: "/manual.html"
---

This documentation explains how to convert a set of Postgres RDS (Relational Database Service) instances to use "owner roles" in order to make permissions more manageable and maintainable.

## The process

As the majoriy of GOV.UK application databases are synced "top-down" from Production into Staging and (periodically) Integration, we need to complete this process in all environments, starting with Production.

1. Access the Database Instance (inside the VPC) in Production
2. Create the new owner role
3. Make the existing app user and `aws_db_admin` users members of the new owner role
4. Grant the new owner role permissions to the database objects
5. Reassign ownership for the database and its objects to the new owner role
6. Repeat the above process for Staging and Integration
7. Update the `db-backup` Helm Chart to use the new role with the `DB_OWNER` environment variable

# Getting started

## Create a bastion or "jump box" Pod

Before you can interact with MySQL or Postgres, you will need a way to interact with the RDS instance that sits inside the VPC.

Follow the [Bastion Documentation](/manual/create-bastion-pod.html) for detailed instructions on how to do this.

### Getting the `aws_db_admin` RDS admin user credentials

First, log in to the relevant AWS Console environment:

```sh
$ gds aws govuk-some-environment-developer -l
```

You can find the database root password in the [env-name]-rds-admin-passwords secret in SecretsManager (where [env-name] is the name of an environment), under the key with the matching database name.

If you also need to find the hostname and Database Name for the relevant RDS instance, you can view it in the relevant secret under `govuk/[app-name]/[db-engine]` - substitute `[app-name]` and `[db-engine]` as relevant.

# Accessing and validating the Database configuration

For the purpose of demonstrating the process, we will assume the Database you are rotating the credentials for is the `account-api` Database.

## Authenticating to the Postgres terminal with the `aws_db_admin` user

With a valid "fulladmin" AWS role, use `kubectl exec` against the Jumpbox you [created earlier](/manual/create-bastion-pod.html) to start a bash session:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps exec -it postgres-jumpbox -- bash
```

If everything worked, you should now have a bash prompt inside the container:

```sh
I have no name!@postgres-jumpbox:/$
```

You should now be able to use the bash prompt to start an interactive Postgres session:

```sh
$ psql --host [rds-hostname] --username aws_db_admin --password [database-name]
```

Replace `[rds-hostname]` with the relevant hostname. You will be prompted for the password you fetched earlier. If successful you will now have an authenticated interactive Postgres session.

## Identifying existing roles (users) and ownerships

Before you continue, you should check what roles and users currently exist for the Database.

Running `\l` should return a list of databases and the role (user) that owns them and should look like this:

```
                                                                    List of databases
           Name            |     Owner      | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |       Access privileges
---------------------------+----------------+----------+-----------------+-------------+-------------+--------+-----------+-------------------------------
 account-api_production    | account-api    | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 postgres                  | aws_db_admin   | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 rdsadmin                  | rdsadmin       | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | rdsadmin=CTc/rdsadmin
 template0                 | rdsadmin       | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/rdsadmin                  +
                           |                |          |                 |             |             |        |           | rdsadmin=CTc/rdsadmin
 template1                 | aws_db_admin   | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | aws_db_admin=CTc/aws_db_admin+
                           |                |          |                 |             |             |        |           | =c/aws_db_admin
```

Running `\du` should return a list of roles that looks like this:

```
                                List of roles
    Role name    |                         Attributes
-----------------+------------------------------------------------------------
 account-api     |
 aws_db_admin    | Create role, Create DB                                    +
                 | Password valid until infinity
 rds_ad          | Cannot login
 rds_extension   | No inheritance, Cannot login
 rds_iam         | Cannot login
 rds_password    | Cannot login
 rds_replication | Cannot login
 rds_reserved    | No inheritance, Cannot login
 rds_superuser   | Cannot login
 rdsadmin        | Superuser, Create role, Create DB, Replication, Bypass RLS+
                 | Password valid until infinity
```

Running `\dt` will list tables and ownerships produce something similar to:

```
                   List of tables
 Schema |         Name         | Type  |    Owner
--------+----------------------+-------+-------------
 public | ar_internal_metadata | table | account-api
 public | auth_requests        | table | account-api
 public | email_subscriptions  | table | account-api
 public | oidc_users           | table | account-api
 public | schema_migrations    | table | account-api
 public | sensitive_exceptions | table | account-api
 public | tombstones           | table | account-api
 public | users                | table | account-api
```

Running `\drg` will show you role grants and produce something similar to:

```
                              List of role grants
   Role name    |          Member of          |       Options       | Grantor  
----------------+-----------------------------+---------------------+----------
 aws_db_admin   | account-api                 | INHERIT, SET        | rdsadmin
 aws_db_admin   | rds_superuser               | INHERIT, SET        | rdsadmin
 rds_superuser  | pg_checkpoint               | ADMIN, INHERIT, SET | rdsadmin
 rds_superuser  | pg_create_subscription      | ADMIN, INHERIT, SET | rdsadmin
 rds_superuser  | pg_maintain                 | ADMIN, INHERIT, SET | rdsadmin
 rds_superuser  | pg_monitor                  | ADMIN, INHERIT, SET | rdsadmin
 rds_superuser  | pg_read_all_data            | ADMIN, INHERIT, SET | rdsadmin
 rds_superuser  | pg_signal_backend           | ADMIN, INHERIT, SET | rdsadmin
 rds_superuser  | pg_use_reserved_connections | ADMIN, INHERIT, SET | rdsadmin
 rds_superuser  | pg_write_all_data           | ADMIN, INHERIT, SET | rdsadmin
 rds_superuser  | rds_password                | ADMIN, INHERIT, SET | rdsadmin
 rds_superuser  | rds_replication             | ADMIN, INHERIT, SET | rdsadmin

```

If it looks like the active application user (in these examples, `account-api` as used by the application) directly owns the database objects and tables and does not belong to a member role that owns the Database instead such as `account-api-owner-role` (confirmed by using `\drg` as above), you will want to continue the following process to standardise the ownership of the Database and associated Tables.

If however, the Database and Tables show as owned by another role and privileges are inherited by the application user (e.g. `account-api` is already a member of `account-api-owner-role` and the database and tables are owned by that role), then you do not need to proceed any further with this guide.

# Database ownership standardisation

Follow these instructions to re-assign the Database Ownership to a single role that you can use to grant to one or more credential sets (authenticated roles) to simplify the process of managing and rotating credentials in the future.

You also only need to complete this step once if you are performing the rotation process for Production or Staging - complete it in Production _only_ and then wait for the overnight backup-and-restore to replicate the changes into Staging.

## Create the new owner role

Create a role to serve as the Database Owner (substitute `account-api` with the app name):

```sql
CREATE ROLE "account-api-owner-role" WITH NOLOGIN;
```

The `NOLOGIN` argument defines this role as a structural role and not a user role, preventing direct authentication.

## Make existing user role a member of the new owner role

<%%= warning_text('This is important! Missing this step will result in the current app user losing privileges and cause an outage.') %>

Use the `GRANT` verb to make the existing `account-api` app user a member of the new owner role:

```sql
GRANT "account-api-owner-role" TO "account-api";
```

## Grant permissions to the new role

Run the following queries to grant permissions to the new role:

```sql
GRANT CONNECT, CREATE ON DATABASE "account-api_production" TO "account-api-owner-role";
GRANT USAGE, CREATE ON SCHEMA public TO "account-api-owner-role";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "account-api-owner-role";
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "account-api-owner-role";
```

## Transfer ownership of database objects

Next, transfer object ownership of all tables, sequences, views and functions over to the new role:

```sql
REASSIGN OWNED BY "account-api" TO "account-api-owner-role";
```

Then transfer the Database Owner:

```sql
ALTER DATABASE "account-api_production" OWNER TO "account-api-owner-role";
```

Finally, update the public schema owner:

```sql
ALTER SCHEMA public OWNER TO "account-api-owner-role";
```

## Set default owners for future objects

The earlier changes will update everything that is currently in the Database, but any future migrations run the risk of there being "split ownership", so we will do something about this now. Set defaults as follows:

```sql
ALTER DEFAULT PRIVILEGES FOR ROLE "account-api"
IN SCHEMA public
GRANT ALL ON TABLES TO "account-api-owner-role";

ALTER DEFAULT PRIVILEGES FOR ROLE "account-api"
IN SCHEMA public
GRANT ALL ON SEQUENCES TO "account-api-owner-role";
```

## Verification of ownership

Run this query to confirm the Database Owner:

```sql
SELECT d.datname, pg_catalog.pg_get_userbyid(d.datdba) as owner
FROM pg_catalog.pg_database d
WHERE d.datname = 'account-api_production';
```

You should see the following result:

```
        datname         |    owner
------------------------+-----------------------
 account-api_production | account-api-owner-role
```

If this looks correct, you can now proceed to create a new user and rotate your credentials as needed.

## Repeat changes in lower environments

These changes should repeated in lower environments so that any Database backup and restore scripts do not fail due to permissions issues.

### Clean-up temporary or orphaned object permissions

Run the re-assign command again to catch any temporary or last-minute objects the old user might have created prior to the credential switchover:

```sql
REASSIGN OWNED BY "account-api" TO "account-api-owner-role";
```

Then strip away any orphaned direct privileges:

```sql
DROP OWNED BY "account-api";
```

### Update DB_OWNER variable for db-backup script.

The db-backup script used to backup and restore the Postgres databases into lower environments needs to be told which role should be the "owner" of the Database and its Objects when running the restore job.

Navigate to [alphagov/govuk-helm-charts/charts/db-backup/values.yaml](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/db-backup/values.yaml) and find the relevant database configurations for each environment, ensuring you set the DB_OWNER environment variable to the correct owner role:

```yaml
cronjobs:
  production:
    account-api-postgres:
      schedule: "37 23 * * *"
      db: account-api_production
      # TODO: add an automatic test restore to somewhere in production (because
      # unlike the other DBs, we don't copy prod account-api data to staging).
      operations:
        - op: backup
      extraEnv:
        - name: DB_OWNER # Add and set this key and value if not present
          value: account-api-owner-role
```

Failure to do this could result in the restore job failing and the relevant application being broken in the lower environments.
