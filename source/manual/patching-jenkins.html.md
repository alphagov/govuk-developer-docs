---
owner_slack: "#re-govuk"
title: Patch Jenkins
parent: "/manual.html"
layout: manual_layout
section: Infrastructure
---

Jenkins should be regularly patched when possible, including all plugins.

## Upgrading plugins

SSH to the Jenkins machine and take a copy of the plugins directory:

```
tar -zcvf plugins.tgz /var/lib/jenkins/plugins
```

Disable Puppet on the host:

```
govuk_puppet -n <myname> -r "patching jenkins" --disable
```

Log in to the Jenkins UI and go to "Manage Jenkins" -> "Manage Plugins".

Select all outstanding updates and kick off the install. Wait for the downloads
to complete, install and restart the service.

Back on the machine terminal, run the following command to see the currently
installed plugins in a hieradata like format:

```
sudo jenkins-cli list-plugins |sort| awk '{ if ($NF ~ /\(.*\)/) print $1":\n  version:", "'\''" $(NF-1) "'\''"; else print $1":\n  version:", "'\''" $NF "'\''" }'
```

Update the class hieradata with the list of plugins. Check [this example](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/class/ci_master.yaml).

Use `git diff` to ensure version numbers are updated. If new plugins appear to be
present, double-check with someone else.

**Be aware that the "credentials" plugin is pulled in using the upstream Puppet
module, so ensure that this not added to hiera**

Re-enable Puppet on the machine when the PR has been merged and deployed.

## Upgrading Jenkins base

Grab the latest Debian package from the [Jenkins site](https://pkg.jenkins.io/debian-stable/).

Upload it to `apt-1.management` in Production (we only use a single apt machine
across all environments).

Run the following commands to add it to the Jenkins repo:

```
sudo -i aptly repo add govuk-jenkins /home/$USER/jenkins_2.46.1_all.deb
sudo aptly snapshot create govuk-jenkins-$(date +%Y%m%d) from repo govuk-jenkins
sudo -i aptly publish switch stable govuk-jenkins govuk-jenkins-$(date +%Y%m%d)
```

You will require the apt passphrase found in the [password store](https://github.com/alphagov/govuk-secrets/tree/master/pass).

Purge the cache for the "Production Apt" service in Fastly.

Update Puppet with the version you've just added to aptly.

### Manual test upgrade

You can manually test a new version before doing the steps outlined above to get
it officially into Puppet.

Find the latest version on the Jenkins site and set appropriately below:
<https://jenkins.io/download/>

```
export VERSION='2.46.2'
wget http://updates.jenkins-ci.org/download/war/$VERSION/jenkins.war
sudo cp /usr/share/jenkins/jenkins.war /usr/share/jenkins/jenkins.war-$(date +%F)
sudo mv jenkins.war /usr/share/jenkins/jenkins.war
sudo service jenkins restart
```

When this has completed, complete the Puppet and apt steps above. Remember to re-enable Puppet once the task is finished.
