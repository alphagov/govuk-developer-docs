---
owner_slack: "#datagovuk-tech"
title: Common tasks
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-04-30
review_in: 3 months
---
[publish]: apps/datagovuk_find
[find]: apps/datagovuk_find
[paas]: https://docs.cloud.service.gov.uk/#technical-documentation-for-gov-uk-paas
[paas-backup]: #populate-the-postgres-and-elasticsearch-services-on-paas
[infrastructure]: https://github.com/alphagov/datagovuk_infrastructure

## Deploy Find Data and Publish Data to production

1. Create a release on [Publish Data][publish] or [Find Data][find] via GitHub. Choose a tag in the format `v[number].[number].[number]` (e.g. `v1.2.1`). Note there is no dot between the v and first number. Make sure you use [semantic versioning](https://semver.org/) for tags.
2. Add decent notes covering what is being deployed.
3. Publish the release. This remote triggers a deployment to production by running the `deploy.sh` script. This is defined in the Travis configuration file in each repo.
4. Monitor deployment in Travis.
5. In some cases, such as when migrations have been added, the data needs to be reimported and reindexed. See the [Importing data section](#import-data-from-legacy).
6. If the data has been reindexed, [Find Data][find] probably needs to be deployed. Follow the same process by creating a git tag on [Find Data][find].

> More documentation is available at [Using Travis CI to deploy to Cloud Foundry](http://cruft.io/posts/using-travis-ci-to-deploy-to-cloud-foundry/).

## Deploy manually

> These instructions can be used both on staging and production.

### Applications (Find Data, Publish Data, Publish Data Worker)

If you have to deploy apps manually on [PaaS][paas] (e.g. if Travis or GitHub are down):

1. Use `scripts/deploy-production.sh` or `scripts/deploy-staging.sh` in the respective app repos.
2. Make sure you deploy both Publish Data and Publish Data Worker at the same time.

### Postgres

[PaaS][paas] doesn’t let users drop and recreate databases in the Postgres service. Instead, if you’d like to rebuild your database you need to use cloudfoundry commands to:

1. Unbind the old Postgres service from the apps using it (Publish Data and Publish Data Worker).
2. Delete the service.
3. Recreate the service.
4. Rebind the service to the apps and restage them.
5. Repopulate it from a [PaaS backup][paas-backup] or from a datadump file via Publish Data (see Syncing below)

### Elasticsearch

You shouldn’t normally need to re-instantiate an Elasticsearch service. [PaaS][paas] are responsible for keeping services working. However you can always do it by using cloudfoundry to:

1. Unbind the old Elasticsearch service from the apps that use it.
2. Delete the service.
3. Recreate the service.
4. Rebind the service to the apps and restage them.
5. Populate it with data from a [PaaS backup][paas-backup] or from the [Publish Data][publish] database via the `search:reindex` task in the repo.

Once set-up on [PaaS][paas] and bound to [Publish Data][publish] and [Find Data][find] everything should work. Environment variables should be provided automatically to the apps.

To repopulate the index with dataset metadata:

* From a PaaS backup: ask [PaaS support](/manual/data-gov-uk-incidents#data-loss).
* From a Legacy dataset dump: use the `search:reindex` task in [Publish Data][publish]. You can specify a batch size as an argument `search:reindex[100]`, the default is 50.


### Redis

Redis is currently the only service that isn’t run on [PaaS][paas] because PaaS currently only has experimental support for Redis. We run our own instance on one of our AWS servers.

To rebuild it from scratch, either:

* Create a new AWS instance, install package redis-server (
* In `/etc/redis/redis.conf`, set a master password and a port to run on (we use 21112), and change the address binding to 0.0.0.0 to allow connections from outside.

Then the Publish Secrets service needs to be updated to include the information needed for the [Publish Data][publish] app to access it, which is the Host IP, port, and password.

To access the existing AWS instances, ask a dev for the `aws-dd.pem` key. They should also be able to give you access to the data.gov.uk AWS account to create new instances.

Two AWS EC2 instance are used as a Redis server, for staging and production respectively.

To install a more recent version of Redis (>=4):

    sudo add-apt-repository ppa:chris-lea/redis-server
    sudo apt-get update
    sudo apt-get install redis-server

### Secrets services

Like other [PaaS][paas] services, standard cloudfoundry commands are used to unbind, delete, create and bind user-provided services. In this case it’s essential to back up the data in the services before deleting it, or get the latest version from the [datagovuk_infrastructure][infrastructure] repository. Recreating them from scratch will require that they eventually include all the variables and secrets that they make available to other apps, as well as the PGP keys of the users who are able to modify those variables.

## Import data from Legacy

While Legacy remains and publishers use it for creating and modifying datasets (including harvested), it is considered the single source of truth for datasets. While normally the data is imported every hour, it is sometimes necessary to reimport everything.

### Populate your local Postgres and Elasticsearch

Refer to the [Publish Data][publish] README.

### Populate the Postgres and Elasticsearch services on PaaS

You can ssh into the [Publish Data][publish] app service that is bound to the services in question and run the commands in the `setup.sh` script.

Alternatively [create a cf ssh tunnel](https://docs.cloud.service.gov.uk/#creating-tcp-tunnels-with-ssh) in order to proxy the services and make them available locally. Then you can run the [steps above](#populate-your-local-postgres-and-elasticsearch) with the right environment variables set (typically, hosts will be `localhost:some-port`).

If you want to populate the production Postgres and Elasticsearch databases, you need to do it in a way that avoids data temporarily unavailable:

1. Create a new Postgres service via cloudfoundry.
2. Bind it to the staging Publish Data app.
3. Run the tasks above to create, migrate, seed, and import.
4. Unbind the service and rebind it to the production Publish Data app.
5. Delete the old production Postgres service.
6. Rebuild the Elasticsearch service by running `rake search:reindex` on production. This does zero-downtime automatically.

## Change secrets and environment variables

In order to change environment variables, you just need to decrypt files in the datagovuk_repository, change them, re-encrypt and push the changes to [PaaS][paas].

### Setup

If this is the first time you need to change variables, install the following:

    brew install terraform blackbox gnupg
    mkdir -p ~/.terraform.d/providers
    cd ~/.terraform.d/providers
    curl -L -O https://github.com/orange-cloudfoundry/terraform-provider-cloudfoundry/releases/download/v0.10.0/terraform-provider-cloudfoundry_0.10_darwin_amd64
    mv terraform-provider-cloudfoundry_0.10_darwin_amd64 terraform-provider-cloudfoundry
    chmod u+x terraform-provider-cloudfoundry

* Create `~/.terraformrc` and add the following, remembering to replace `<yourname>`:

```
providers {
  cloudfoundry = "/Users/<yourname>/.terraform.d/providers/terraform-provider-cloudfoundry"
}
```

* Set the following variables:

```
export CF_USERNAME="your PaaS username"
export CF_PASSWORD="your PaaS password"
```
> Note that if your password contains exclamation marks, you'll need to escape them with `\` e.g. `export CF_PASSWORD="foo \! Bar"``

* Make sure your GPG key is in the repository, use [this guide to create a gpg key](https://docs.publishing.service.gov.uk/manual/create-a-gpg-key.html) if you don't have one. Check [blackbox-admins.txt](https://github.com/alphagov/datagovuk_infrastructure/blob/master/keyrings/live/blackbox-admins.txt). If they’re not, ask the team’s Tech Lead.

### Change variables

The encrypted file containing the variables is called `terraform.tfvars.json.gpg`. In the directory where you cloned the [datagovuk-infrastructure][infrastructure] repo:

1. Run `blackbox_decrypt_all_files`.
2. Use your text editor to add, remove or change the value of variables in `terraform.tfvars.json`
3. Run `terraform apply` to send the new values to [PaaS][paas]. The first time you run this it will ask you to do `terraform init`. This will first ask you to check the changes, then it will update the variables made available to all the PaaS apps through the `-secrets` PaaS services.
4. Save your changes and reencrypt the files: `blackbox_edit_end terraform.tfvars.json.gpg terraform.tfstate.gpg`
5. Commit your changes in a new branch: `git commit -m "GPG files updated" terraform.tfvars.json.gpg terraform.tfstate.gpg`
6. Get someone to approve the changes and merge to master.

If Terraform finds that the state of the running services are different from what is specified in the `.tf` files (for instance if an Elasticsearch service has crashed), it will recreate them from the `.tf` files when you run `terraform apply`.

To delete the decrypted files locally, run `blackbox_shred_all_files`.

To recreate the variables file `terraform.tfvars.json` from the existing variables currently on PaaS, run `scripts/terraform-backup`

### Adding or removing administrators

To remove an admin:

1. Go to the home directory of the [infrastructure][infrastructure] repo.
2. Check the email address to remove with `GPG=gpg2 blackbox_listadmins`
3. Run `GPG=gpg2 blackbox_removeadmin <email-address>`
6. Run `blackbox_decrypt_all_files`.
7. Re-encrypt the files without the old admin's GPG key: `blackbox_edit_end terraform.tfvars.json.gpg terraform.tfstate.gpg`
8. Commit the modified files `blackbox-admins.txt`, `pubring.kbx`, `terraform.tfvars.json.gpg` and `terraform.tfstate.gpg`
9. Get someone to approve the changes and merge to master.

To add an admin:

1. Go to the home directory of the [infrastructure][infrastructure] repo.
2. Ask the new admin for their public GPG key.
3. Import it in your keyring: `gpg2 --import < pubkey.asc`
4. `GPG=gpg2 blackbox_addadmin <email-address>`
5. Check with `GPG=gpg2 blackbox_listadmins`
6. Run `blackbox_decrypt_all_files`.
7. Re-encrypt the files with the new GPG key: `blackbox_edit_end terraform.tfvars.json.gpg terraform.tfstate.gpg`
8. Commit the modified files `blackbox-admins.txt`, `pubring.kbx`, `terraform.tfvars.json.gpg` and `terraform.tfstate.gpg`
9. Get someone to approve the changes and merge to master.

## Scale the application

Horizontal and vertical scaling is done manually using [PaaS commands][https://docs.cloud.service.gov.uk/#scaling].

## Put up a static error page

This is typically done when something crucial breaks and there’s no other way than sending users to a global error page until the site is repaired. This is done by changing the nginx config file on Legacy to point to a static 500 page hosted on S3.

* Back up `/etc/nginx/sites-availables/nginx.ckan.conf` in another directory and replace its contents with:

```
server {
    location / {
        rewrite .* https://s3.eu-west-2.amazonaws.com/dgu-static-error-pages/unavailable.html redirect;
    }
}
```

* Restart nginx: `sudo /etc/service/nginx restart`

## Re-importing a single dataset from CKAN

Occassionally a single dataset fails to synchronise from CKAN to Publish Data.  If you know the legacy slug, or the UUID of the dataset you can use the following commands to import it into publish.

```
cf ssh publish-data-beta-production-worker -t -c "/tmp/lifecycle/launcher /home/vcap/app bash ''"
rake import:single_legacy_dataset[UUID]
```

Make sure to replace UUID with the actual UUID or legacy slug.

## Re-importing a whole organisation's datasets

If an organisation harvests many datasets, and they fail to synchronise, you may need to reimport them all
if they fall outside the 24 hour window that is used to check for changes.  You can reimport an entire
organisations datasets if you know the short-name (slug) for the organisation

```
cf ssh publish-data-beta-production-worker -t -c "/tmp/lifecycle/launcher /home/vcap/app bash ''"
rake import:organisation_datasets[organisation-slug,true]
```

The boolean option to the command denotes whether you with to delete the existing entries first, or just fetch and update the datasets for that organisation.  Unfortunately this command is not atomic as entries are deleted from the search index and from the database, so should be used with care and only as a last resort.

## Deleting datasets

Although the general policy is not to delete datasets, datasets that are harvested can be withdrawn in the legacy system.  If they are withdrawn, then they also need to be deleted from Publish as it does not currently sync deletions. You will either need a CSV containing a list of UUIDs (or legacy slugs), or a single UUID (or legacy slug).

```
cf ssh publish-data-beta-production-worker -t -c "/tmp/lifecycle/launcher /home/vcap/app bash ''"
echo "UUID" | rake delete:datasets
cat todelete.csv | rake delete:datasets
```
