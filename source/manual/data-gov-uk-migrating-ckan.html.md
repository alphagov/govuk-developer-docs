---
owner_slack: "#govuk-platform-health"
title: Migrating data between CKAN instances
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-11-15
review_in: 8 weeks
---
[ckanext-datagovuk-github]: https://github.com/alphagov/ckanext-datagovuk

### Accessing CKAN

In order to transfer data between CKAN instances, it is required to dump the
CKAN database, reload into a new instance then perform the data migration.

#### Dumping data

Log into the Bytemark production machine and dump the database:

```
ssh co@co-prod3.dh.bytemark.co.uk pg_dump ckan > ckan_dump.sql
```

Log into the new machine in the correct environment and copy the file using SCP:

```
scp co@co-prod3.dh.bytemark.co.uk:ckan_dump.sql /some/local/directory
```

Load the database dump into the new environment:

```
sudo -u postgres psql -c 'CREATE DATABASE ckan;'
sudo -u postgres psql ckan -f /some/local/directory/ckan_dump.sql
```

#### Data schema migration

The data schema and models for the two CKAN instances do not match.  Therefore a
conversion is required to allow the dump to be used with the new CKAN
installation.  Scripts are available in
[ckanext-datagovuk][ckanext-datagovuk-github] to enable this.

##### Data models

The changes to the models are included in a single SQL migration script.  This
modifies the data to make it compatible with changes made in the new DGU
instance of CKAN.  It also removes non-publishing users and some deprecated
features, such as tags.

```
sudo -u postgres psql ckan -f /path/to/ckanext-datagovuk/migrations/001_bytemark_to_govuk.sql
```

> All sysadmin users will be demoted when running this migration.  They must be
> promoted again after the migration is complete.  This is to ensure only
> relevant people are given sysadmin access on the new system.

##### Database schema

CKAN provides a paster script to upgrade the database schema.  This should be
run after the data models have been updated.

```
paster db upgrade -c $CKAN_INI
```

