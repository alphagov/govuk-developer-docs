---
owner_slack: "#govuk-2ndline-tech"
title: New instances fail to provision
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

# New instances fail to provision

Sometimes, it may happen that a new instance is not provisioned correctly.

This can happen when an `unattended reboot` reboots the instance before all the init scripts have had time to run. This issue is more likely in Staging due to `unattended reboot` checking [every
5 minutes at all hours of the day](https://github.com/alphagov/govuk-puppet/commit/fd1a291ca69bae254b4b0efacec13f4228939496) rather than between [midnight and 5am](https://github.com/alphagov/govuk-puppet/blob/e76b397c3e570ba807791befbf61758100e143d8/hieradata_aws/common.yaml#L1521) for Integration and Production.

It can also happen if the instance tries to install ESM (Extended Security Maintenance) Ubuntu packages before Puppet has run and configured a machine to be set up to install the ESM packages.

## Diagnosing the issue

SSH into the instance and run `govuk_puppet --test` to see the Puppet run output.

If you're unable to SSH into the instance, look at the `system logs` in AWS console (select the instance in EC2 console -> `Actions` -> `Monitor and troubleshoot` -> `Get system log`).

If you see `HttpError401` in the output, follow the instructions to [configure Puppet to authenticate requests to Ubuntu ESM](#configure-puppet-to-authenticate-requests-to-ubuntu-esm). Example:

```
Get:1 https://esm.ubuntu.com/ubuntu/ trusty-security/main libdpkg-perl all 1.17.5ubuntu5.8+esm1 [930 kB]
Err https://esm.ubuntu.com/ubuntu/ trusty-security/main libdpkg-perl all 1.17.5ubuntu5.8+esm1
  HttpError401
Err https://esm.ubuntu.com/ubuntu/ trusty-security/main dpkg-dev all 1.17.5ubuntu5.8+esm1
  HttpError401
E: Failed to fetch https://esm.ubuntu.com/ubuntu/pool/main/d/dpkg/libdpkg-perl_1.17.5ubuntu5.8+esm1_all.deb  HttpError401

E: Failed to fetch https://esm.ubuntu.com/ubuntu/pool/main/d/dpkg/dpkg-dev_1.17.5ubuntu5.8+esm1_all.deb  HttpError401

E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
Error: /Stage[main]/Base/Package[build-essential]/ensure: change from purged to present failed: Execution of '/usr/bin/apt-get -q -y -o DPkg::Options::=--force-confold install build-essential' returned 100: Reading package lists...
```

If instead you see errors like `dpkg was interrupted`, follow the instructions to [synchronise GOV.UK apps](#synchronise-gov-uk-apps). Example:

```sh
Error: Execution of '/usr/bin/apt-get -q -y -o DPkg::Options::=--force-confold install libxml2-dev' returned 100: E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.
Error: /Stage[main]/Base::Packages/Package[libxml2-dev]/ensure: change from absent to present failed: Execution of '/usr/bin/apt-get -q -y -o DPkg::Options::=--force-confold install libxml2-dev' returned 100: E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.
Info: Class[Nginx::Config]: Scheduling refresh of Class[Nginx::Service]
Info: Class[Nginx::Service]: Scheduling refresh of Service[nginx]
Notice: /Stage[main]/Nginx::Service/Service[nginx]: Triggered 'refresh' from 1 events
Notice: /Stage[main]/Govuk_scripts/Exec[check_boto]: Dependency Package[libxml2-dev] has failures: true
Warning: /Stage[main]/Govuk_scripts/Exec[check_boto]: Skipping because of failed dependencies
Notice: Finished catalog run in 24.56 seconds
```

If the above doesn't work, you could try [reprovisioning the machine](/manual/reprovision.html). If the issue persists, you may need to temporarily disable `unattended reboot` by setting `govuk_unattended_reboot::enabled` to `false` in [common.yaml](https://github.com/alphagov/govuk-puppet/blob/9c97f1cfe22334e472a48277f5131e0735b16a4e/hieradata_aws/common.yaml#L1166). You'll need to deploy the branch of Puppet before creating the new instances again.

## Configure Puppet to authenticate requests to Ubuntu ESM

SSH into the broken instance. Confirm that the ESM authentication is broken by running `sudo ls /etc/apt/auth.conf.d`: you should see that there is no `90ubuntu-advantage` file.

Now, SSH into an instance that _does_ work. For example, if a `service_manual_publisher_db_admin` machine is failing to provision, try SSH'ing into a `backend` machine.

Retrieve the ESM authentication credentials on the 'good' machine, by running:

```
sudo more /etc/apt/auth.conf.d/90ubuntu-advantage
```

Copy the contents of that file. Then, SSH into the broken instance (in this case, `service_manual_publisher_db_admin`) and create a `/etc/apt/auth.conf.d/90ubuntu-advantage` file, pasting the contents from the 'good' machine.

Finally, running `sudo unattended-upgrade -d` and `govuk_puppet --test` should apply the missing packages and finish provisioning the machine.

## Synchronise GOV.UK apps

Run `sudo /usr/local/bin/govuk_sync_apps` once puppet has run cleanly on the machine.
Note that the script takes some time to complete as there is a `sleep 180` in it.
