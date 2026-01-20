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

# Getting started

## Create a bastion or "jump box" Pod

Before you can interact with MySQL or Postgres, you will need a way to interact with the RDS instance that sits inside the VPC.

### Pod definition for MySQL

Save this Pod Definition to a local file of your choosing (such as `mysql-jumpbox.yaml`):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql-jumpbox
spec:
  containers:
  - name: mysql-jumpbox
    image: mysql:latest
    env:
      - name: DATABASE_URL
        valueFrom:
          secretKeyRef:
            name: signon-mysql
            key: DATABASE_URL
    command:
      - bash
      - -c
      - "sleep 10d"
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop:
          - ALL
  securityContext:
    seccompProfile:
      type: RuntimeDefault
    fsGroup: 1000
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 1000
```

Once you've done this, you will want to apply this pod definition to the required cluster -
you will need either `platformengineer` or `fulladmin` roles to do this:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps apply -f mysql-jumpbox.yaml
```

### Pod definition for Postgres

Save this Pod Definition to a local file of your choosing (such as `postgres-jumpbox.yaml`):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: postgres-jumpbox
spec:
  containers:
  - name: postgres-jumpbox
    image: postgres:latest
    env:
      - name: DATABASE_URL
        valueFrom:
          secretKeyRef:
            name: account-api-postgres
            key: DATABASE_URL
    command:
      - bash
      - -c
      - "sleep 10d"
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop:
          - ALL
  securityContext:
    seccompProfile:
      type: RuntimeDefault
    fsGroup: 1000
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 1000
```

Once you've done this, you will want to apply this pod definition to the required cluster -
you will need either `platformengineer` or `fulladmin` roles to do this:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps apply -f postgres-jumpbox.yaml
```

### Getting the `aws_db_admin` root user credentials

First, log in to the relevant AWS Console environment:

```sh
$ gds aws govuk-some-environment-developer -l
```

To manage Database Authentication, you will need to use the Root User, which you can find in AWS SecretsManager
 under the key `[env-name]-rds-admin-passwords` - replace `[env-name]` with the relevant environment name.

Once you have found the secret, you will find key/value pairs for each RDS instance and the corresponding password.

If you also need to find the hostname and Database Name for the relavant RDS instance, you can find this by locating the RDS instance in the AWS Console. Orgit p, you can view it in the relevant secret under `govuk/[app-name]/[db-engine]` - substitute `[app-name]` and `[db-engine]` as relevant.

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
CREATE USER 'signon_user2'@'%' IDENTIFIED BY 'a-secret-password';
```

Then grant the necessary permissions to the new user:

```sql
GRANT ALL PRIVILEGES ON signon_production.* TO 'signon_user2'@'%';
```

## Rotate credentials in AWS SecretsManager

Next, you should access the AWS Console for the relevant environment with the `fulladmin` role and locate the relevant Secret in AWS SecretsManager. Locate the secret named `govuk/signon/mysql` and edit the `username` and `password` keys to match the values of the new Postgres user you created earlier.

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

You should see a connection string that looks simular to `mysql2://signon-user2:a-secret-password@hostname/signon_production` - check that the `username:password` bit matches what you expect it to.

### Check application variables

Check one of the application pods that the DATABASE_URL environment variable has the correct secret (proving the pods have restarted with the new credentials):

```bash
kubectl exec -it deployment/signon --container=app -- env | grep "DATABASE_URL"
```

You should see the same connection string as earlier.

## Check for other MySQL objects

MySQL has some specific objects that are "defined" (by default) by the database user that created them - specifically: Events, Functions, Procedures and Views. If your application uses any of these features, you will need to manually recreate these for the new user.

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

If any of the above commands return any results, you can use commands such as `SHOW CREATE` to save the definitions of your Procedures and Views and re-create them for the new user. If there are no results or you have already migrated the required objects, you may now delete the old user.

## Verify rotation and delete old user

Check that the new user is now being used to make connections:

```sql
SELECT USER, count(*)
FROM information_schema.PROCESSLIST
GROUP BY USER;
```

You should see a table like this:

```
+-----------------+----------+
| USER            | count(*) |
+-----------------+----------+
| rdsadmin        |        2 |
| signon_user2    |        2 |
| event_scheduler |        1 |
| aws_db_admin    |        1 |
+-----------------+----------
```

If you have any dangling connections for your old user, you can kill them (see in Troubleshooting).

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

Running `\dt` will produce something like:

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

If it becomes clear that the active application user (in these examples, `account-api`) owns the database objects and tables, you will want to go through the following process to standardise the ownership of the Database and associated Tables.

## Database ownership standardisation (one time only)

Follow these instructions to re-assign the Database Ownership to use a single role that you can use to grant to one or more credential sets (authenticated roles) to simplify the process of managing and rotating credentials in the future.

### Create the new owner role

Create a role to serve as the Database Owner (substitute `account-api` with the app name):

```sql
CREATE ROLE "account-api-owner-role" WITH NOLOGIN;
```

The `NOLOGIN` argument defines this role as a structural role and not a user role, preventing direct authentication.

### Make existing user role a member of the new owner role

This is important! Missing this step will result in the current app user losing privileges and cause an outage.  
Use the `GRANT` verb to make the existing `account-api` app user a member of the new owner role:

```sql
GRANT "account-api-owner-role" TO "account-api";
```

### Transfer ownership of database objects

First, transfer object ownership of all tables, sequences, views and functions over to the new role:

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

### Set default owners for future objects

The earlier changes will update everything that is currently in the Database, but any future migrations run the risk of there being "split ownership", so we will do something about this now. Set defaults as follows:

```sql
ALTER DEFAULT PRIVILEGES FOR ROLE "account-api"
IN SCHEMA public
GRANT ALL ON TABLES TO "account-api-owner-role";

ALTER DEFAULT PRIVILEGES FOR ROLE "account-api"
IN SCHEMA public
GRANT ALL ON SEQUENCES TO "account-api-owner-role";
```

### Verification of ownership

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

If this looks correct, you can now proceed to Create a New User and rotate your credentials as needed.

## Create new user for Postgres database

Create a new user with a password of your choosing:

```sql
CREATE USER "account-api-user2" WITH password 'a-secret-password';
```

Then you will need to grant the new user access to the role that owns the relevant tables:

```sql
GRANT "account-api-owner-role" TO "account-api-user2";
```

### Verify role inheritance

Run this command to verify the new user has the correct inheritance:

```sql
SELECT r.rolname as user_name, m.rolname as member_of
FROM pg_roles r
JOIN pg_auth_members am ON r.oid = am.member
JOIN pg_roles m ON am.roleid = m.oid
WHERE r.rolname = 'account-api-user2';
```

## Rotate credentials in AWS SecretsManager

Next, you should access the AWS Console for the relevant environment with the `fulladmin` role and locate the relevant Secret in AWS SecretsManager. Locate the secret named `govuk/account-api/postgres` and edit the `username` and `password` keys to match the values of the new Postgres user you created earlier.

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

You should see a connection string that looks simular to `postgresql://account-api-user2:a-secret-password@hostname/account-api_production` - check that the `username:password` bit matches what you expect it to.

### Check application variables

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

### Final check for temporary or recent objects

Run the re-assign command again to catch any temporary or last-minute objects the old user might have created prior to the credential switchover:

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
