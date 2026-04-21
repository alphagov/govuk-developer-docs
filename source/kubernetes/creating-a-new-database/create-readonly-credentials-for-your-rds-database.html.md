---
title: Create readonly credentials for your RDS database
layout: multipage_layout
---

# Creating readonly credentials for your RDS database

This guide gives you guidance on how to provision a readonly user into your newly created RDS database

The overall process is:

1. [Ensure you meet the prerequisites](#prerequisites)
2. [Get the secrets you will need](#get-the-secrets-you-will-need)
3. [Connect to the RDS instance as the admin user](#connect-to-the-rds-instance-as-the-admin-user)
4. [Create the readonly user and grant privileges](#create-the-readonly-user-and-grant-privileges)
5. [Add your database to the list of external secrets to be provisioned](#add-your-database-to-the-list-of-external-secrets-to-be-provisioned)

## Conventions

Throughout this guide the following naming conventions apply:

<!-- Please excuse the hack here to force the column header to be wider using a styled div -->
<div style="width: 17em">Placeholder</div>  | Description
--------------------------------------------|------------
`<ENVIRONMENT>`                             | The name of the environment you are provisioning (e.g. `integration`, `staging`, or `production`)
`<DB_NAME>`                                 | The ***KEY*** name for your database in the terraform databases variable in the rds.tfvars (e.g. for account-api in integration look in the [integration.tfvars](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/variables/integration/rds.tfvars) file and you'll see `account_api = {`, so the name here is `account_api` (it is usually the RDS instance name written in [snake case](https://en.wikipedia.org/wiki/Snake_case)
`<DB_NAME_KEBAB_CASE>`                      | The `<DB_NAME>` after it has been converted into [kebab case](https://en.wikipedia.org/wiki/Letter_case#Kebab_case) (e.g. `account_api` will become `account-api`)
`<DB_ENGINE>`                               | The lower case name of the database engine as understood by terraform (e.g. `postgres`, or `mysql`)
`<DB_ADMIN_PASSWORD>`                       | The RDS admin password retrieved as part of step [Get the secrets you will need](#get-the-secrets-you-will-need)
`<READONLY_HOSTNAME>`                       | The hostname key retrieved as part of step [Get the secrets you will need](#get-the-secrets-you-will-need). This is named `<DB_ENGINE>_READONLY_HOSTNAME`
`<READONLY_PORT>`                           | The port key retrieved as part of step [Get the secrets you will need](#get-the-secrets-you-will-need). This is named `<DB_ENGINE>_READONLY_PORT`
`<READONLY_USERNAME>`                       | The username key retrieved as part of step [Get the secrets you will need](#get-the-secrets-you-will-need). This is named `<DB_ENGINE>_READONLY_USERNAME`
`<READONLY_PASSWORD>`                       | The password key retrieved as part of step [Get the secrets you will need](#get-the-secrets-you-will-need). This is named `<DB_ENGINE>_READONLY_PASSWORD`
`<READONLY_PASSWORD>`                       | The password key retrieved as part of step [Get the secrets you will need](#get-the-secrets-you-will-need). This is named `<DB_ENGINE>_READONLY_PASSWORD`
`<ESCAPED_READONLY_PASSWORD>`               | The `<READONLY_PASSWORD>` which has had single quotes escaped (See the [Get the secrets you will need](#get-the-secrets-you-will-need) for more detail)

## Prerequisites

* Have jq, gds-cli, and the aws cli installed and set up.
* Having created the RDS database using the [rds terraform deployment](https://github.com/alphagov/govuk-infrastructure/tree/main/terraform/deployments/rds/).
* Have logged in on the command line to AWS as either `platformengineer` or `fulladmin` (`gds aws govuk-<environment>-fulladmin -s`).
* Have [created a jumpbox to access the RDS database](/manual/create-bastion-pod.html)

## Get the secrets you will need

You will need to retrieve the database administrator password to allow you to log in as the super user, and also
the readonly credentials which will give you the hostname to connect to, and the username and password.

***WARNING***: If the readonly password contains any single quote characters `'` you will need to make this into an escaped single quote by doubling it to two single quotes, (e.g. `'` becomes `''`, so in the password `my_pass'word` you need to escape it by making it `my_pass''word`)`.

```
# Get the aws-db-admin password for <DB_NAME>
aws secretsmanager get-secret-value \
  --secret-id integration-rds-admin-passwords | \
    jq -r '.SecretString | fromjson | .["<DB_NAME>"]'

# Get All of the readonly credentials
aws secretsmanager get-secret-value \
  --secret-id govuk/<DB_NAME>/<DB_ENGINE>-readonly | \
    jq '.SecretString | fromjson'
```

## Connect to the RDS instance as the admin user

In the jumpbox created as part of the [prerequisites](#prerequisites) you should connect to the database:

For MySQL (when prompted for a password enter the `<DB_ADMIN_PASSWORD>`:

```
mysql --user aws_db_admin \
    --host <READONLY_HOSTNAME> \
    --port <READONLY_PORT> \
    --password
```

For PostgreSQL (when prompted for a password enter the `<DB_ADMIN_PASSWORD>`:

```
psql --user aws_db_admin \
    --host <READONLY_HOSTNAME> \
    --port <READONLY_PORT> \
    --dbname postgres
```

## Create the readonly user and grant privileges

Now you can execute the following SQL (taking care to replace the placeholders mentioned in [Conventions](#conventions) to create the readonly user.

For MySQL:

```sql
CREATE USER IF NOT EXISTS '<READONLY_USERNAME>';
ALTER USER '<READONLY_USERNAME>' IDENTIFIED BY '<ESCAPED_READONLY_PASSWORD>';
GRANT PROCESS, SELECT, SHOW VIEW, SHOW DATABASES ON *.* TO '<READONLY_USERNAME>';
FLUSH PRIVILEGES;
```

For PostgreSQL:

```sql
BEGIN
    IF NOT EXISTS (SELECT * FROM pg_roles WHERE rolname='<READONLY_USERNAME>') THEN
        CREATE ROLE <READONLY_USERNAME> WITH LOGIN PASSWORD '<ESCAPED_READONLY_PASSWORD>';
    ELSE
        ALTER ROLE <READONLY_USERNAME> WITH PASSWORD '<ESCAPED_READONLY_PASSWORD>';
    END IF;
    GRANT pg_read_all_data TO <READONLY_USERNAME>;
END
```

You can now disconnect the jumpbox and [delete the pod](/manual/create-bastion-pod.html#shut-down-the-bastion-pod).

## Add your database to the list of external secrets to be provisioned

***NOTE:*** You only need to do this for the first environment you provision a new RDS instance in, ArgoCD will create the ExternalSecret in all environments.

For your secret to be provisioned in kubernetes it needs to have a kubernetes ExternalSecret created.

To create this you need to add the `<DB_NAME>` to the relevant list (broken down by `<DATABASE_ENGINE>`) inside the `provisionDatabaseReadonlySecrets` key in the [external secrets helm chart values.yaml file](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/external-secrets/values.yaml).

For example, if you were adding the documentdb database `a_new_database` a diff patch would look as follows:

```diff
diff --git a/charts/external-secrets/values.yaml b/charts/external-secrets/values.yaml
index a8acf75112..f7416422ce 100644
--- a/charts/external-secrets/values.yaml
+++ b/charts/external-secrets/values.yaml
@@ -4,6 +4,7 @@ externalSecrets:

 provisionDatabaseReadonlySecrets:
   mysql:
+    - a_new_database
     - collections_publisher
     - release
     - search_admin
```

Within a few minutes of this PR being merged to main ArgoCD will (in all environments) apply the external secret configuration, which in turn will cause the external secrets operator to provision a secret in the cluster.

Both the ExternalSecret and the Secret will have the name `<DB_NAME_KEBABCASE>-<DB_ENGINE>-readonly` (e.g. `account_api` will be `account-api-postgres-readonly` and `whitehall` will be `whitehall-mysql-readonly`.
