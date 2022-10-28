---
owner_slack: "#govuk-2ndline-tech"
title: Smokey loop tests
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

[Smokey][smokey] runs in a continuous loop in each environment.
and dumps the output of each run into a `tmp/smokey.json` file.
We have [Icinga checks] for [each Smokey feature], so that
we are alerted when some aspect of GOV.UK may be in trouble.

When a test fails, you should see a "Smokey loop for \<feature\>"
alert. The alert description should contain the reason for the
failure, so you can diagnose the problem.

## Try kicking the Nginx machines

If many of the tests are failing in an AWS environment, it may be because the Nginx services haven't registered new
boxes coming online or old ones going offline. You can try to fix this by:

SSHing into each `cache`, `draft_cache` and `monitoring` box and restarting nginx:

```bash
$ sudo service nginx reload
```

Once that is complete you can restart the smokey loop on the monitoring box:

```bash
$ sudo service smokey-loop restart
```

## Try removing stuck processes

Sometimes the processes can get stuck e.g. waiting on a network connection, but this should be rare.

```shell
sudo service smokey-loop stop

sudo pkill -f -9 smoke
sudo pkill -f -9 chrome

sudo service smokey-loop start
```

After running the above commands, you should soon see the `/tmp/smokey.json` file has been modified.

## Try a manual run of the loop

The Smokey Loop is just [a repeat run of Cucumber](https://github.com/alphagov/smokey/blob/main/tests_json_output.sh#L27), which you can do yourself.

```shell
sudo su - smokey
cd /opt/smokey

govuk_setenv smokey bundle exec cucumber ENVIRONMENT=integration --profile integration
```

You should then see the Cucumber output, with all the tests passing.

> **Beware the proxy.** If you quit the process before it completes, then it won't clean up properly. You'll need to manually find it (`ps -ef | grep browserup`) and kill it.

## Check the Smokey credentials

These tests rely on a user in [GOV.UK Signon][signon]. All Signon users have
their passphrase expire periodically. This will cause the tests to fail.

1. Log in to Signon (in all environments) using the smokey test user email address 2nd-line-support@digital.cabinet-office.gov.uk and follow the flow to reset the password. If the password has already expired you can change it in the Signon login page.
1. Access to the 2nd-line-support@digital.cabinet-office.gov.uk Google group where the reset email has been sent to.
1. Double check you can log in with the new credentials.
1. Add the new password to [govuk-secrets]. It needs to be updated in the following files:

    - [puppet_aws/hieradata/integration_credentials.yaml](https://github.com/alphagov/govuk-secrets/blob/main/puppet_aws/hieradata/integration_credentials.yaml)
    - [puppet_aws/hieradata/staging_credentials.yaml](https://github.com/alphagov/govuk-secrets/blob/main/puppet_aws/hieradata/staging_credentials.yaml)
    - [puppet_aws/hieradata/production_credentials.yaml](https://github.com/alphagov/govuk-secrets/blob/main/puppet_aws/hieradata/production_credentials.yaml)
    - [puppet_aws/hieradata/test_credentials.yaml](https://github.com/alphagov/govuk-secrets/blob/main/puppet_aws/hieradata/test_credentials.yaml)

    Follow [Encrypting a Hiera key](/manual/encrypted-hiera-data.html#encrypting-a-hiera-key) for more information and [this example PR](https://github.com/alphagov/govuk-secrets/pull/1376)
1. Commit and merge PR.
1. Rebuild the latest release for the [Deploy Puppet](https://deploy.integration.publishing.service.gov.uk/job/Deploy_Puppet) Jenkins job, which can be found in the Build History panel on the left. Do this for all environments.
1. [SSH into a machine](/manual/howto-ssh-to-machines.html#header):

    ```
    gds govuk connect ssh --environment integration monitoring
    ```

1. Run `govuk_puppet --test` to pull the new secrets into the machine
1. You can check they've been updated by running `less /etc/govuk/smokey/env.d/SIGNON_PASSWORD` which should contain the new credentials

[signon]: https://github.com/alphagov/signon
[smokey]: https://github.com/alphagov/smokey
[each Smokey feature]: https://github.com/alphagov/smokey/blob/main/docs/deployment.md#after-you-merge
[Icinga checks]: https://github.com/alphagov/govuk-puppet/blob/master/modules/monitoring/manifests/checks/smokey.pp
[a separate "Smokey" alert]: https://github.com/alphagov/govuk-puppet/blob/master/modules/icinga/manifests/config/smokey.pp
[govuk-secrets]: https://github.com/alphagov/govuk-secrets
