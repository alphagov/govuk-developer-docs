---
owner_slack: "#govuk-platform-health"
title: Support tasks for CKAN
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---
[ckan]: https://ckan.org
[dgu-ckan]: https://ckan.publishing.service.gov.uk
[ckanext-datagovuk]: /apps/ckanext-datagovuk.html
[ckandocs]: http://docs.ckan.org/en/ckan-2.7.4/maintaining/paster.html
[ckan-api]: https://docs.ckan.org/en/2.8/api/
[security_policy]: https://github.com/ckan/ckan/security/policy
[issues]: https://github.com/ckan/ckan/issues
[ckan_repo]: https://github.com/ckan/ckan

[CKAN][dgu-ckan] is the publishing application for data.gov.uk.  [ckanext-datagovuk] is the primary [CKAN] extension for data.gov.uk.

## Support

If you find an issue with CKAN that you believe may be a potential security
vulnerability please contact security@ckan.org rather than disclosing the
information publicly (as per their [security policy][security_policy]).

If you find an issue that does not appear to be a security vulnerability you
should first search the [issues][issues] of the upstream [CKAN
repository][ckan_repo] to see if it has already been reported and if there is a
workaround. If there is not an issue, considering opening a new one or - if you
know how to fix it - open a PR to resolve the problem.

## Environments

There are three environments for [CKAN]:

- [Production][dgu-ckan]
- [Staging](https://ckan.staging.publishing.service.gov.uk)
- [Integration](https://ckan.integration.publishing.service.gov.uk)

You can SSH onto these machines in [same way as all other GOV.UK AWS applications](/manual/howto-ssh-to-machines.html).  The machine node class is `ckan`.

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

The password can be extracted from the configuration file on the `ckan` machine for the environment you are targeting:

`more /var/ckan/ckan.ini | grep sqlalchemy`

### Accessing the CKAN API

There are times when it can be useful to access the [CKAN API][ckan-api] when debugging or resolving issues. Note that the responses will be different depending on your access permissions.

Queries can use the package ID or name (the slug) e.g.

```
https://data.gov.uk/api/3/action/package_search?q=id:93a39f01-7bba-430f-aa35-c30bf2d88b2f
returns the same as
https://data.gov.uk/api/3/action/package_search?q=name:north-lincolnshire-brown-field-register

```

Here are some more complex examples of using the API, as well as some where the documentation is more sparse:

```
# Retrieve full details about a package (dataset)
https://data.gov.uk/api/3/action/package_search?q=name:north-lincolnshire-brown-field-register

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

### Managing publishers

#### Change a publisher's name

Change the name in the publisher page then reindex that publisher:

```
paster --plugin=ckan search-index rebuild-publisher [PUBLISHER] -c /var/ckan/ckan.ini
```

### Managing datasets

#### Deleting a dataset

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

#### Listing datasets

You can get a list all datasets (including those which have been deleted) for a particular organisation by exporting a
CSV directly from the database.

First, find the id of the organisation you want via the API (here, finding the id of the Environment Agency)"

```
https://ckan.publishing.service.gov.uk/api/3/action/organization_show?id=environment-agency
```

Then follow the [instructions to access the database](#accessing-the-database)
The following query will list all datasets for the Environment Agency, with the number of records for each and export the result to a CSV file.

```
\copy (SELECT package.name, package.title, package.url, package.state, COUNT(resource.package_id) as num_resources FROM package LEFT JOIN resource ON (resource.package_id = package.id) WHERE package.owner_org='11c51f05-a8bf-4f58-9b95-7ab55f9546d7' GROUP BY package.id) to 'output.csv' csv header;
```

You can then use scp-pull from the govuk-connect tool to download the file to your machine.

#### Register a brownfield dataset

See the [supporting manual](https://docs.google.com/document/d/1SxzN9Ihat75TXo-fMwFqW_qBS-bPKHRs-a-tAO-qA1c/edit?usp=sharing).

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

### `csw` endpoint

The `csw` endpoint should be available on <https://data.gov.uk/csw> which
should redirect to <https://ckan.publishing.service.gov.uk/csw>.

#### `csw` endpoint unavailable

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

You can get a summary of `csw` records available from this url <https://ckan.publishing.service.gov.uk/csw?service=CSW&version=2.0.2&request=GetRecords&typenames=csw:Record&elementsetname=brief>

#### Syncing the `csw` records with `ckan` datasets

Normally the sync between `csw` and `ckan` will start at 6 each day, but in
case it should fail or if the sync needs to happen sooner you can manually
trigger the sync after Solr has been reindexed.

```sh
$ paster --plugin=ckanext-spatial ckan-pycsw load -p /var/ckan/pycsw.cfg -u http://localhost:3220
```

### Harvesting

Although harvesters can mostly be managed from the [user interface](https://data.gov.uk/harvest), it is
sometimes easier to perform these tasks from the command line.

#### List current jobs

Returns a list of currently running jobs.  This will contain the
JOB_ID necessary to cancel jobs.

```
paster --plugin=ckanext-harvest harvester jobs -c /var/ckan/ckan.ini
```

It may be faster to run a SQL query to get the ID of a specific harvest job.
You can do this by running the command from [Accessing the database](#accessing-the-database)
and passing a `-c` argument:

```
<psql_ckan_production_command> -c "SELECT id FROM harvest_source WHERE name = '[NAME]'"
```

#### Find the harvest source of a dataset

The harvest source of a dataset can be found using the CKAN API. Once you have
the slug of the dataset, you can go to the following URL:

```
https://ckan.publishing.service.gov.uk/api/action/package_show?id=<slug>
```

In the JSON response there should be a `harvest` field which will tell you the
ID and name of the harvest source.

#### Get the status of a harvester

1. Login to [CKAN][ckan] as a sysadmin user (credentials are available in the `govuk-secrets` password store, under `datagovuk/ckan`).
1. Navigate to the relevant harvester (use the 'Harvest' button in the header).
1. You will see a list of the datasets imported by this harvest source.
1. Click the 'Manage' button to get the status.
1. A summary of the current status will be shown.  Individual runs (and the error messages logged) can be access from the 'Jobs' tab.

#### Restart a harvest job

1. Follow the steps to [get the status of a harvester](#get-the-status-of-a-harvester).
1. If the harvester is currently running, click the 'Stop' button to stop it.
   Once it has stopped, or if it is not currently running, click the 'Reharvest' button.
   You will know if the harvester is running because the 'Reharvest' button will be disabled.

If the harvest job is hanging and the 'Stop' button is not responding, you will have to log on to the `ckan` machine to restart it:

1. SSH into the ckan machine with `gds govuk connect -e production ssh ckan`
1. Assume the deploy user - `sudo su deploy`
1. Activate the virtual environment - `. /var/apps/ckan/venv/bin/activate`
1. Run the harvest job manually - `paster --plugin=ckanext-harvest harvester run_test <harvest source> -c /var/ckan/ckan.ini`
  - where `harvest source` is from the url when visiting the harvest source page, it will be something like `cabinet-office`

If the job fails to complete the ticket should be updated with comments and prioritised to low for the product owner to review.

#### Cancel a harvest job

1. Follow the steps to [get the status of a harvester](#get-the-status-of-a-harvester).
1. Click the 'Stop' button to stop it.

Sometimes a harvest job can get stuck and not complete, and it's not possible to cancel it through the UI.
You can get the `JOB_ID` from the harvest dashboard under "Last Harvest Job" (or from [Listing current jobs](#listing-current-jobs)).

Then cancel the job by running:

```
paster --plugin=ckanext-harvest harvester job_abort JOB_ID -c /var/ckan/ckan.ini
```

This can also be done by running SQL:

```
<psql_ckan_production_command> -c "UPDATE harvest_job SET finished = NOW(), status = 'Finished' WHERE source_id = '[UUID]' AND NOT status = 'Finished';"
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

#### Restarting the harvest service

The harvesting process runs as a single threaded program, if any harvesting
process crashes by raising an exception, it will take out the entire process.
We have configured Upstart to restart the process automatically, but if the
service keeps crashing, Upstart will decide it's unhealthy and stop that after
a while.

You can check whether the process is still running by checking if entries are
still being written to the log file on the `ckan` machine:

```bash
$ gds govuk connect -e production ssh ckan
$ sudo tail -f /var/log/ckan/procfile_harvester_fetch_consumer.err.log
```

Or you could check that the services are all showing as `started` on the `ckan`
machine:

```bash
$ sudo initctl list | grep harvester
```

If any of the services are not showing as `started`, you will need to restart
them. There are both 'gather' and 'fetch' jobs that may need restarting:

'Gather' jobs retrieve the identifiers of the updated datasets and create jobs
in the fetch queue. To restart, run:

```
$ sudo initctl restart harvester_gather_consumer-procfile-worker
```

'Fetch' jobs retrieve the datasets from the remote source and perform the relevant
updates in CKAN. To restart, run:

```
$ sudo initctl restart harvester_fetch_consumer-procfile-worker
```

Alternatively, if the server has stopped, there is a Fabric script that will restart
it for you. It will only restart if it detects the harvesting process is no longer
running, so is safe to run immediately if you suspect the process has crashed:

```bash
$ fab aws_production class:ckan ckan.restart_harvester
```

### CKAN publisher on Staging environment responds with Nginx 504 timeout:

Sometimes CKAN publisher on Staging environment responds with a 504 from Nginx, this is due to it timing out when connecting to the database as there are too many connections, current limit is 1000, though under normal working the number of connections should be under 100 if the system is not under load testing.

```sql
SELECT rolname, rolconnlimit FROM pg_roles WHERE rolname='ckan';`
```

#### Changing the connection limit

The connection limit can be updated, but should not exceed the hard limit which is around 3000.

```sql
ALTER USER ckan WITH CONNECTION LIMIT 1001;
```

#### Trying to log on to the database will result in this error:

```
FATAL:  too many connections for role "ckan"
```

#### Log in as another user:

```
sudo psql -U aws_db_admin -h postgresql-primary --no-password -d ckan_production
```

#### View the number of connections and types of queries:

```sql
SELECT COUNT(*) FROM pg_stat_activity WHERE datname = 'ckan_production';
```

#### It has been observed that during an overnight sync one of the queries caused a large number of db connections:

The following query captures part of that query and uses it to target the pid:

```sql
SELECT pid FROM pg_stat_activity WHERE datname = 'ckan_production' and query LIKE 'SELECT "user".password AS user_password%';
```

#### To cancel these queries

```sql
SELECT pg_cancel_backend(pid)
FROM pg_stat_activity
WHERE pid IN
(SELECT pid
FROM pg_stat_activity
WHERE datname = 'ckan_production' and query LIKE 'SELECT "user".password AS user_password%');
```

#### To identify long running queries

```sql
SELECT
pid,
now() - pg_stat_activity.query_start AS duration,
query,
state
FROM pg_stat_activity
WHERE
(now() - pg_stat_activity.query_start) > interval '5 minutes' AND
datname = 'ckan_production';
```

#### Cancel long running queries

This will take a few seconds to be processed

```sql
SELECT pg_cancel_backend(pid)
FROM pg_stat_activity
WHERE
(now() - pg_stat_activity.query_start) > interval '5 minutes' AND
state = 'active' AND
datname = 'ckan_production';
```

#### If cancelling does not work you can terminate the query

Note - this must be used with caution as may cause the database to restart to recover consistency.

```sql
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE
(now() - pg_stat_activity.query_start) > interval '5 minutes' AND
state = 'active' AND
datname = 'ckan_production';
```
