---
owner_slack: "#govuk-platform-health"
title: Migrating data between CKAN instances
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-09
review_in: 6 weeks
---
[ckanext-datagovuk-github]: https://github.com/alphagov/ckanext-datagovuk

### Accessing CKAN

In order to transfer data between CKAN instances, it is required to dump the content of the old instance into JSONL format, do a conversion to the new schema, then reload into a new instance.  This can be done using the CKAN API, by installing [ckanapi](https://github.com/ckan/ckanapi) on your local machine.

For a local CKAN, you must append the path to the `ckan.ini` file:

```
ckanapi -c CKAN_INI ...
```

To administer a remote instance, you will require a sysadmin account, your username and an API key (obtained through the web interface).  Append the remote URL and API key to each ckanapi request, in place of the `-c` flag:

```
ckanapi -r URL -a API_KEY ...
```

#### Dumping data

Active data (i.e. everything that is publicly available) can be retrieved through the API.  To dump data that is not available publicly, you must use an API key belonging to a sysadmin user.

Dumping users:

```
ckanapi dump users --all -O USER_FILE.jsonl.gz -z -p 4
```

Dumping publishers:

```
ckanapi dump organizations --all -O ORGANIZATION_FILE.jsonl.gz -z -p 4
```

Dumping datasets:

```
ckanapi dump datasets --all -O DATASET_FILE.jsonl.gz -z -p 4
```

Retrieve the user data from Drupal (this is a nightly dumped file):

```
rsync -L --progress co@co-prod3.dh.bytemark.co.uk:/var/lib/ckan/ckan/dumps_with_private_data/drupal_users_table.csv.gz DRUPAL_USER_DUMP.csv.gz
```

#### Data schema migration

The data schema for the two CKAN instances may not match.  Therefore a conversion is required to allow the dump to be imported to the new CKAN installation.  Scripts are available in [ckanext-datagovuk][ckanext-datagovuk-github] to enable this.

Migrating users and publishers (this is a single step as user-publisher assignment is updated at the same time):

```
python import/migrate_users.py USER_FILE.json.gz DRUPAL_USER_DUMP.csv.gz USER_MIGRATED_FILE.jsonl.gz ORGANIZATION_FILE.jsonl.gz ORGANIZATION_MIGRATED_FILE.jsonl.gz
```

Migrating datasets:

```
python import/migrated_datasets.py -s DATASET_FILE.jsonl.gz -o DATASET_MIGRATED_FILE.jsonl.gz
```

It is also possible to trim the datasets file to include only datasets that have been modified/created since a specific time (as a ISO8601 timestamp, e.g. 2018-04-12T17:07:36.284461).  This allows for faster incremental imports:

```
python import/incremental_update.py -s DATASET_FILE.jsonl.gz -o DATASET_MIGRATED_FILE.jsonl.gz -t TIMESTAMP
```

#### Importing data

CKAN supports the bulk import of data (users, publishers and datasets) from a JSONL file representing the data to be imported.  If a record already exists (based on the UUID on the object), CKAN will perform a comparison and update the record with changes from the import file.  Data from the import file will always overwrite data in the database in the event of a conflict.

Importing users:

```
ckanapi load users -I USER_MIGRATED_FILE -p 4
```

Importing publishers:

```
ckanapi load organizations -I PUBLISHERS_MIGRATED_FILE -p 4
```

Importing datasets:

```
ckanapi load datasets -I DATASET_MIGRATED_FILE -p 4
```

Importing harvesters (this must be run on the server on which the new CKAN is installed):

```
python import/migrated_harvest_sources.py --production
```

