---
owner_slack: "#govuk-platform-health"
title: Migrating data between CKAN instances
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-12-17
review_in: 8 weeks
---
[ckanext-datagovuk-github]: https://github.com/alphagov/ckanext-datagovuk

### Accessing CKAN

In order to transfer data between CKAN instances, it is required to dump the
CKAN database, reload into a new instance then perform the data migration.

#### Dumping data

Create a dump of the Postgres database currently on the Bytemark production machine:

```
ssh co@co-prod3.dh.bytemark.co.uk "pg_dump -x -O ckan | gzip" > ckan_dump.sql.gz
```

SCP the file to the db-admin machine in the correct environment using SCP:

```
scp -o ProxyCommand="ssh -At jumpbox.integration.govuk.digital -W %h:%p" ckan_dump.sql.gz db-admin:/some/remote/directory
```

Load the database dump into the new environment (obtain the username and password
for `aws_db_admin` from secrets):

```
govukcli set-context integration
govukcli ssh db_admin
psql postgres://aws_db_admin:password@postgresql-primary/ckan_production -c "SET session_replication_role = 'replica'"
gunzip -c /some/directory/ckan_dump.sql.gz | psql postgres://aws_db_admin:password@postgresql-primary/ckan_production
psql postgres://aws_db_admin:password@postgresql-primary/ckan_production -c "SET session_replication_role = 'origin'"
```

> The `session_replication_role` must be set to ensure foreign key validation is
> switched off during the import.

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
govukcli set-context integration
govukcli ssh db_admin
psql postgres://aws_db_admin:password@postgresql-primary/ckan_production -f /path/to/ckanext-datagovuk/migrations/001_bytemark_to_govuk.sql
```

> All sysadmin users will be demoted when running this migration.  They must be
> promoted again after the migration is complete.  This is to ensure only
> relevant people are given sysadmin access on the new system.

##### Database schema

CKAN provides a paster script to upgrade the database schema.  This should be
run after the data models have been updated.

Unfortunately, there is an auto-upgrade feature in `ckanext-harvest` which runs
before any paster command (including `db upgrade`) and assumes you have already
run the `db upgrade`.  You must therefore edit the `ckan.ini` to remove the
plugins before running this step (they must be added again after the core
CKAN migration is done).  This is the recommended solution given in the
[CKAN documentation](https://docs.ckan.org/en/2.8/maintaining/database-management.html#upgrading).

```
govukcli set-context integration
govukcli ssh ckan
. /var/apps/ckan/venv/bin/activate
paster --plugin=ckan db upgrade -c /var/ckan/ckan.ini
```

##### Harvest sources

Substantial changes were made to harvest records between the CKAN version, in
particular harvest sources are now stored as packages, alongside the actual
dataset packages.

An auto-migration occurs for the harvesting plugin when a request is made to
the web server.  This may result in a 504 (timeout) until the migration has
completed.  To avoid this, run the migration paster command again, but this
time with all the plugins specified in `ckan.ini`.

```
govukcli set-context integration
govukcli ssh ckan
. /var/apps/ckan/venv/bin/activate
paster --plugin=ckan db upgrade -c /var/ckan/ckan.ini
```

##### Re-index Solr


CKAN uses Solr to power some API responses (and therefore some UI content).
Once a migration has been completed, Solr will need to be reindexed in it's
entirety, otherwise it will be out of sync with the Postgres database.

```
govukcli set-context integration
govukcli ssh ckan
. /var/apps/ckan/venv/bin/activate
paster --plugin=ckan search-index rebuild -c /var/ckan/ckan.ini
```
