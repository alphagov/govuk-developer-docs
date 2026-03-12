---
owner_slack: "#govuk-platform-engineering"
title: Create a Bastion or "Jump box" to Access Databases
section: Databases
layout: manual_layout
parent: "/manual.html"
---

This documentation explains how to create, use and destroy a bastion or "jump box" pod to interact with databases hosted by RDS (Relational Database Service).

## The process

1. Use the template below to create a pod definition
2. Use `kubectl apply` to apply the definition
3. Use `kubectl exec` to enter the pod container and use the MySQL or Postgres CLI clients as necessary
4. Use `kubectl delete` to tear down the bastion pod

# Create the bastion or "jump box" pod defintion

Depending on the database engine, you will need to use a different image - select the correct pod definition template...

## Pod definition for MySQL

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

## Pod definition for Postgres

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

# Apply the selected pod definition

Once you've saved the pod defnition file locally, you will want to apply it to the required cluster -
you will need either `platformengineer` or `fulladmin` roles to do this:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps apply -f mysql-jumpbox.yaml # or postgres-jumpbox.yaml
```

# Connect to the bastion

Assuming the pod definition was applied correctly, you can now enter the Bastion:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps exec -it mysql-jumpbox -- bash # or postgres-jumpbox
```

You should now have a bash prompt inside the container:

```sh
I have no name!@mysql-jumpbox:/$
```

# Shut down the bastion pod

Once you finish with the bastion pod, you should delete it:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps delete -f mysql-jumpbox.yaml # or postgres-jumpbox.yaml
```
