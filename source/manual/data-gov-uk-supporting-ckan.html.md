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
[ckanext-datagovuk]: apps/ckanext_datagovuk
[ckan deployment]: https://github.com/alphagov/datagovuk_ckan_deployment
[infrastructure]: https://github.com/alphagov/datagovuk_infrastructure
[ckandocs]: http://docs.ckan.org/en/ckan-2.7.3/maintaining/paster.html

## Environments

We currently have one environment: development.

Work is currently underway to define the integration, staging and production environments for [CKAN][ckan]. You can see
how [CKAN][ckan] fits into data.gov.uk in the [infrastructure] documentation.

## Applications

[ckanext-datagovuk] is the primary CKAN extension that is deployed as part of the [CKAN deployment][ckan deployment].
Although other extensions are used in that deployment, [ckanext-datagovuk] is the one that contains our changes
to functionality and styling.

## Deploying CKAN

TBD

## Managing CKAN

Although it is possible to complete some tasks through the user interface, such as creating organisations and
editing organisations, you will need to [create a system administrator account](#creating-a-system-administrator-account).

For commands not available via the user interface you must connect to the server to run the commands.
All of the commands to interact with ckan use a tool called `paster`. `paster` is available
with the server's `virtualenv` an environment for Python that includes all of the loaded libraries.
It should be loaded for you on connection, but if not you can activate it from the command line with:

```
. /usr/lib/venv/bin/activate
```

> Further, less commonly used, commands can be found in the [CKAN documentation][ckandocs]

### Creating a system administrator account

To create a system administrator account, you will need to choose a username (USERNAME) and be ready to enter
your email address.  Once you have you the command below (which will provide the option to create the account
if it does not already exists) you will be prompted twice for a password.

```
paster --plugin=ckan sysadmin add USERNAME email=EMAIL_ADDRESS  -c $CKAN_INI
```

Many of these commands take a path to the config file with the `-c` option, although you can instead use
`-c $CKAN_INI` which should resolve to `/etc/ckan/ckan.ini`.

### Managing users

Managing users is done with the `paster --plugin=ckan user` command. The following commands can be run
from anywhere, as long as the virtualenv is activated.

#### Listing users

```
paster --plugin=ckan user list -c $CKAN_INI
```

#### Viewing a user

```
paster --plugin=ckan user USERNAME  -c $CKAN_INI
```

#### Adding a user

If you do not supply the user's password, you will be prompted for it.  Ensure the user is given a
strong password, and ensure they change it as soon as possible.

```
paster --plugin=ckan user add USERNAME email=EMAIL_ADDRESS (password=PASSWORD)  -c $CKAN_INI
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

CKAN has two types of deletions, the default soft-delete, and a purge.  The soft delete gives the option of
undeleting a datast but the purge will remove all trace of it from the system.

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

CKAN uses Solr for its search index, and occassionally it may be necessary to interact with it
to refresh the index, or rebuild it from scratch.

Refresh the entire search index:

```
paster --plugin=ckan search-index rebuild -r -c $CKAN_INI
```

Rebuild the entire search index:

```
paster --plugin=ckan search-index rebuild -c $CKAN_INI
```

Only reindex those datasets that are not currently indexed

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

> Warning: This command will empty the redis queues

```
paster --plugin=ckanext-harvest harvester purge_queues -c $CKAN_INI
```

