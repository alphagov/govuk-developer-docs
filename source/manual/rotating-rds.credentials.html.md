---
owner_slack: "#govuk-platform-engineering"
title: Rotate Relational Database Service (RDS) Credentials for GOV.UK Applications
section: Databases
layout: manual_layout
parent: "/manual.html"
---

This documentation explains how to rotate (or create) Credentials for an RDS Database (backed by MySQL or Postgres).

## The process

The process to rotate credentials on an RDS-hosted Database Instance is as follows:

* Access the Database Instance (inside the VPC)
* Create a new user
* Update the credentials used by the application
* Delete the old user

## The process (for Staging and Production)

The process for Staging and Production are a bit different, as Databases are synced from Production over the top of Staging each night. In which case, the process looks like this:

* Access the Database Instance (inside the VPC) in Production
* If Postgres, make sure Database and Object owners are set to an "owner role" (still in Production)
* Create a new user (in Production)
* Update the credentials used by the application in Production
* Wait overnight for the changes to be replicated into Staging
* Delete the old user in Production
* Update the credentials used by the application in Staging

# Getting started

## Create a bastion or "jump box" Pod

Before you can interact with MySQL or Postgres, you will need a way to interact with the RDS instance that sits inside the VPC.

Follow the [Bastion Documentation](/manual/create-bastion-pod.html) for detailed instructions on how to do this.

### Getting the `aws_db_admin` RDS admin user credentials

First, log in to the relevant AWS Console environment:

```sh
$ gds aws govuk-some-environment-developer -l
```

To manage Database Authentication, you will need to use the RDS admin user, which you can find in AWS SecretsManager
 under the key `[env-name]-rds-admin-passwords` - replace `[env-name]` with the relevant environment name.

Once you have found the secret, you will find key/value pairs for each RDS instance and the corresponding password.

If you also need to find the hostname and Database Name for the relevant RDS instance, you can find this by locating the RDS instance in the AWS Console. Or, you can view it in the relevant secret under `govuk/[app-name]/[db-engine]` - substitute `[app-name]` and `[db-engine]` as relevant.

# Managing credentials for MySQL instances

Next, you will need to use the Jumpbox to start an interactive session with the Database Engine.

For the purpose of demonstrating the process, we will assume the Database you are rotating the credentials for is the `signon` Database.

## Authenticating to the MySQL terminal with the `aws_db_admin` user

With a valid "fulladmin" AWS role, use `kubectl exec` against the Jumpbox you created earlier to start a bash session:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps exec -it mysql-jumpbox -- bash
```

If everything worked, you should now have a bash prompt inside the container.

```sh
$ mysql --host [rds-hostname] -p -u aws_db_admin
```

Replace `[rds-hostname]` with the relevant hostname. You will be prompted for the password you fetched earlier. If successful you will now have an authenticated interactive MySQL session.

## Identifying existing users

First check to see which users currently exist on the MySQL server:

```sql
SELECT
    User,
    Host,
    plugin as Auth_Method,
    password_expired as Password_Expired,
    account_locked as Account_Locked,
    Super_priv as Is_Superuser,
    Grant_priv as Can_Grant_Access
FROM mysql.user
ORDER BY User;
```

This will give you a table that should look like this:

```
+--------------------+-----------+-----------------------+------------------+----------------+--------------+------------------+
| User               | Host      | Auth_Method           | Password_Expired | Account_Locked | Is_Superuser | Can_Grant_Access |
+--------------------+-----------+-----------------------+------------------+----------------+--------------+------------------+
| aws_db_admin       | %         | mysql_native_password | N                | N              | N            | Y                |
| mysql.infoschema   | localhost | caching_sha2_password | N                | Y              | N            | N                |
| mysql.sys          | localhost | caching_sha2_password | N                | Y              | N            | N                |
| rds_superuser_role | %         | mysql_native_password | Y                | Y              | N            | Y                |
| rdsadmin           | localhost | auth_socket           | N                | N              | Y            | Y                |
| signon             | %         | mysql_native_password | N                | N              | N            | N                |
+--------------------+-----------+-----------------------+------------------+----------------+--------------+------------------+
```

In this example, we can see the existing `signon` user.

## Get existing permissions

Next we will want to get the permissions for the `signon` user:

```sql
SHOW GRANTS for 'signon';
```

This will return a table that looks like:

```
+---------------------------------------------------------------+
| Grants for signon@%                                           |
+---------------------------------------------------------------+
| GRANT USAGE ON *.* TO `signon`@`%`                            |
| GRANT ALL PRIVILEGES ON `signon_production`.* TO `signon`@`%` |
+---------------------------------------------------------------+
```

Take note of these permissions - you will want to make sure your new user has the same set of permissions.

## Create new user

Create the new user in MySQL by using:

```sql
-- Create a new user, maybe date the user to make it clear when it was rotated.
CREATE USER 'signon_user_20260121'@'%' IDENTIFIED BY 'a-secret-password';
```

Then grant the necessary permissions to the new user:

```sql
GRANT ALL PRIVILEGES ON signon_production.* TO 'signon_user_20260121'@'%';
```

## Check for other MySQL objects

MySQL has some specific objects that are "defined" (by default) by the database user that created them - specifically: Events, Functions, Procedures and Views. If your application uses any of these features, you will need to manually re-create these for the new user.

Run these lines to identify any Stored Procedures or Triggers you may need to migrate manually:

```sql
SHOW FUNCTION STATUS WHERE db='signon_production';
SHOW PROCEDURE STATUS WHERE db='signon_production';
SHOW TRIGGERS FROM signon_production;
```

Run this to find any Views you may need to re-create:

```sql
SHOW FULL TABLES FROM signon_production WHERE table_type = 'VIEW';
```

If any of these commands return any results, you can use commands such as `SHOW CREATE` to save the definitions of your Procedures and Views and re-create them for the new user. If there are no results or you have already migrated the required objects, you can continue.

## Rotate credentials in AWS SecretsManager

Next, you should access the AWS Console for the relevant environment with the `fulladmin` role and locate the relevant Secret in AWS SecretsManager.

Authenticate with the `fulladmin` or `platformengineer` role:

```bash
gds aws govuk-[environmentname]-fulladmin -l
```

Also make sure your shell has a current `fulladmin` or `platformengineer` session - you will need this momentarily:

```bash
gds aws govuk-[environmentname]-fulladmin --shell
```

Locate the secret named `govuk/signon/mysql` and edit the `username` and `password` keys to match the values of the new MySQL user you created earlier.

### Force sync of Kubernetes secrets

Once you have updated the stored secrets in AWS SecretsManager, you will want to force a sync of the ExternalSecret objects held by Kubernetes:

```bash
kubectl annotate -n apps externalsecrets.external-secrets.io \
  signon-mysql force-sync=$(date +%s) --overwrite
```

Then run this command to verify that the Secret in Kubernetes has updated:

```bash
kubectl get secret signon-mysql -o json | jq '.data.DATABASE_URL | @base64d'
```

You should see a connection string that looks similar to `mysql2://signon-user2:a-secret-password@hostname/signon_production` - check that the `username:password` bit matches what you expect it to.

### Check application variables

Wait a few minutes before doing this to allow the cluster to complete a rollout.

Check one of the application pods that the DATABASE_URL environment variable has the correct secret (proving the pods have restarted with the new credentials):

```bash
kubectl exec -it deployment/signon --container=app -- env | grep "DATABASE_URL"
```

You should see the same connection string as earlier.

## Verify rotation

Check that the new user is now being used to make connections:

```sql
SELECT USER, count(*)
FROM information_schema.PROCESSLIST
GROUP BY USER;
```

You should see a table similar to this:

```
+-------------------------+----------+
| USER                    | count(*) |
+-------------------------+----------+
| rdsadmin                |        2 |
| signon_user_20260121    |        2 |
| event_scheduler         |        1 |
| aws_db_admin            |        1 |
+-------------------------+----------+
```

If you have any dangling connections for your old user, you can kill them (see in Troubleshooting).

### Repeat process in lower environments (if necessary)

If you are following this process to rotate credentials in Production and Staging, you should repeat the process in other environments. Unlike our Postgres databases, MySQL's internal authentication or permission tables are not synced between environments. This means you will need to follow this process for each environment.

### Deleting the old user

Finally, you can delete the old user with:

```sql
DROP USER 'signon';
```

# Managing credentials for Postgres instances

For the purpose of demonstrating the process, we will assume the Database you are rotating the credentials for is the `account-api` Database.

## Authenticating to the Postgres terminal with the `aws_db_admin` user

With a valid "fulladmin" AWS role, use `kubectl exec` against the Jumpbox you created earlier to start a bash session:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps exec -it postgres-jumpbox -- bash
```

If everything worked, you should now have a bash prompt inside the container:

```sh
I have no name!@postgres-jumpbox:/$
```

You should now be able to use the Bash Prompt to start an interactive Postgres session:

```sh
$ psql --host [rds-hostname] --username aws_db_admin --password [database-name]
```

Replace `[rds-hostname]` with the relevant hostname. You will be prompted for the password you fetched earlier. If successful you will now have an authenticated interactive Postgres session.

## Identifying existing roles (users) and ownerships

Before you continue, you may want to check what roles and users currently exist for the Database.

Running `\du` should return a table that looks like this:

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

Running `\dt` will produce something similar to:

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

Unlike MySQL Databases, Postgres uses a different permissions model and has a concept of object owners that need to be managed correctly.

If the active application user (in these examples, `account-api`) owns the database objects and tables, you will need standardise the ownership of the Database and associated Tables.

Follow the [Convert Postgres to use Owner Roles](/manual/convert-postgres-to-use-owner-roles.html) documentation before continuing.

## Create new user for Postgres database

Skip this stage if you are planning to rotate credentials in Staging only - any changes you make will be overwritten (or undone) by the overnight backup-and-restore job.

Create a new user with a password of your choosing:

```sql
-- Create a new user, maybe date the user to make it clear when it was rotated.
CREATE USER "account-api-user-20260121" WITH password 'a-secret-password';
```

Then you will need to grant the new user access to the role that owns the relevant tables:

```sql
GRANT "account-api-owner-role" TO "account-api-user-20260121";
```

### Verify role inheritance

Run this command to verify the new user has the correct inheritance:

```sql
SELECT r.rolname as user_name, m.rolname as member_of
FROM pg_roles r
JOIN pg_auth_members am ON r.oid = am.member
JOIN pg_roles m ON am.roleid = m.oid
WHERE r.rolname = 'account-api-user-20260121';
```

## Rotate credentials in AWS SecretsManager

Next, you should access the AWS Console for the relevant environment with the `fulladmin` or `platformengineer` role:

```bash
gds aws govuk-[environmentname]-fulladmin -l
```

Also make sure your shell has a current `fulladmin` or `platformengineer` session:

```bash
gds aws govuk-[environmentname]-fulladmin --shell
```

Then locate the relevant Secret in AWS SecretsManager. Locate the secret named `govuk/account-api/postgres` and edit the `username` and `password` keys to match the values of the new Postgres user you created earlier.

### Force sync of Kubernetes secrets

Once you have updated the stored secrets in AWS SecretsManager, you will want to force a sync of the ExternalSecret objects held by Kubernetes:

```bash
kubectl annotate -n apps externalsecrets.external-secrets.io \
  account-api-postgres force-sync=$(date +%s) --overwrite
```

Then run this command to verify that the Secret in Kubernetes has updated:

```bash
kubectl get secret account-api-postgres -o json | jq '.data.DATABASE_URL | @base64d'
```

You should see a connection string that looks similar to `postgresql://account-api-user-20260121:a-secret-password@hostname/account-api_production` - check that the `username:password` bit matches what you expect it to.

### Check application variables

Wait a few minutes before doing this to allow the cluster to complete a rollout.

Check one of the application pods that the DATABASE_URL environment variable has the correct secret (proving the pods have restarted with the new credentials):

```bash
kubectl exec -it deployment/account-api --container=app -- env | grep "DATABASE_URL"
```

You should see the same connection string as earlier.

## Deleting old credentials

If you have completed the earlier steps correctly and the application is working with the new credentials, you can now proceed to delete the old credentials.

### Check lingering connections

Run this command to see if there are any remaining connections from the old user:

```sql
SELECT count(*) as active_connections, application_name, usename
FROM pg_stat_activity
GROUP BY application_name, usename;
```

If you can only see active connections from your new user and not the old one, you are free to proceed.

### Wait for Production-to-Staging sync overnight

If you are following this process to rotate credentials in Production and Staging, you should now wait overnight for the changes to be replicated in Staging.

If you are not following this guide for Production or Staging, you can skip the wait and continue to the next step.

### Final check for temporary or recent objects

Run the re-assign command to catch any temporary or last-minute objects the old user might have created prior to the credential switchover:

```sql
REASSIGN OWNED BY "account-api" TO "account-api-owner-role";
```

Then strip away any orphaned direct privileges:

```sql
DROP OWNED BY "account-api";
```

### Delete the old user

Finally, this deletes the old user:

```sql
DROP USER "account-api";
```

## Troubleshooting

### Force-kill connections for a user (MySQL)

If you have connections that aren't going away, you can forcibly close them by running:

```sql
SELECT CONCAT('CALL mysql.rds_kill(', ID, ');')
FROM information_schema.PROCESSLIST
WHERE USER = 'signon'; --Replace with the user to disconnect
```

### Force-kill connections for a user (Postgres)

If you have connections that do not appear to be going away, you can force-kill any connections from a user by running the following command:

```sql
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE usename = 'account-api'; --The username you want to drop connections for
```

## Future improvements

There are potential improvements that could be made to our Database configurations, including:

* IAM and/or OIDC authentication (eliminating the need for credential rotation and reducing the possibility of credential leakage)
