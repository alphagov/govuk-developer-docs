---
title: Create a new database on the GOV.UK Kubernetes Platform
layout: multipage_layout
---

# Creating a new database

This guide gives you guidance on how to provision a new database for a brand new application. It assumes you have gone through all the steps and prerequisites in the [Create a new Application guidance][create-app]

## Update the TFC configuration variables

In the [govuk-infrastructure repo][govuk-infrastructure] repo, update the  relevant `tfc-configuration/variables-ENVIRONMENT.tf` file(s) (for example [`tfc-configuration/variables-integration.tf`][variables-integration.tf]) with your config. Make sure you do this for every environment you want to deploy to.

For example, if you're adding a database with the name `my_database`, you can add the following:

```terraform
my_database = {
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
    name                         = "my_database"
    allocated_storage            = 100
    instance_class               = "db.t4g.small"
    performance_insights_enabled = true
    project                      = "YOUR PROJECT NAME"
}
```

Once you have opened a PR and had it reviewed / merge, ensure you run the appropriate [`tfc-configuration`][tfc-configuration] workspace, as well as all the RDS workspaces for the appropriate environment (for example `rds-integration`).

## Create a database secret

Once the database instance has been created, create a database secret following [these instructions][Create database secret].

Make a note of the generated hostname, username and password.

## Create database and user

Now you have created your secret, you'll need to create the database and user inside your new instance.

First, you'll need to get the `aws_db_admin` password for your database. Acting as `govuk-ENVIRONMENT-fulladmin`, run the following command (where `DATABASE_NAME` is the name of the database instance you have created):

```bash
aws secretsmanager get-secret-value --secret-id  integration-rds-admin-passwords | jq '.SecretString' | jq 'fromjson | .DATABASE_NAME'
```

Next, start a bash session on the deployment where you intend to use your database (if it doesn't exist yet, any deployment that has access to your database, and supports Postgres will do):

```bash
kubectl exec -it deploy/YOUR_DEPLOYMENT -- bash
```

Then, inside the container, start a `psql` session where `HOSTNAME` is the hostname you got from the previous step:

```bash
psql -U aws_db_admin -h HOSTNAME -d postgres
```

Enter the password you created from the previous step when prompted.

Once in postgres, create your database and user:

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

[create-app]: https://docs.publishing.service.gov.uk/kubernetes/create-app/
[govuk-infrastructure]: https://github.com/alphagov/govuk-infrastructure/
[variables-integration.tf]: https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/tfc-configuration/variables-integration.tf
[tfc-configuration]: https://app.terraform.io/app/govuk/workspaces/tfc-configuration
[Create database secret]: https://docs.publishing.service.gov.uk/kubernetes/manage-app/manage-secrets/#creating-an-aws-managed-database-secret
