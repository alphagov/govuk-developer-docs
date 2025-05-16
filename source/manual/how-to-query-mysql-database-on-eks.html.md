---
owner_slack: "#govuk-developers"
title: How to query MySQL database on EKS
section: Databases
layout: manual_layout
parent: "/manual.html"
---

## Pre-requisites: Logins and Credentials

In order to run the SQL queries and extract files from EKS pods, you would need to be able to access:

1. the bash shell from the desired EKS pod in the corresponding environment
1. MySQL database login credentials from AWS Secrets Manager for the corresponding environment

### Log into an EKS pod bash session

1. Setup Kubernetes and environments according to [the EKS setup guide](https://docs.publishing.service.gov.uk/kubernetes/cheatsheet.html#content)

2. Switch to desired environment, e.g.

```
eval $(gds aws govuk-integration-developer -e --art 8h)
kubectl config use-context integration
```

3. Log into shell for desired app, e.g.

```
kubectl exec -it deploy/whitehall-admin -- bash
```

4. Validate environment

```
echo $GOVUK_ENVIRONMENT
```

### Fetch Database login credentials from AWS Secrets Manager

1. Log into the AWS console with the desired role

```
gds aws govuk-integration-developer -l
```

2. Choose Secrets Manager from the Services menu

3. Search for `mysql` and click on the desired mysql database, e.g. `govuk/whitehall-admin/mysql`

4. Under Secret value, choose the `Retrieve secret value` button on the right-hand side.

## How to: Query database through MySQL console

1. [Log into the desired EKS pod](#log-into-an-eks-pod-bash-session)

2. Log into MySQL console using the [MySQL credentials fetched from AWS](#fetch-database-login-credentials-from-aws-secrets-manager). You will be prompted for the password.

```
mysql -h <db-host> -u <db-username> -p -D <database name>
```

3. Run any SQL statements to query the database

## How to: Export query into a CSV file for your local machine

1. [Log into the desired EKS pod](#log-into-an-eks-pod-bash-session)

2. Run direct query within command line and pipe the output to file. Note we are piping to `tr` first to get CSV format.

```
mysql -h <db-host> \
-u <db-username> -p \
-D <db name> -B \
-e "<SQL Statement>" \
| tr '\t' ',' \
> <output file e.g. output.csv>
```

3. Log out of the EKS box `exit`

4. Copy the file from the EKS pod to local machine

```
kubectl cp -n apps \
<pod-name>:<source file to copy> \
<target location>
```
