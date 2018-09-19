---
owner_slack: "#govuk-platform-health"
title: Supporting CKAN
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-09-13
review_in: 3 months
---
[ckan]: https://ckan.org
[ckanext-datagovuk]: /apps/ckanext-datagovuk.html
[ckanext-dgu]: https://github.com/datagovuk/ckanext-dgu
[ckandocs]: http://docs.ckan.org/en/ckan-2.7.3/maintaining/paster.html

## Environments

There are currently two environments for [CKAN]:

- [Live](https://data.gov.uk) — co-prod3.dh.bytemark.co.uk
- Development — co-dev1.dh.bytemark.co.uk

You can ssh on to these machines with `ssh co@<machine-name>`.

**When working on co-prod3, you must pair because we don't have a robust development environment for the current CKAN configuration.**

If you cannot `ssh` as above, arrange with 2nd line to add your public SSH key to the servers.

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

> A full guide to administering CKAN and Bytemark can be found in the [CKAN sysops document](https://docs.google.com/document/d/13U2m-f-mSy-CGeq9XplzhafdJK4Ptt6Pk4NfLWvn40k/edit?usp=sharing).
>
> Further, less commonly used, commands can be found in the [CKAN documentation][ckandocs].
>
> There is also a separate [historical document of previous admin tasks](https://docs.google.com/document/d/1V64IK9VoHU5w-xQmmmvKXF396FQViHM06iJWnRoAxzc/edit?usp=sharing)
that you may wish to consult.

### Updating CKAN extensions on Bytemark

To update a CKAN extension that has been pushed to GitHub, you will need to
navigate to it's directory on Bytemark then pull the relevant branch.

Example for `ckanext-spatial`:

```
cd /vagrant/src/ckanext-spatial
git pull
```

All the extensions live in the `/vagrant/src` directory.

> There are numerous copies of CKAN extensions in various places on the machine
> including `/vagrant/src/src` and `/home/co/ckan/src`. It's not clear why
> these exist, we're not aware of anything using them, but we're not sure.

They're installed in the virtual environment as "editable" meaning any code
changes should be reflected automatically, if this is not the case, you can
install it using:

```
/home/co/ckan/bin/pip install -e $PWD
```

If the extension is related to harvesting, you must restart both the `gather`
and `fetch` queues:

```
sudo supervisorctl restart ckan_fetch_consumer_dgu
sudo supervisorctl restart ckan_gather_consumer_dgu
```

If your change is not showing up on the website, it may be necessary to restart Apache:

```
sudo service apache2 restart
```

### Switching between legacy CKAN and Find open data

To access legacy CKAN, append `?legacy=1` to the URL.

If viewing a dataset, the final part of the path must be removed, leaving only the GUID (e.g. `https://data.gov.uk/dataset/f760008b-86d3-4bbb-89da-1dfe56101554/gh-wine-cellar-data` on Find open data can be viewed in legacy CKAN at `https://data.gov.uk/dataset/f760008b-86d3-4bbb-89da-1dfe56101554?legacy=1`).

### Accessing the CKAN API

There are times when it can be useful to access the CKAN API when debugging or resolving issues.

Note that the responses will be different depending on your access permissions.  The ID can be specified as either the GUID or the URL slug (referred to as a URL name in CKAN).

####  Listing all datasets

```
https://data.gov.uk/api/3/action/package_list
```

#### Viewing a dataset

```
https://data.gov.uk/api/3/action/pakcage_show?id=f760008b-86d3-4bbb-89da-1dfe56101554
```

#### Searching for a dataset

```
https://data.gov.uk/api/3/action/package_search?q=title:wine+cellar
```

#### Find all packages created during a specific timeframe

```
https://data.gov.uk/api/3/action/package_search?q=metadata_created:[2017-06-01T00:00:00Z%20TO%202017-06-30T00:00:00Z]
```

#### Find all packages modified during a specific timeframe

```
https://data.gov.uk/api/3/action/package_search?q=metadata_modified:[2017-06-01T00:00:00Z%20TO%202017-06-30T00:00:00Z]
```

#### List all publishers

```
https://data.gov.uk/api/3/action/organization_list
```

#### View a publisher record

```
https://data.gov.uk/api/3/action/organization_show?id=government_digital_service
```

#### View a user (e.g. to get CKAN API key for a Drupal user)

```
https://data.gov.uk/api/3/action/user_show?id=user_d484581
```

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

There may be times when a large number of datasets must be deleted.  This can be done remotely from your
machine using the CKAN API.  Your API key is required, which can be obtained from the web interface.
Put a list of dataset slugs or GUIDs in a text file, with one dataset per line, then run the following.

```
while read p; do curl --request POST --data "{\"id\": \"$p\"}" --header "Authorization: <your_api_key>" https://data.gov.uk/api/3/action/package_delete; done < list_of_ids.txt
```

After deleting or purging a dataset, it will take up to 10 minutes to update on Find.

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

Although harvesters can mostly be managed from the [user interface](https://data.gov.uk/harvest), it is
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

#### Restarting the harvest queues

If the queues stall, it may be necessary to restart one or both of the harvest
queues.

The gather jobs retrieve the identifiers of the updated datasets and create
jobs in the fetch queue.

```
sudo supervisorctl restart ckan_gather_consumer_dgu
```

The fetch job retrieve the datasets from the remote source and perform the
relevant updates in CKAN.

```
sudo supervisorctl restart ckan_fetch_consumer_dgu
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
