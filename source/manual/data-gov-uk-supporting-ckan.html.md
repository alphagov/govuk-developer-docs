---
owner_slack: "#datagovuk-tech"
title: Supporting CKAN
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-05-21
review_in: 3 months
---
[ckan]: https://ckan.org
[ckanext-datagovuk]: /apps/ckanext-datagovuk.html
[ckanext-dgu]: https://github.com/datagovuk/ckanext-dgu
[ckandocs]: http://docs.ckan.org/en/ckan-2.7.3/maintaining/paster.html

## Environments

There are currently three environments for [CKAN]:

- [Live](https://data.gov.uk) — co-prod3.dh.bytemark.co.uk
- [Test](https://test.data.gov.uk) — co-prod2.dh.bytemark.co.uk
- Development — co-dev1.dh.bytemark.co.uk

We are in the process of migrating [CKAN] to standard GOV.UK infrastructure.

## Applications

[ckanext-dgu] is the primary [CKAN] extension for the current environments.
This is being replaced with [ckanext-datagovuk] as part of the migration process. Although other extensions are used
in the deployment, [ckanext-dgu] and [ckanext-datagovuk] are the ones that contain our changes to functionality and
styling.

## Managing CKAN

First check to see if it is possible to complete the task through the
[system dashboard](https://data.gov.uk/data/system_dashboard). You will need a [system 
 administrator account](#creating-a-system-administrator-account).

For commands not available via the user interface you must connect to the server to run the commands. All of the 
commands to interact with [CKAN] use a tool called `paster`.

Many of these commands take a path to the config file with the `-c` option, although you can instead use
`-c $CKAN_INI` which should resolve to `/var/ckan/ckan.ini`.

On Bytemark servers `paster` should be run with:

```
cd /vagrant/src/ckan
. /home/co/ckan/bin/activate
paster
```

On GOV.UK servers `paster` should be run with:

```
cd /var/apps/ckan
sudo -u deploy govuk_setenv ckan venv/bin/paster
``` 

> Further, less commonly used, commands can be found in the [CKAN documentation][ckandocs].
> 
> There is also a separate [historical document of previous admin tasks](https://docs.google.com/document/d/1V64IK9VoHU5w-xQmmmvKXF396FQViHM06iJWnRoAxzc/edit?usp=sharing)
that you may wish to consult. 

### Creating a system administrator account

```
paster --plugin=ckan sysadmin add USERNAME email=EMAIL_ADDRESS -c $CKAN_INI
```

You will be prompted twice for a password.

### Removing a system administrator account

```
paster --plugin=ckan sysadmin remove USERNAME -c $CKAN_INI
```

### Managing users

#### Listing users

```
paster --plugin=ckan user list -c $CKAN_INI
```

#### Viewing a user

```
paster --plugin=ckan user USERNAME -c $CKAN_INI
```

#### Adding a user

```
paster --plugin=ckan user add USERNAME email=EMAIL_ADDRESS -c $CKAN_INI
```

#### Removing a user

```
paster --plugin=ckan user remove USERNAME -c $CKAN_INI
```

#### Changing a user's password

```
paster --plugin=ckan user setpass USERNAME -c $CKAN_INI
```

### Deleting a dataset

[CKAN] has two types of deletions, the default soft-delete, and a purge.  The soft delete gives the option of
undeleting a dataset but the purge will remove all trace of it from the system.

Where the following commands mention DATASET_NAME, this should either be the slug for the dataset, or the
UUID.

Deleting a dataset:

```
paster --plugin=ckan dataset delete DATASET_NAME -c $CKAN_INI
```

Purging a dataset:

```
paster --plugin=ckan dataset purge DATASET_NAME -c $CKAN_INI
```

### Rebuilding the search index

[CKAN] uses Solr for its search index, and occasionally it may be necessary to interact with it
to refresh the index, or rebuild it from scratch.

Refresh the entire search index:

```
paster --plugin=ckan search-index rebuild -r -c $CKAN_INI
```

Rebuild the entire search index:

```
paster --plugin=ckan search-index rebuild -c $CKAN_INI
```

Only reindex those packages that are not currently indexed:

```
paster --plugin=ckan search-index -o rebuild -c $CKAN_INI
```

### Managing the harvest workers

Although harvesters can mostly be managed from the user interface, it is
sometimes easier to perform these tasks from the command line. If using
a system administrator account you will see > 400 harvest configs without
a clear way of seeing which are currently running.

#### Listing current jobs

Returns a list of currently running jobs.  This will contain the
JOB_ID necessary to cancel jobs.

```
paster --plugin=ckanext-harvest harvester jobs -c $CKAN_INI
```

#### Cancelling a current job

To cancel a currently running job, you will require a JOB_ID from the
[Listing current jobs](#listing-current-jobs) section.

```
paster --plugin=ckanext-harvest harvester job_abort JOB_ID -c $CKAN_INI
```

#### Purging all currently queued tasks

It may be necessary, if there is a schedule clash and the system is too busy,
to purge the queues used in the various stages of harvesting

> Warning: This command will empty the Redis queues

```
paster --plugin=ckanext-harvest harvester purge_queues -c $CKAN_INI
```

### Adding a new Schema

Each new schema for the schema dropdown in [CKAN] needs a title and a URL ...

```
paster --plugin=pylons shell $CKAN_INI
```

Then in the REPL that loads:

```
>>> from ckanext.dgu.model.schema_codelist import Schema
>>> model.Session.add(Schema(url="[URL]", title="[TITLE]"))
>>> model.repo.commit_and_remove()
```

### Find all packages created during a specific timeframe

```
https://data.gov.uk/api/3/action/package_search?q=metadata_created:[2017-06-01T00:00:00Z%20TO%202017-06-30T00:00:00Z]
```

### Find all packages modified during a specific timeframe

```
https://data.gov.uk/api/3/action/package_search?q=metadata_modified:[2017-06-01T00:00:00Z%20TO%202017-06-30T00:00:00Z]
```

### Find all packages where a resource has a partial URL

```
psql ckan
```

```sql
SELECT DISTINCT (p.name)
FROM package p
INNER JOIN resource_group rg ON rg.package_id = p.id
INNER JOIN resource r ON r.resource_group_id = rg.id
WHERE r.url LIKE '%neighbourhood.statistics.gov.uk%'
  AND p.state = 'active';
```

### Stopping a harvester

Find the UUID of the harvester:

```
psql ckan -c "SELECT id FROM harvest_source WHERE name = '[NAME]'"
```

Set all jobs belonging to that harvester to finished:

```
psql ckan -c "UPDATE harvest_job SET finished = NOW(), status = 'Finished' WHERE source_id = '[UUID]' AND NOT status = 'Finished';" 
```

### Change a publisher's name

Change the name in the publisher page then reindex that publisher:

```
paster --plugin=ckan search-index rebuild-publisher [PUBLISHER} -c $CKAN_INI
```

### Register a brownfield dataset

See the [supporting manual](https://docs.google.com/document/d/1SxzN9Ihat75TXo-fMwFqW_qBS-bPKHRs-a-tAO-qA1c/edit?usp=sharing).
