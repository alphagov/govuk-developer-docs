---
owner_slack: "#re-govuk"
title: Re-create an AWS mongo instance
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-05-04
review_in: 3 months
---
> Deprecation note:
> We expect this to be fixed by https://github.com/alphagov/govuk-aws/pull/1097
> If you see a similar issue, please let RE know in Slack #re-govuk.

## Symptom

Mongo log file error similar to the below text:

```
can't get local.system.replset config from self or any seed (EMPTYCONFIG)
```

When you access the mongo shell and execute `rs.status()`, you can only see
your instance and no other members of the cluster.

## Prognosis

There is a fault with the clustering and it might take a considerable amount of
time to identify the root cause. It might be easier to re-create the instance.

## Solution

In this example we are looking at the `integration` environment.

1. You will need the following repositories:

   - https://github.com/alphagov/govuk-aws
   - https://github.com/alphagov/govuk-aws-data
   - https://github.com/alphagov/govuk-secrets

2. It is very useful to have access to the AWS console, to observe the changes
   as they happen.

3. You can now execute a `terraform plan` to view the actual module names.

   ```bash
   $ cd govuk-aws
   $ tools/build-terraform-project.sh -c plan  -p app-mongo -s blue -d data -e integration # Please check the script to identify the keys
   ```

4. The output, will show you the components and how they are named by `terraform`.

  ```
  Initializing modules...
  - module.mongo-1
  Getting source "../../modules/aws/node_group"
  ....
  ```

5. The instance of interest to us at this point is **mongo-1**.

6. We can now execute a targeted plan to see details related to that specific
   component and make sure that we are working on the correct instance.

   ```bash
   $ tools/build-terraform-project.sh -c plan -p app-mongo -s blue -d data -e integration -- -target=module.mongo-1

   data.terraform_remote_state.infra_monitoring: Refreshing state...
   data.terraform_remote_state.infra_security_groups: Refreshing state...
   data.terraform_remote_state.infra_networking: Refreshing state...
   null_resource.user_data[0]: Refreshing state... (ID: 8732671785102119409)
   null_resource.user_data[2]: Refreshing state... (ID: 2147797089831867692)
   ...
   ```

7. Once you are really sure that you have the correct instance, you can destroy
   the instance as below.

   ```bash
   $ tools/build-terraform-project.sh -c destroy -p app-mongo -s blue -d data -e integration -- -target=module.mongo-1
   ```

8. Once the command completes execution, we can execute a `terraform apply`.
   This will recreate the deleted instance.

   ```bash
   $ tools/build-terraform-project.sh -c apply  -p app-mongo -s blue -d data -e integration # you can do a targeted apply but it is not necessary
   ```
