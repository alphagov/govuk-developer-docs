---
owner_slack: "#re-govuk"
title: Move apps between servers
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

Most frontend and backend apps on GOV.UK share a small number of servers. In some circumstances, apps may use more than their share of resources and may affect other apps on the same server. In these cases, apps can be moved to their own servers using the appropriate steps for either Carrenza or AWS.

## AWS

> **Note**
>
> You need to be at least a Power User in AWS to be able to run the following procedure. You can check by looking in the [govuk-aws-data] repository. Some IAM changes may require Administrator access, so you'll need to ask someone in the Reliability Engineering team to run these for you.

1. Add Terraform configuration ([1][aws-terraform-config-1], [2][aws-terraform-config-2], [3][aws-terraform-config-3]) to create the new servers, load balancers, security groups, DNS entries etc.
1. Add data to complement the configuration above ([1][aws-terraform-data-1], [2][aws-terraform-data-2]).
1. [Deploy][] the Terraform configuration. You need to do this three times for each environment:
  1. `infra-security-groups` project in the `govuk` stack.
  1. `app-name-of-your-app` project in the `blue` stack (replace `app-name-of-your-app` with the name you configured above).
  1. `infra-public-services` project in the `govuk` stack (only if your app is accessible directly from the public internet).

For each deployment, set the environment to one of `integration`, `staging` or `production` and run the `plan` command first to double-check the changes before running the `apply` command to make the changes.

👉 [Deploy AWS infrastructure with Terraform][deploy-aws]

## Carrenza

> **WARNING**
>
> Any new apps should be added to our AWS environment. The instructions for Carrenza
> are left for reference purposes only and will be removed in a few months.

### Create the new servers (if required)

If you're moving an app to new servers, start by creating those servers.

1. Add [vCloud configuration][govuk-provisioning] for the new servers for production and staging (you can choose any IP addresses that are not currently used as long as they use the same prefix as others in the same file).
1. Add the IP addresses for the new servers and a new Puppet node class in [govuk-puppet][].
1. Deploy puppet in staging.
1. SSH to the puppetmaster in staging and run a loop to sign SSL certificates for the new servers as they're created:

    ```bash
    $ ssh puppetmaster-1.management.staging
    $ while true; do sudo puppet cert sign --all; sleep 10; done
    ```

1. Run the [Launch VMs][launch-vms-jenkins] Jenkins job, using the [Carrenza staging username and password][carrenza-credentials], to create the new servers.
1. Once the job has completed, terminate the loop on the puppetmaster.
1. Re-run everything in production once you've checked everything works.

[govuk-provisioning]: https://github.com/alphagov/govuk-provisioning/pull/41
[govuk-puppet]: https://github.com/alphagov/govuk-puppet/pull/7294
[launch-vms-jenkins]: https://deploy.staging.publishing.service.gov.uk/job/Launch_VMs/
[carrenza-credentials]: https://github.com/alphagov/govuk-secrets/blob/master/pass/2ndline/carrenza/vcloud-staging.gpg

### Add the relevant app(s) to the new servers

Once the servers are created, they will run puppet to apply relevant configuration, but there will be no apps on them.

1. Change the [hieradata][] to add the relevant app(s) to the new servers.
1. Deploy puppet in staging.
1. To speed up the process, you can run puppet manually on the new servers to deploy the apps.
1. Change the relevant [app deployment scripts][deploy-scripts] to deploy to both the old and new servers.
1. Deploy the app(s) (they will be deployed to both the old and new server).
1. Re-run everything in production once you've checked everything works.

[hieradata]: https://github.com/alphagov/govuk-puppet/pull/7302
[deploy-scripts]: https://github.com/alphagov/govuk-app-deployment/pull/247

### Add the new servers to the load balancers

> **Note**
>
> It is important that all servers are running the same version of the app at this point.

Once you've verified that the app(s) have been deployed to all the new servers, you'll need to change the load balancers to start using the new servers as part of a managed migration from the old to the new servers.

1. Change the [hieradata][] for the load balancers to balance between both the old and new servers.
1. Deploy puppet in staging.
1. Re-run everything in production once you've checked everything works.

The app(s) will now be running on both old and new servers and the load balancers will use both sets of servers as their configuration is updated by puppet.

[hieradata]: https://github.com/alphagov/govuk-puppet/pull/7285

### Remove the old servers from the load balancers

Once all the load balancers have been updated, requests to the app(s) will be using both sets of servers, which will allow you to remove the old servers from serving the app(s).

1. Change the [hieradata][] once more to remove the old servers from the load balancers for the relevant app(s), and also to remove the app(s) from the old servers since they will no longer be serving the app(s).
1. Deploy puppet in staging.
1. Change the relevant [app deployment scripts][deploy-scripts] to deploy to only the new servers.
1. Re-run everything in production once you've checked everything works.

> **WARNING**
>
> Bundling up the removal of the old servers from the load balancers and the
> removal of the app(s) from the old servers may result in a period where the
> old servers are still part of the load balancer group but don't have the
> app(s) running. This can be mitigated by either splitting up these changes,
> or running puppet manually on the load balancers after deployment to ensure
> no further traffic is routed to the old servers.

[hieradata]: https://github.com/alphagov/govuk-puppet/pull/7310
[deploy-scripts]: https://github.com/alphagov/govuk-app-deployment/pull/250

### Clean up

Once everything is done, make some final changes to the [puppet configuration and hieradata][puppet-changes] to clean up the temporary changes you made above.

[puppet-changes]: https://github.com/alphagov/govuk-puppet/pull/7311

[govuk-aws-data]: https://github.com/alphagov/govuk-aws-data/search?utf8=✓&q=role_poweruser_user_arns
[aws-terraform-config-1]: https://github.com/alphagov/govuk-aws/pull/494
[aws-terraform-config-2]: https://github.com/alphagov/govuk-aws/pull/501
[aws-terraform-config-3]: https://github.com/alphagov/govuk-aws/pull/503/files#diff-c77caf224de69366e98d474cc9a6d473
[aws-terraform-data-1]: https://github.com/alphagov/govuk-aws-data/pull/103
[aws-terraform-data-2]: https://github.com/alphagov/govuk-aws-data/pull/104
[Deploy]: https://deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS/
[deploy-aws]: /manual/deploying-terraform.html
