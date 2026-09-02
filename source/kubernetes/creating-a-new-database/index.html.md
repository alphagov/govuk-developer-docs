---
title: Create a new database on the GOV.UK Kubernetes Platform
layout: multipage_layout
---

# Creating a new database

This guide gives you guidance on how to provision a new database for a brand new application. It assumes you have gone through all the steps and prerequisites in the [Create a new Application guidance][create-app]

## 1. Update the TFC configuration variables

In the [govuk-infrastructure repo][govuk-infrastructure] repo, update the  relevant `terraform/variables/ENVIRONMENT/rds.tfvars` file(s) (for example [`terraform/variables/integration/rds.tfvars`][integration tfvars]) with your config. Make sure you do this for every environment you want to deploy to.

For example, if you're adding a database with the name `example_publisher`, you can add the following:

```terraform
example_publisher = {
    engine                      = "postgres"
    engine_version              = "17"
    allow_major_version_upgrade = true
    engine_params = {
      log_min_duration_statement = { value = 10000 }
      log_statement              = { value = "all" }
      deadlock_timeout           = { value = 2500 }
      log_lock_waits             = { value = 1 }
    }
    engine_params_family         = "postgres17"
    name                         = "example-publisher"
    allocated_storage            = 100
    instance_class               = "db.t4g.small"
    performance_insights_enabled = true
    project                      = "YOUR PROJECT NAME"
}
```

Once you have opened a PR and had it reviewed / merged, ensure you run the RDS workspace for the appropriate environment (for example `rds-integration`).

## 2. Create a database secret

Step 1 creates an RDS instance and automatically creates an `aws_db_admin` user (and password) with full administrative access to the instance.

Your app should use a separate, less permissive database user when interacting with the database.

The first step is to [create an AWS managed database secret][Create database secret].

## 3. Create database and user

Now you have created your secret, you'll need to create the database and user inside your new instance.

First, you'll need to get the `aws_db_admin` password for your database. Acting as `govuk-ENVIRONMENT-fulladmin`, run the following command (where `DATABASE_NAME` is the name of the database instance you created in step 1, e.g. `example_publisher`):

```bash
aws secretsmanager get-secret-value --secret-id  ENVIRONMENT-rds-admin-passwords | jq '.SecretString' | jq 'fromjson | .DATABASE_NAME'
```

Then you'll need to get the host name of your instance. Run the following, swapping `SECRET_NAME` for the value you chose in step 2 (e.g. `govuk/specialist-publisher/mysql`):

```bash
aws secretsmanager get-secret-value  --secret-id SECRET_NAME | jq '.SecretString | fromjson'
```

You'll see something like this:

```json
{
  "username": "specialist_publisher_mysql_user",
  "password": "REDACTED",
  "engine": "mysql",
  "host": "specialist-publisher-integration-mysql.REDACTED.eu-west-1.rds.amazonaws.com",
  "port": 3306,
  "dbInstanceIdentifier": "specialist-publisher-integration-mysql"
}
```

The `host` value is what you'll use for the `HOSTNAME` in the next step.

Next, start a bash session on the deployment where you intend to use your database (if it doesn't exist yet, any deployment that has access to your database, and supports your database engine will do):

```bash
kubectl exec -it deploy/YOUR_DEPLOYMENT -- bash
```

Now you have your:

- `AWS_DB_ADMIN_PASSWORD`
- `HOST`
- You'll also need to figure out `YOUR_DATABASE_NAME` (needs to match what you specify in govuk-helm-charts later - see [example][example-helm-chart-secret], e.g. `specialist_publisher_production`)
- You already have `YOUR_USER` (the Username you chose in step 2, e.g. `specialist_publisher_mysql_user`)
- And you'll need to generate a `YOUR_PASSWORD` (see [instructions](/manual/kubernetes/creating-a-new-database/password.html))

Then, inside the container, follow these steps:

### PostgreSQL database

Start a `psql` session where `HOSTNAME` is the hostname you got from the previous step:

```bash
psql -U aws_db_admin -h HOSTNAME -d postgres
```

Enter the `AWS_DB_ADMIN_PASSWORD` password you created from the previous step when prompted.

Once in postgres, create your database and user.

```psql
CREATE database "YOUR_DATABASE_NAME";
CREATE USER "YOUR_USER" WITH PASSWORD 'YOUR_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE "YOUR_DATABASE_NAME" to "YOUR_USER";
```

Now the database is created, connect to it:

```psql
\c YOUR_DATABASE_NAME
```

And grant your user privileges to all tables in the database like so:

```psql
GRANT ALL ON SCHEMA public TO "YOUR_USER";
```

### MySQL database

Start a `mysql` session where `HOSTNAME` is the hostname you got from the previous step:

```bash
mysql --user aws_db_admin --port 3306 --host HOSTNAME --password
```

Enter the `AWS_DB_ADMIN_PASSWORD` password you created from the previous step when prompted.

Once in MySQL, create your database and user.

```psql

CREATE DATABASE YOUR_DATABASE_NAME;
CREATE USER 'YOUR_USER'@'%' IDENTIFIED BY 'YOUR_PASSWORD';
GRANT ALL PRIVILEGES ON YOUR_DATABASE_NAME.* TO 'YOUR_USER'@'%';
```

## 4. Create a read only database user

***NOTE:*** We hope to automate this in the near future.

You should create a read only user in the RDS instance. You can follow the [Create readonly credentials for your RDS database guide](/kubernetes/creating-a-new-database/create-readonly-credentials-for-your-rds-database.html).

## 5. Set up environment sync

By convention, all of our apps should be a part of [GOV.UK's environment sync][env-sync], so that production data is copied to staging and integration.

Edit the [db-backup chart in govuk-helm-charts](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/db-backup/values.yaml).

[create-app]: https://docs.publishing.service.gov.uk/kubernetes/create-app/
[env-sync]: https://docs.publishing.service.gov.uk/manual/govuk-env-sync.html
[example-helm-chart-secret]: https://github.com/alphagov/govuk-helm-charts/blob/929933e881478eb154782d90721033f954f03c70/charts/external-secrets/templates/specialist-publisher/specialist-publisher-mysql.yaml#L20
[govuk-infrastructure]: https://github.com/alphagov/govuk-infrastructure/
[integration tfvars]: https://github.com/alphagov/govuk-infrastructure/blob/main/terraform//variables/integration/rds.tfvars
[tfc-configuration]: https://app.terraform.io/app/govuk/workspaces/tfc-configuration
[Create database secret]: https://docs.publishing.service.gov.uk/kubernetes/manage-app/manage-secrets/#creating-an-aws-managed-database-secret
