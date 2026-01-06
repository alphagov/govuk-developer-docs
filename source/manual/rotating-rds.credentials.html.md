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

## Logging into the Instance

Next, you will need to use the Jumpbox to start an interactive session with the Database Engine.

### Getting the `rdsadmin` Root User Credentials

First, log in to the relevant AWS Console environment:

```sh
$ gds aws govuk-some-environment-developer -l
```

To manage Database Authentication, you will need to use the Root User which can be found in AWS Secrets Manager
 under the key `[env-name]-rds-admin-passwords` - replace `[env-name]` with the relevant environment name.

Once you have found the above secret, you will find key/value pairs for each RDS instance and the corresponding password.

If you also need to find the hostname for the relavant RDS instance, you can either find this by locating the RDS instance in the AWS Console,
 or you can view it in the relevant secret under `govuk/[app-name]/[db-engine]` - substitute `[app-name]` and `[db-engine]` as relevant.

### Logging in to a MySQL Instance with the `rdsadmin` User

With a valid "fulladmin" AWS role, use `kubectl exec` against the Jumpbox you created earlier to start a bash session:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps exec -it mysql-jumpbox -- bash
```

If everything worked, you should now have a bash prompt inside the container.

```sh
$ mysql --host [rds-hostname] -p -u rdsadmin
```

Replace `[rds-hostname]` with the relevant hostname. You will be promted for the password you fetched earlier.