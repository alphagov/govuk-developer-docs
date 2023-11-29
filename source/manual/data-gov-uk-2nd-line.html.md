---
owner_slack: "#govuk-2ndline-tech"
title: Common 2nd line support tasks for data.gov.uk and CKAN
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
---
[ckan-app]: repos/ckanext-datagovuk
[ckan-api-404]: https://github.com/alphagov/govuk-puppet/blob/91471d86c0aa52aea4044835311ae9ba860281f5/modules/govuk/manifests/apps/ckan.pp#L210
[ckan-api-docs]: https://docs.ckan.org/en/2.9/api/index.html
[dgu-api-docs]: https://guidance.data.gov.uk/get_data/api_documentation/
[dgu-ckan]: https://ckan.publishing.service.gov.uk
[dgu-docs]: https://guidance.data.gov.uk
[find]: repos/datagovuk_find
[govuk-connect]: manual/howto-ssh-to-machines
[logit]: https://logit.io/a/1c6b2316-16e2-4ca5-a3df-ff18631b0e74
[logit-paas]: https://docs.cloud.service.gov.uk/#set-up-the-logit-io-log-management-service
[pagerduty]: https://govuk.pagerduty.com/
[pingdom]: /manual/pingdom
[publish]: repos/datagovuk_publish
[sentry]: https://sentry.io/govuk/

This document covers some of the requests that GOV.UK Technical 2nd Line support may receive regarding data.gov.uk and CKAN (which is the publishing application behind data.gov.uk).

[Separate documentation][dgu-docs] exists for publishers.

There's also [an architectural overview of data.gov.uk](/manual/data-gov-uk-architecture) and [a deployment guide](/manual/data-gov-uk-deployment).

[ckanext-datagovuk][ckan-app] is the primary CKAN extension behind data.gov.uk.

If you find an issue with CKAN that you believe may be a potential security
vulnerability please contact security@ckan.org rather than disclosing the
information publicly (as per their [security policy](https://github.com/ckan/ckan/security/policy)).

If you find an issue that does not appear to be a security vulnerability you
should first search the [issues of the upstream CKAN repository](https://github.com/ckan/ckan/issues) to see if it has already been reported and if there's a workaround.
If there is not an issue, considering opening a new one or - if you know how to
fix it - open a PR to resolve the problem.

## Environments

There are three environments for CKAN:

- [Production][dgu-ckan]
- [Staging](https://ckan.eks.staging.govuk.digital)
- [Integration](https://ckan.eks.integration.govuk.digital)

## Monitoring data.gov.uk

### Pingdom

[Pingdom] monitors `https://data.gov.uk` uptime and alerts [PagerDuty] when downtime is detected.

### Sentry

[Sentry] monitors application errors. The Sentry pages for each app can be found on the [Find] and [Publish] app pages.

### Log.it

Each application sends logs to [Logit]. [Publish] and [Find] use the corresponding [PaaS Service][logit-paas].
Example query: `source_host: "gds-data-gov-uk.data-gov-uk.find-data-beta" && access.response_code: 500`.

### Sidekiq ([Publish])

You can monitor the number of jobs in each queue using the following.

```
kubectl exec -it deploy/datagovuk-publish -n datagovuk -- bash
rails console
>>> Sidekiq::Queue.new.each_with_object(Hash.new(0)) {|j, h| h[j.klass] += 1 }
```

### Analytics

Traffic for data.gov.uk is recorded using Google Analytics, in specific properties.

## Logging into the publisher

You can log into [CKAN][dgu-ckan] using a shared 2nd line account. The credentials are available in [govuk-secrets](https://github.com/alphagov/govuk-secrets/tree/main/pass) under [datagovuk/ckan](https://github.com/alphagov/govuk-secrets/blob/main/pass/2ndline/datagovuk/ckan.gpg).

For commands not available via the user interface you need to [SSH onto a CKAN machine](#connecting-to-ckan-via-ssh).

## Users and publishing organisations

Publishers login using their email address. A user can be a member of one or more publishing
organisations, with either the 'Admin' or 'Editor' role for each organisation.

'Admin' users can add/remove users from their own organisation.

A 'sysadmin' has admin rights across all organisations.

### Finding a user

When logged in as a `sysadmin` you can access a [user list](https://ckan.publishing.service.gov.uk/user). This is useful where a publisher does not know their username or no longer has access to their registered email account.

### Creating a user account

There are two methods to create a new user account:

1. An organisation's 'admin' user can [follow these instructions](https://guidance.data.gov.uk/publish_and_manage_data/get_and_manage_accounts/#add-or-remove-editors-and-admins) to invite new users to create an account. This is the preferred approach, as the organisation admin is best placed to know whether the new user should be given access.
2. A 'sysadmin' user (e.g. Technical 2nd Line) can create an account for the new user. This should only be done if the organisation has no admins, and if we can verify the authenticity of the request.
  - Follow the instructions to [assign users to publishers](#assigning-users-to-publishers-setting-user-permissions) inputting the user's email address instead of their username.
  - An invite email is generated and sent to the publisher.

### Updating a user's email address

If a user has changed their email address (and so cannot log in) you can update the email address
associated with their account:

1. Login to [CKAN][dgu-ckan] as a 'sysadmin' user (see above for credentials).
2. Click the 'Publishers' button.
3. Search for the user's publishing organisation and click on it.
4. Click on the 'Manage' button.
5. Click on the 'Members' tab.
6. Click on the user's username in the list.
7. Click on the 'Manage' button.
8. Change the email address.
9. Enter the password you used to log in to CKAN in the 'Sysadmin password' field.
10. Set a new password for the user.
11. Click 'Update profile'.
12. Reply to the user to tell them that their email address has been changed, what the new password you set is and strongly advise them to change the password when they log in.

### Updating a user account name

Historical usernames with non-alphanumeric or uppercase characters are no longer valid, and so users cannot log in to change their password. Usernames can only be changed directly in the database:

1. Follow the [instructions](#accessing-the-database) to access the CKAN database.
2. Enter the following to find the user in the database `SELECT * from "user" where name = 'old-username' limit 1;`.
3. Update the username `UPDATE "user" SET name = 'new-username' WHERE name = 'old-username';`
4. Check they were updated by repeating step 2.
5. Reply to the user to tell them that their username has been changed and what it's been changed to.

### Creating a new publishing organisation

1. Login to [CKAN][dgu-ckan] as a 'sysadmin' user (see above for credentials).
2. Click the 'Publishers' button.
3. Click 'Add Publisher' and complete the form.
4. Follow the instructions in the section below to add a user as an 'admin' for the organisation (this would normally be the person making the request, so they can then add further users themselves without needing to contact support).

### Assigning users to publishers (setting user permissions)

1. Login to [CKAN][dgu-ckan] as a 'sysadmin' user (see above for credentials).
2. Click the 'Publishers' button.
3. Find the user's organisation and click on it.
3. Click the 'Manage' button.
4. Click the 'Members' tab, then the 'Add Member' button.
5. Add the user's existing account, or enter their email address to send them an invite, ensuring you select the relevant role for the user (either admin or editor).

> Users should first be asked to request addition by an admin of their organisation, if possible.  This is to reduce the burden of these requests on the 2nd line team and to ensure only those with the correct authority are added as publishers.
>
> Check the authenticity of a request before adding a user as a publisher (i.e. make sure they actually belong to the department they want to publish for, bearing in mind that some parent organisations may publish on behalf of child organisations, e.g. BEIS can publish for the Civil Nuclear Police Authority).

## Datasets

### Viewing a log of dataset activity

A log of publisher activity on a dataset is available by inserting `/activity` into the dataset's URL, such as https://ckan.publishing.service.gov.uk/dataset/activity/monthly_statistics_of_building_materials_and_components.

### Deleting (or withdrawing) a dataset

Users are not permitted to remove their own datasets. There are a [limited number of circumstances](https://guidance.data.gov.uk/publish_and_manage_data/managing_published_data/#managing-published-data) in which a dataset will be withdrawn.  This is to be done by Technical 2nd Line, following a request from the publisher.

Datasets are never hard-deleted (known as "purged" in CKAN), instead they are marked as "withdrawn" (a soft-deletion), which removes them from the public-facing site but allows them to be viewed through the CKAN publishing interface. Soft-deleted datasets can be undeleted.

> Before making any deletions, check that the person making the request actually belongs to the organisation which owns the document (or are from a superseding department, e.g. someone from BEIS could request withdrawal of a dataset published by BIS).

#### Deleting a dataset

1. Login to [CKAN][dgu-ckan] as a 'sysadmin' user (see above for credentials).
2. Navigate to the relevant dataset (use the 'Datasets' button).
3. Click the 'Manage' button.
4. Click the red 'Delete' button.
5. Once withdrawn, it will take up to 30 minutes to sync across to data.gov.uk and clear the cache.

> The 'Delete' button is not available for draft datasets. To soft-delete a draft dataset, follow the above steps, but manually change `/edit/` to `/delete/` in the URL of the 'Manage' page for the dataset.

You can bulk soft-delete datasets using [these instructions](#bulk-deleting-datasets).

### A dataset is wrong in some way

Responsibility for individual datasets lies with the publishing organisation. Unless it's clearly a data.gov.uk problem (eg a dataset page is returning an error response when it shouldn't be), users reporting a problem with a dataset should be directed to the publisher.

This is a generic response for such cases:

> Thanks for getting in touch.
>
> Individual datasets are the responsibility of the publishing organisation, rather than the data.gov.uk team. This means that you’ll need to get in touch with the publishing organisation directly to request any changes to the dataset.
>
> Contact details for each dataset are towards the bottom of the dataset page.
>
> I hope that helps. I’ll close this ticket now.

### Different number of datasets in CKAN to data.gov.uk

Determine the number of datasets in CKAN using the API:

[https://data.gov.uk/api/3/search/dataset](https://data.gov.uk/api/3/search/dataset)

Determine the number of datasets in the Publish Postgres database using the Rails console.

```
kubectl exec -it deploy/datagovuk-publish -n datagovuk -- bash
rails console
>>> Dataset.count
```

If these numbers match, but the number of datasets served on data.gov.uk is still different, identify the number of published datasets in the Postgres database:

```
kubectl exec -it deploy/datagovuk-publish -n datagovuk -- bash
rails console
>>> Dataset.published.count
```

All datasets that are available through the CKAN API will be marked as public in the Postgres database. Therefore, if you get a different number of datasets, you should mark them all as published in the Postgres database.

```
kubectl exec -it deploy/datagovuk-publish -n datagovuk -- bash
rails console
>>> Dataset.update(status: 'published')
```

A [reindex](/manual/data-gov-uk-operations.html#reindexing-find) is then needed to update the status with the Elastic instance that serves data.gov.uk.

### Datasets published in CKAN are not appearing on data.gov.uk

Check the Sidekiq queue (see [monitoring section](/manual/data-gov-uk-monitoring.html#sidekiq-publish)) to ensure the queue length is not too long.  You should not see more jobs than the number of datasets in CKAN.

If the queue is too long, you should [clear the queue](https://github.com/mperham/sidekiq/wiki/API). The next sync process will repopulate the queue with any relevant datasets that require updating.

### Accessing withdrawn content

If a user is asking for data that is no longer publicly available, e.g. a withdrawn dataset, they should email the organisation that originally published the dataset. You can find an email address for the organisation on CKAN.

## Using the CKAN api

It can be useful to access the [CKAN API][ckan-api-docs] when debugging or resolving issues. Note that the responses may be different depending on your access permissions.

Where relevant, the number of results returned defaults to 10. Use a rows parameter to change this:

```
https://data.gov.uk/api/action/package_search?fq=organization%3Acabinet-office&rows=200
```

Queries can use the package ID or name (the slug):

```
https://data.gov.uk/api/3/action/package_search?q=id:1e465255-7c45-4860-bf4b-991c151d4ce7
returns the same as
https://data.gov.uk/api/3/action/package_search?q=name:population-of-england-and-wales-by-ethnicity
```

There's some [API documentation][dgu-api-docs] aimed at general users of data.gov.uk. Here are some more complex examples of using the API:

```
# Retrieve full details about a package (dataset)
 https://data.gov.uk/api/3/action/package_search?q=name:population-of-england-and-wales-by-ethnicity

# Find all packages created during a specific timeframe
 https://data.gov.uk/api/3/action/package_search?q=metadata_created:[2021-06-01T00:00:00Z%20TO%202021-06-30T00:00:00Z]

# Find all packages modified during a specific timeframe
 https://data.gov.uk/api/3/action/package_search?q=metadata_modified:[2021-06-01T00:00:00Z%20TO%202021-06-30T00:00:00Z]

# Count all packages and list a sample
 https://data.gov.uk/api/3/search/dataset?fl=id,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20dataset_type:dataset

# Count harvested packages and list a sample
 https://data.gov.uk/api/3/search/dataset?fl=id,state,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20extras_harvest_object_id:[""%20TO%20*]%20and%20dataset_type:dataset

# Count manually published packages and list a sample
 https://data.gov.uk/api/3/search/dataset?fl=id,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20-extras_harvest_object_id:*%20and%20dataset_type:dataset

# Count packages harvested in last 7 days and list a sample
 https://ckan.publishing.service.gov.uk/api/search/dataset?fl=id,state,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20extras_harvest_object_id:[%22%22%20TO%20*]%20and%20dataset_type:dataset%20and%20metadata_modified:[NOW-7DAY/DAY%20TO%20NOW]&limit=20

# Count packages manually published in the last 7 days and list a sample
 https://data.gov.uk/api/3/search/dataset?fl=id,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id&q=state:active%20and%20-extras_harvest_object_id:*%20and%20dataset_type:dataset%20and%20metadata_modified:[NOW-7DAY/DAY%20TO%20NOW]

# Count packages from Daily harvest sources and list a sample
 https://data.gov.uk/api/3/search/dataset?fl=id,metadata_modified,dataset_type,name,title,extras_guid,extras_harvest_source_title,extras_harvest_object_id,extras_frequency-of-update&q=state:active%20and%20extras_harvest_object_id:%5B%22%22%20TO%20*%5D%20and%20frequency-of-update:daily%20and%20dataset_type:dataset

# List all publishers
 https://data.gov.uk/api/3/action/organization_list

# View a publisher record
 https://data.gov.uk/api/3/action/organization_show?id=government-digital-service

# List datasets from a specific publisher
 https://data.gov.uk/api/3/action/package_search?q=organization:hull-city-council
```

## Organogram publishing

Organograms are files that visualise the people structure of an organisation. They're split into two files: one for senior staff (grades SCS1, SCS2 and SCS3, or equivalent) and another for junior staff (all other grades). The senior staff file is more detailed than the junior staff file, with staff names included for posts classified as grades SCS2 and SCS3.

Organograms are the only datasets on data.gov.uk where we host the data itself, rather than linking to an external resource.

The data files are hosted in a S3 bucket (named `datagovuk-integration-ckan-organogram`, `datagovuk-staging-ckan-organogram` or `datagovuk-production-ckan-organogram`, depending on the environment).

There's [guidance for users on publishing organograms](https://guidance.data.gov.uk/publish_and_manage_data/harvest_or_add_data/add_data/#publishing-organograms).

### XLS to CSV Conversion

Publishers upload their organograms as an Excel (XLS) file that contains macros.  A script converts these to the two CSV files (junior staff and senior staff).

> Publishers **must** select the correct 'Schema Vocabulary' for their organogram dataset (i.e. one of the two 'organisation structure' values) in order for the upload option to become available and for the conversion script to run.

### Dataset Analytics requests

If a user requests analytics for datasets, we can provide them with access to an analytics dashboard. Assign tickets like this to the `3rd Line--GOV.UK Product Requests` Zendesk queue.

## Connecting to CKAN via kubectl exec

For commands not available via the user interface you must exec onto a CKAN pod:

```
kubectl exec -it deploy/ckan-ckan -n datagovuk -- bash
```

Most of the commands to interact with CKAN use the `ckan` CLI.

Once connected to the `ckan` pod, the commands can be run using the `ckan` CLI, a list of them can be discovered:

```
ckan [COMMAND]
```

If you need to view the CKAN configuration it is located at `/config/production.ini` which has been set to the `CKAN_INI` environment variable.

### Initialising the database

There may be times when you need to start with an empty database (e.g. on integration).
The following commands will create the relevant schema for core CKAN and the harvesting
extension on integration.

```
ckan db init
ckan harvester initdb
```

### Accessing the database

To access the CKAN database to run queries on the `ckan_db_admin` machine:

Get the password for `aws_db_admin`: `sudo cat /root/.pgpass`

Supply the password when prompted: `psql -U aws_db_admin -h ckan-postgres -p 5432 ckan_production`

### Creating a system administrator account

```
ckan sysadmin add USERNAME email=EMAIL_ADDRESS
```

You'll be prompted twice for a password.

### Removing a system administrator account

```
ckan sysadmin remove USERNAME
```

### Listing users

```
ckan user list
```

### Viewing a user

```
ckan user show USERNAME
```

### Adding a user

```
ckan user add USERNAME email=EMAIL_ADDRESS
```

### Removing a user

```
ckan user remove USERNAME
```

### Changing a user's password

```
ckan user setpass USERNAME
```

### Changing a publisher (organisation) name

Change the name in the CKAN UI then reindex that publisher:

```
ckan search-index rebuild [PUBLISHER]
```

### Purging a dataset

Where commands mention DATASET_NAME, this should either be the slug for the dataset, or the
UUID.

```
ckan dataset purge DATASET_NAME
```

### Bulk deleting datasets

This needs to be done on the CKAN machine, since [the deletion API is protected from external access][ckan-api-404]. Your API key is required, which can be obtained from your user profile in the CKAN web interface. Put a list of dataset slugs or GUIDs in a text file, with one dataset per line, then run the following.

```
while read p; do curl --request POST --data "{\"id\": \"$p\"}" --header "Authorization: <your_api_key>" http://localhost:<ckan_port>/api/3/action/package_delete; done < list_of_ids.txt
```

After deleting or purging a dataset, it will take up to 10 minutes to update on data.gov.uk, due to the sync process.

### Exporting a list of datasets to CSV

You can get a list all datasets (including those which have been soft-deleted) for an organisation by exporting a CSV from the database.

1. Find the id of the organisation you want via an API call, eg:

```
https://data.gov.uk/api/3/action/organization_show?id=environment-agency
```

2. Follow the [instructions to access the database](#accessing-the-database)
3. This query will list all datasets for the Environment Agency, with the number of records for each, and export the result to a CSV file.

```
\copy (SELECT package.name, package.title, package.url, package.state, COUNT(resource.package_id) as num_resources FROM package LEFT JOIN resource ON (resource.package_id = package.id) WHERE package.owner_org='11c51f05-a8bf-4f58-9b95-7ab55f9546d7' GROUP BY package.id) to 'output.csv' csv header;
```

4. You can then use scp-pull from the govuk-connect tool to download the file.

### Rebuilding the search index

CKAN uses Solr for its search index, and occasionally you may need to refresh the index, or rebuild it from scratch.

Refresh the entire search index (this adds/removes datasets, but does not clear the index first):

```
ckan search-index rebuild -r
```

Rebuild the entire search index (this deletes the index before re-indexing begins):

```
ckan search-index rebuild
```

> Rebuilding the entire search index immediately removes all records from the search before re-indexing begins. No datasets will be served from the `package_search` API endpoint until the re-index has completed. This command should therefore only be used as a last resort since it will cause the sync process to assume there is no data for a period of time.

Only reindex those packages that are not currently indexed:

```
ckan search-index -o rebuild
```

## Harvesting

Harvesting is where data is automatically imported to data.gov.uk without a publisher having to manually enter it via the web interface. This can be set to run automatically at specified periods, or run manually on-demand.

Although harvesters can mostly be managed from the [user interface](https://data.gov.uk/harvest), it can be easier to perform these tasks from the command line.

### Listing current harvest jobs

This returns a list of currently running jobs, including the JOB_ID needed to cancel jobs.

```
ckan harvester jobs
```

It may be faster to run a SQL query to get the ID of a specific harvest job.
You can do this by running the command from [Accessing the database](#accessing-the-database)
and passing a `-c` argument:

```
<psql_ckan_production_command> -c "SELECT id FROM harvest_source WHERE name = '[NAME]'"
```

### Finding the harvest source of a dataset

The harvest source of a dataset can be found using the CKAN API, using the dataset's slug:

```
https://ckan.publishing.service.gov.uk/api/3/action/package_show?id=<slug>
```

In the response there should be `harvest_source_id` and `harvest_source_title` fields.

### Getting the status of a harvester

1. Login to [CKAN][dgu-ckan] as a 'sysadmin' user (see above for credentials).
2. Click the 'Harvest' button and find the relevant harvester.
3. You will see a list of the datasets imported by this harvest source.
4. Click the 'Admin' button to get the status.
5. A summary of the current status will be shown.  Individual runs (and any error messages) can be accessed from the 'Jobs' tab.

### Restart a harvest job

1. Follow the steps to [get the status of a harvester](#getting-the-status-of-a-harvester).
2. If the harvester is currently running, click the 'Stop' button. Once it's stopped, or if it's not currently running, click the 'Reharvest' button. You'll know if the harvester is running because the 'Reharvest' button will be disabled.

If the harvest job is hanging and the 'Stop' button is not responding, you'll have to log on to the `ckan` machine to restart it:

1. Exec into the ckan pod as above
1. Run the harvest job manually - `ckan harvester run-test <harvest source>`
  - where `harvest source` is from the url of the harvest source page, e.g. `defra-metadata-catalogue-harvest`

### Cancelling a harvest job

1. Follow the steps to [get the status of a harvester](#getting-the-status-of-a-harvester).
1. Click the 'Stop' button to stop it.

Sometimes a harvest job can get stuck and not complete, and can't be cancelled through the UI.
You can get the `JOB_ID` from the harvest dashboard under "Last Harvest Job" (or from [Listing current harvest jobs](#listing-current-harvest-jobs)).

Cancel the job by running:

```
ckan harvester job-abort JOB_ID
```

This can also be done by running SQL:

```
<psql_ckan_production_command> -c "UPDATE harvest_job SET finished = NOW(), status = 'Finished' WHERE source_id = '[UUID]' AND NOT status = 'Finished';"
```

### Purging all currently queued tasks

If there's a schedule clash and the system is too busy, it may be necessary to purge the queues used in the various stages of harvesting.

> **WARNING**
>
> This command will empty the Redis queues

```
ckan harvester purge-queues
```

### Restarting the harvest service

The harvesting process runs as single pod. If the harvesting process crashes, the pod will terminate and a new pod should automatically
be started. If the pod continues to crash you will probably need to look at the pod to investigate what is going on, it could be something like it is using an incorrect image or not connecting to the solr service.

```bash
$ kubectl describe pod deploy/ckan-ckan -n datagovuk
```

You can also check whether the process is still running by checking the logs on the `ckan-gather` and `ckan-fetch` pods:

```bash
$ kubectl logs deploy/ckan-gather -n datagovuk
$ kubectl logs deploy/ckan-fetch -n datagovuk
```

Or you can check that the pods are all showing as `running`:

```bash
$ kubectl get pods -n datagovuk | grep -E "ckan-gather|ckan-fetch"
```

If any of the pods are not showing as `Running`, you may need to investigate why they are not Running. It is best to use the `kubectl describe` command to give you an idea as to the cause of the error:

```bash
$ kubectl describe pod deploy/ckan-gather -n datagovuk"
```

This will give you some information on the health of the pod, one reason for a pod to fail is because it is not picking up the latest image in which case you can check that the relevant image has been pushed up by visiting these pages:

CKAN - https://github.com/alphagov/ckanext-datagovuk/pkgs/container/ckan
PYCSW - https://github.com/alphagov/ckanext-datagovuk/pkgs/container/pycsw
Solr - https://github.com/alphagov/ckanext-datagovuk/pkgs/container/solr

'Gather' jobs retrieve the identifiers of the updated datasets and create jobs
in the fetch queue. To restart a failing pod just delete it:

```bash
$ kubectl delete pod deploy/ckan-gather -n datagovuk
```

'Fetch' jobs retrieve the datasets from the remote source and perform the relevant
updates in CKAN. To restart a failing pod just delete it:

```bash
$ kubectl delete pod deploy/ckan-fetch -n datagovuk
```

### Managing cronjob pods

There are a number of cronjob pods which run periodically, you can give the list of cronjob pods using this command:

```bash
$ kubectl get cronjobs -n datagovuk
```

Sometimes they will get into a state where they are hanging. If this happens check their health by running a `kubectl describe`:

```bash
$ kubectl describe cronjob/ckan-harvester-run -n datagovuk
```

When running a `kubectl get pods -n datagovuk` command to view all running pods you will be able to see all completed and running pods. If there are a number of running cronjob pods they might be hanging due to things like a failure to pull the image. In this case you should delete the cronjob so that it gets redeployed rather than remove the pod as this will simply recreate the pod and not clear up the hanging pods.

```bash
$ kubectl delete cronjob ckan-harvester-run -n datagovuk
```

### The `csw` endpoint

The `csw` endpoint is available at <https://data.gov.uk/csw> which redirects to
 <https://ckan.publishing.service.gov.uk/csw>.

#### `csw` endpoint unavailable

If it is not showing xml with an error `Missing keyword: service` you can check
that the `pycsw` pod is running:

```bash
$ kubectl get pods -n datagovuk | grep pycsw
```

If no running pods are found then you can start investigating why by running this command:

```bash
$ kubectl describe deploy/ckan-pycsw -n datagovuk
```

Delete the `pycsw` pod if it is not clear why it is failing as this can sometimes help it restart successfully.

It is worth checking the `pycsw` logs to investigate why it failed:

```bash
$ kubectl logs deploy/ckan-pycsw -n datagovuk
```

You can get a summary of `csw` records available from this url <https://ckan.publishing.service.gov.uk/csw?service=CSW&version=2.0.2&request=GetRecords&typenames=csw:Record&elementsetname=brief>

#### Syncing the `csw` records with `ckan` datasets

Normally the sync between `csw` and `ckan` will start at 6am each day, but in
case it should fail or if the sync needs to happen sooner you can manually
trigger the sync after Solr has been reindexed.

```sh
$ ckan ckan-pycsw load -p /config/pycsw.cfg -u http://ckan-ckan:5000
```

## Map previews

Map previews on data.gov.uk have been deprecated. Map preview links are no longer available and existing map preview pages will have a note about them being deprecated.

The Ordanance Survey API that sat behind this service was turned off. We also conducted an audit of the use of map previews, which showed that less than 1% of requests were to map preview datasets and of the 6% of map preview datasets available on DGU, only 2% were working as expected.

## Register a brownfield dataset

See the [supporting manual](https://docs.google.com/document/d/1SxzN9Ihat75TXo-fMwFqW_qBS-bPKHRs-a-tAO-qA1c/edit?usp=sharing).

## CKAN on Staging environment responds with Nginx 504 timeout:

CKAN on the Staging environment can sometime respond with a 504 error, due to it timing out when connecting to the database as there are too many connections. The current limit is 1000, usually the number of connections should be under 100.

```sql
SELECT rolname, rolconnlimit FROM pg_roles WHERE rolname='ckan';
```

### Changing the connection limit

The connection limit can be updated, but should not exceed the hard limit of around 3000.

```sql
ALTER USER ckan WITH CONNECTION LIMIT 1001;
```

### Trying to log on to the database will result in this error:

```
FATAL:  too many connections for role "ckan"
```

### View the number of connections and types of queries:

```sql
SELECT COUNT(*) FROM pg_stat_activity WHERE datname = 'ckan_production';
```

In the past, during an overnight sync one of the queries has been found to cause a large number of db connections. This captures part of that query and uses it to target the pid:

```sql
SELECT pid FROM pg_stat_activity WHERE datname = 'ckan_production' and query LIKE 'SELECT "user".password AS user_password%';
```

### Cancelling these queries

```sql
SELECT pg_cancel_backend(pid)
FROM pg_stat_activity
WHERE pid IN
(SELECT pid
FROM pg_stat_activity
WHERE datname = 'ckan_production' and query LIKE 'SELECT "user".password AS user_password%');
```

### Identifying long running queries

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

### Cancelling long running queries

This will take a few seconds to be processed

```sql
SELECT pg_cancel_backend(pid)
FROM pg_stat_activity
WHERE
(now() - pg_stat_activity.query_start) > interval '5 minutes' AND
state = 'active' AND
datname = 'ckan_production';
```

If cancelling does not work you can terminate the query. This must be used with
caution as it may cause the database to restart to recover consistency.

```sql
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE
(now() - pg_stat_activity.query_start) > interval '5 minutes' AND
state = 'active' AND
datname = 'ckan_production';
```
