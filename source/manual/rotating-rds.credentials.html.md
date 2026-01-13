---
owner_slack: "#govuk-platform-engineering"
title: Rotating RDS Credentials for GOV.UK Applications
section: Databases
layout: manual_layout
parent: "/manual.html"
---

Thid documentation explains how to rotate (or create) Credentials for an RDS Database (backed by MySQL or Postgres).

## Brief: The Process

The process to rotate credentials on an RDS-hosted Database Instance is as follows:

* Access the Database Instance (inside the VPC)
* Create a new user
* Update the credentials used by the application
* Delete the old user

# Getting Started

## Create a Bastion or "Jumpbox" Pod

Before you can interact with MySQL or Postgres, you will need a way to interact with the RDS instance which sits inside the VPC.

### Pod Definition for MySQL

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

Once you've done this, you will want to apply this pod definition to the environment/cluster required -
you will need either `platformengineer` or `fulladmin` roles to do this:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps apply -f mysql-jumpbox.yaml
```

### Pod Definition for Postgres

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

Once you've done this, you will want to apply this pod definition to the environment/cluster required -
you will need either `platformengineer` or `fulladmin` roles to do this:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps apply -f postgres-jumpbox.yaml
```

### Getting the `aws_db_admin` Root User Credentials

First, log in to the relevant AWS Console environment:

```sh
$ gds aws govuk-some-environment-developer -l
```

To manage Database Authentication, you will need to use the Root User which can be found in AWS Secrets Manager
 under the key `[env-name]-rds-admin-passwords` - replace `[env-name]` with the relevant environment name.

Once you have found the above secret, you will find key/value pairs for each RDS instance and the corresponding password.

If you also need to find the hostname and Database Name for the relavant RDS instance, you can either find this by locating the RDS instance in the AWS Console,
 or you can view it in the relevant secret under `govuk/[app-name]/[db-engine]` - substitute `[app-name]` and `[db-engine]` as relevant.

## Managing Credentials for MySQL Instances

Next, you will need to use the Jumpbox to start an interactive session with the Database Engine.

### Authenticating to the MySQL Terminal with the `aws_db_admin` User

With a valid "fulladmin" AWS role, use `kubectl exec` against the Jumpbox you created earlier to start a bash session:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps exec -it mysql-jumpbox -- bash
```

If everything worked, you should now have a bash prompt inside the container.

```sh
$ mysql --host [rds-hostname] -p -u aws_db_admin
```

Replace `[rds-hostname]` with the relevant hostname. You will be promted for the password you fetched earlier. If successful you will now have an authenticated interactive MySQL session.

# Managing Credentials for Postgres Instances

For the purpose of demonstrating the process, we will assume the Database you are rotating the credentials for is the `account-api` Database.

##  Authenticating to the Postgres Terminal with the `aws_db_admin` User

With a valid "fulladmin" AWS role, use `kubectl exec` against the Jumpbox you created earlier to start a bash session:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps exec -it postgres-jumpbox -- bash
```

If everything worked, you should now have a bash prompt inside the container:

```sh
I have no name!@postgres-jumpbox:/$ 
```

You should now be able to use the Bash Prompt to start an iteractive Postgres session:

```sh
$ psql --host [rds-hostname] --username aws_db_admin --password --database [database-name]
```

Replace `[rds-hostname]` with the relevant hostname. You will be promted for the password you fetched earlier. If successful you will now have an authenticated interactive Postgres session.

## Identifying Existing Roles (Users) and Ownerships

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

If it is apparant that the Database resources are owned by the active application user (in these examples, `account-api`), you will want to go through the process below to standardise the ownership of the Database and associated Tables.

## Database Ownership Standardisation (One Time Only)

This section will describe the process to re-assigne the Database Ownership to use a single role that can be granted to one or more sets of credential sets (authenticated roles) to simplify the process of managing and rotating credentials in the future.

### Create the New Owner Role

Create a role to serve as the Database Owner (substitute `account-api` with the app name):

```sql
CREATE ROLE "account-api-owner-role" WITH NOLOGIN;
```

The `NOLOGIN` argument defines this role as a structural role and not a user role, preventing direct authentication.

### Make Existing User Role a Member of New Owner Role

This is important! Missing this step will result in the current app user losing privileges and cause an outage.  
Use the `GRANT` verb to make the existing `account-api` app user a member of the new owner role:

```sql
GRANT "account-api-owner-role" TO "account-api";
```

### Transfer Ownership of Database Objects

First, transfer object ownership of all tables, sequences, views and functions over to the new role:

```sql
REASSIGN OWNED BY "account-api" TO "account-api-owner-role";
```

...then transfer the Database Owner:

```sql
ALTER DATABASE "account-api_production" OWNER TO "account-api-owner-role";
```

...and finally, update the public schema owner:
```sql
ALTER SCHEMA public OWNER TO "account-api-owner-role";
```

### Set Default Owners for Future Objects

The previous changes will update everything that is currently in the Database, but any future migrations run the risk of there being "split ownership", so we will do something about this now. Set defaults as below:

```sql
ALTER DEFAULT PRIVILEGES FOR ROLE "account-api" 
IN SCHEMA public 
GRANT ALL ON TABLES TO "account-api-owner-role";

ALTER DEFAULT PRIVILEGES FOR ROLE "account-api" 
IN SCHEMA public 
GRANT ALL ON SEQUENCES TO "account-api-owner-role";
```

### Verification of Ownership

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

If this looks correct, you can now proceed to Create a New User and rotate your credentials as desired.

## Create New User for Postgres DB

Create a new user with a password of your choosing:

```sql
CREATE USER someusername2 WITH password 'a secret password';
```

Then you will need to grant the new user access to the role that owns the relevant tables:

```sql
GRANT somerolename TO someusername2;
```