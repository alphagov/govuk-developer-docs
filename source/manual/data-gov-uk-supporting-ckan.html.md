---
owner_slack: "#govuk-platform-health"
title: Support tasks for CKAN
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-05-30
review_in: 6 months
---
[ckan]: https://ckan.org
[dgu-ckan]: https://ckan.publishing.service.gov.uk
[ckanext-datagovuk]: /apps/ckanext-datagovuk.html
[ckandocs]: http://docs.ckan.org/en/ckan-2.7.4/maintaining/paster.html
[ckan-api]: https://docs.ckan.org/en/2.8/api/

[CKAN][dgu-ckan] is the publishing application for data.gov.uk.  [ckanext-datagovuk] is the primary [CKAN] extension for data.gov.uk.

## Environments

There are three environments for [CKAN]:

- [Production][dgu-ckan]
- [Staging](https://ckan.staging.publishing.service.gov.uk)
- [Integration](https://ckan.integration.publishing.service.gov.uk)

You can SSH onto these machines in [same way as all other GOV.UK AWS applications](/manual/howto-ssh-to-machines-in-aws.html#header).  The machine node class is `ckan`.

## Managing CKAN

First check to see if it is possible to complete the task through the [web interface][dgu-ckan]
(credentials are available in the `govuk-secrets` password store, under `datagovuk/ckan`).

For commands not available via the user interface you must connect to the server to perform these
tasks.  Most of the commands to interact with [CKAN] use a tool called `paster`.  Many of these
commands take a path to the config file with the `-c` option, which is located at `/var/ckan/ckan.ini`
in our deployments.

On GOV.UK servers `paster` should be run with:

```
cd /var/apps/ckan
sudo -u deploy govuk_setenv ckan venv/bin/paster [COMMAND] -c /var/ckan/ckan.ini
```

### Initialising the database

There may be times when you need to start with an empty database (e.g. on integration).
The following commands will create the relevant schema for core CKAN and the harvesting
extension on integration.

```
. /var/apps/ckan/venv/bin/activate
paster --plugin=ckan db init -c /var/ckan/ckan.ini
paster --plugin=ckanext-harvest harvester initdb -c /var/ckan/ckan.ini
```

### Accessing the database

In order to access the CKAN database to run queries on the `db_admin` machine:

`psql -U ckan -h postgresql-primary -p 5432 ckan_production`

The password can be found in the `/var/ckan/ckan.ini` file on the `ckan` machine for the environment you are targeting.

### Accessing the CKAN API

There are times when it can be useful to access the [CKAN API][ckan-api] when debugging or resolving issues. Note that the responses will be different depending on your access permissions.

For APIs that require an ID, the ID can be specified as either the GUID or the URL slug (referred to as a URL name in CKAN) e.g.

```
https://data.gov.uk/api/3/action/package_show?id=f760008b-86d3-4bbb-89da-1dfe56101554
```

Here are some more complex examples of using the API, as well as some where the documentation is more sparse.

```
# Find all packages created during a specific timeframe
https://data.gov.uk/api/3/action/package_search?q=metadata_created:[2017-06-01T00:00:00Z%20TO%202017-06-30T00:00:00Z]

# Find all packages modified during a specific timeframe
https://data.gov.uk/api/3/action/package_search?q=metadata_modified:[2017-06-01T00:00:00Z%20TO%202017-06-30T00:00:00Z]

# Count all packages and list a sample
 https://ckan.publishing.service.gov.uk/api/search/dataset?fl=id,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20dataset_type:dataset&limit=20

# Count harvested packages and list a sample
 https://ckan.publishing.service.gov.uk/api/search/dataset?fl=id,state,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20extras_harvest_object_id:[%22%22%20TO%20*]%20and%20dataset_type:dataset&limit=20

# Count manually published packages and list a sample
 https://ckan.publishing.service.gov.uk/api/search/dataset?fl=id,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20-extras_harvest_object_id:*%20and%20dataset_type:dataset&limit=20

# Count packages harvested in last 7 days and list a sample https://ckan.publishing.service.gov.uk/api/search/dataset?fl=id,state,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20extras_harvest_object_id:[%22%22%20TO%20*]%20and%20dataset_type:dataset%20and%20metadata_modified:[NOW-7DAY/DAY%20TO%20NOW]&limit=20

# Count packages manually published in last 7 days and list a sample https://ckan.publishing.service.gov.uk/api/search/dataset?fl=id,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20-extras_harvest_object_id:*%20and%20dataset_type:dataset%20and%20metadata_modified:[NOW-7DAY/DAY%20TO%20NOW]&limit=20

# Count packages from Daily harvest sources and list a sample
https://ckan.publishing.service.gov.uk/api/search/dataset?fl=id,metadata_modified,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id,extras_frequency-of-update&q=state:active%20and%20extras_harvest_object_id:%5B%22%22%20TO%20*%5D%20and%20frequency-of-update:daily%20and%20dataset_type:dataset&limit=20

# List all publishers
https://data.gov.uk/api/3/action/organization_list

# View a publisher record
https://data.gov.uk/api/3/action/organization_show?id=government_digital_service

# View a user (e.g. to get CKAN API key for a publishing user)
https://data.gov.uk/api/3/action/user_show?id=user_d484581
```

### Creating a system administrator account

```
paster --plugin=ckan sysadmin add USERNAME email=EMAIL_ADDRESS -c /var/ckan/ckan.ini
```

You will be prompted twice for a password.

### Removing a system administrator account

```
paster --plugin=ckan sysadmin remove USERNAME -c /var/ckan/ckan.ini
```

### Managing users

#### Listing users

```
paster --plugin=ckan user list -c /var/ckan/ckan.ini
```

#### Viewing a user

```
paster --plugin=ckan user USERNAME -c /var/ckan/ckan.ini
```

#### Adding a user

```
paster --plugin=ckan user add USERNAME email=EMAIL_ADDRESS -c /var/ckan/ckan.ini
```

#### Removing a user

```
paster --plugin=ckan user remove USERNAME -c /var/ckan/ckan.ini
```

#### Changing a user's password

```
paster --plugin=ckan user setpass USERNAME -c /var/ckan/ckan.ini
```

### Deleting a dataset

[CKAN] has two types of deletions, the default soft-delete, and a purge.  The soft delete gives the option of
undeleting a dataset but the purge will remove all trace of it from the system.

Where the following commands mention DATASET_NAME, this should either be the slug for the dataset, or the
UUID.

Deleting a dataset:

1. Find the dataset in the CKAN UI
2. Click on the 'Manage' button, then the 'Delete' button at the bottom of the page

> The 'Delete' button is currently not available for draft datasets. In order to soft-delete a draft dataset, follow the above steps, but manually change 'edit' to 'delete' on the 'Manage' page for the dataset.

Purging a dataset:

```
paster --plugin=ckan dataset purge DATASET_NAME -c /var/ckan/ckan.ini
```

There may be times when a large number of datasets must be deleted.  This can be done remotely from your
machine using the CKAN API.  Your API key is required, which can be obtained from your user profile on
the web interface.  Put a list of dataset slugs or GUIDs in a text file, with one dataset per line, then
run the following.

```
while read p; do curl --request POST --data "{\"id\": \"$p\"}" --header "Authorization: <your_api_key>" https://data.gov.uk/api/3/action/package_delete; done < list_of_ids.txt
```

After deleting or purging a dataset, it will take up to 10 minutes to update on Find, due to the sync process.

### Rebuilding the search index

[CKAN] uses Solr for its search index, and occasionally it may be necessary to interact with it
to refresh the index, or rebuild it from scratch.

Refresh the entire search index (this adds/removes datasets, but does not clear the index first):

```
paster --plugin=ckan search-index rebuild -r -c /var/ckan/ckan.ini
```

Rebuild the entire search index (this deletes the index before re-indexing begins):

```
paster --plugin=ckan search-index rebuild -c /var/ckan/ckan.ini
```

> Rebuilding the entire search index immediately removes all records from the search before re-indexing
> begins.  No datasets will be served from the `package_search` API endpoint until the re-index has
> completed.  This command should therefore only be used as a last resort since it will cause the sync
> process to assume there is no data for a period of time.


Only reindex those packages that are not currently indexed:

```
paster --plugin=ckan search-index -o rebuild -c /var/ckan/ckan.ini
```

### `csw` endpoint unavailable

The `csw` endpoint should be available on <https://data.gov.uk/csw> which
should redirect to <https://ckan.publishing.service.gov.uk/csw>.

If it is not showing xml with an error `Missing keyword: service` you can check
that it is running on the `ckan` machine:

```sh
$ sudo service pycsw_web-procfile-worker status
pycsw_web-procfile-worker start/running

$ $ ps aux | grep pycsw
root     29503  0.0  0.0  59652  2040 ?        Ss   06:04   0:00 sudo -u deploy -E sh -c PATH=/usr/lib/rbenv/shims:$PATH exec  unicornherder --gunicorn-bin ./venv/bin/gunicorn -p /var/run/ckan/pycsw_unicornherder.pid -- ckanext.datagovuk.pycsw_wsgi --bind localhost:${PYCSW_PORT} --timeout ${GUNICORN_TIMEOUT} --workers ${GUNICORN_WORKER_PROCESSES} --log-file /var/log/ckan/pycsw.out.log --error-logfile /var/log/ckan/pycsw.err.log 2>>'/var/log/ckan/procfile_pycsw_web.err.log' 1>>'/var/log/ckan/procfile_pycsw_web.out.log'
...
```

If no running processes are found then you can restart it using this command:

```sh
$ sudo service pycsw_web-procfile_worker restart
```

It is worth checking the `pycsw` logs to investigate why it failed:

```sh
$ tail -f /var/log/ckan/pycsw.err.log
```

You can get a summary of `csw` records available from this url https://ckan.publishing.service.gov.uk/csw?service=CSW&version=2.0.2&request=GetRecords&typenames=csw:Record&elementsetname=brief

### Syncing the `csw` records with `ckan` datasets

Normally the sync between `csw` and `ckan` will start at 6 each day, but in
case it should fail or if the sync needs to happen sooner you can manually
trigger the sync after Solr has been reindexed.

```sh
$ paster --plugin=ckanext-spatial ckan-pycsw load -p /var/ckan/pycsw.cfg -u http://localhost:3220
```

### Managing the harvest workers

Although harvesters can mostly be managed from the [user interface](https://data.gov.uk/harvest), it is
sometimes easier to perform these tasks from the command line.

#### Listing current jobs

Returns a list of currently running jobs.  This will contain the
JOB_ID necessary to cancel jobs.

```
paster --plugin=ckanext-harvest harvester jobs -c /var/ckan/ckan.ini
```

It may be faster to run a SQL query to get the ID of a specific harvest job.

```
psql ckan_production -c "SELECT id FROM harvest_source WHERE name = '[NAME]'"
```

#### Cancelling a current job

Sometimes a harvest job can get stuck and not complete, and it's not possible to
restart/reharvest through the UI. You can get the `JOB_ID` from the
[Listing current jobs](#listing-current-jobs) section, or from the harvest dashboard
under "Last Harvest Job".

```
paster --plugin=ckanext-harvest harvester job_abort JOB_ID -c /var/ckan/ckan.ini
```

This can also be done by running SQL:

```
psql ckan_production -c "UPDATE harvest_job SET finished = NOW(), status = 'Finished' WHERE source_id = '[UUID]' AND NOT status = 'Finished';"
```

#### Purging all currently queued tasks

It may be necessary, if there is a schedule clash and the system is too busy,
to purge the queues used in the various stages of harvesting

> **WARNING**
>
> This command will empty the Redis queues

```
paster --plugin=ckanext-harvest harvester purge_queues -c /var/ckan/ckan.ini
```

#### Restarting the harvest queues

If the queues stall, it may be necessary to restart one or both of the harvest
queues.

The gather jobs retrieve the identifiers of the updated datasets and create
jobs in the fetch queue.

```
sudo initctl restart harvester_gather_consumer-procfile-worker
```

The fetch job retrieve the datasets from the remote source and perform the
relevant updates in CKAN.

```
sudo initctl restart harvester_fetch_consumer-procfile-worker
```

### Change a publisher's name

Change the name in the publisher page then reindex that publisher:

```
paster --plugin=ckan search-index rebuild-publisher [PUBLISHER] -c /var/ckan/ckan.ini
```

### Register a brownfield dataset

See the [supporting manual](https://docs.google.com/document/d/1SxzN9Ihat75TXo-fMwFqW_qBS-bPKHRs-a-tAO-qA1c/edit?usp=sharing).
