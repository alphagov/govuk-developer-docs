---
owner_slack: "#govuk-platform-engineering-team"
title: DocumentDB and MongoDB Management
section: Databases
layout: manual_layout
parent: "/manual.html"
---

This documentation explains how to perform some basic MongoDB (or DocumentDB) management.

## Creating a Bastion or "Jumpbox" Pod

Before you can interact with DocumentDB/MongoDB, you will need to set up a way to interact with the DocumentDB instances.

Save this Pod Definition to a local file of your choosing (we will assume `docdb-jumpbox.yaml`):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: docdb-jumpbox
spec:
  containers:
  - name: docdb-jumpbox
    image: mongo:3.6
    env:
      - name: MONGODB_URI
        valueFrom:
          secretKeyRef:
            key: MONGODB_URI
            name: asset-manager-docdb
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
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps apply -f docdb-jumpbox.yaml
```

Once you have done this, you should be able to exec into a bash session in the container:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps exec -it docdb-jumpbox -- bash
```

If everything worked, you should now have a bash prompt inside the container.

## Logging into the DocumentDB Instance

Next, you will need to use the Mongo Client to access the DocumentDB instance.

First, log into the AWS Console for the relevant environment:

```sh
$ gds aws govuk-some-environment-developer -l
```

Navigate to Secrets Manager. Search for and access the secret `govuk/common/shared-documentdb`.
Retrieve the values as you will require the `host` and `password` keys.

Now, run the following command in the bash session you opened earlier:

```sh
$ mongo [your-hostname-here] -u master
```

Paste the password from earlier.

If everything was successful, you should now be connected to the DocumentDB session.

## Common Commands

Here are some common commands:

### List Databases

```mongo
show dbs
```

### Select a Database

```mongo
use your_db_name_here
```

### Show Collections (once you have selected a DB)

```mongo
show collections
```

### Basic Find

```mongo
db.collection_name.find({key: "Value"}).pretty()
```

### Check Version

```mongo
db.version()
```

### Check Cluster Status

```mongo
printjson(rs.status())
```

### Cheat Sheet

A more detailed MongoDB "Cheat Sheet" can be found at the MongoDB website:  
https://www.mongodb.com/developer/products/mongodb/cheat-sheet/

## Deleting a Database

> **WARNING**: This is obviously going to be dangerous. Data destruction lies ahead.
> Check that you are running things in the correct environment and check that you
> have selected the correct Database.

To delete a Database (not the Database Cluster or Instance), connect and log in to the Database as directed above. Then select the Database you wish to delete:

```mongo
use name_of_database
```

Perform any checks to make sure you have selected the correct database, and then delete it using this function:

```mongo
db.dropDatabase()
```

...and you're done. You can show the Databases again to confirm the deletion:

```mongo
show dbs
```

To finish, exit the Mongo Client:

```mongo
exit
```

...and then exit the pod:

```sh
$ exit
```

> Note: DocumentDB is not synced between Production and Staging.
> If you delete a Database in Production, you will also need to manually delete it in
> Staging as well.

## Destroying the Bastion Pod

Once you have completed your work interacting with the Database, you should delete the pod.
Using the same Pod definition as earlier, you should run this command from the same directory:

```sh
$ gds aws govuk-some-environment-fulladmin -- kubectl -n apps delete -f docdb-jumpbox.yaml
```
