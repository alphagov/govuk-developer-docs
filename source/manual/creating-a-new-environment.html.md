---
owner_slack: "#infrastructure"
title: Create a new environment for GOV.UK
section: Environments
layout: manual_layout
parent: "/manual.html"
last_reviewed_at: 2018-07-01
review_in: 6 months
---

> It's possible this page is out of date, but it's is still relevant if we ever need to rebuild a VMWare vCloud environment somewhere.

# Create a new environment for GOV.UK

## Manual steps to ask of the IaaS provider

Ask the IaaS provider to:

> a.  Create a vCloud Director organisation.
> b.  Provision these virtual data centres ('vDCs'):
>
> > -   GOV.UK API
> > -   GOV.UK Backend
> > -   GOV.UK Frontend
> > -   GOV.UK Licensify
> > -   GOV.UK Management
> > -   GOV.UK Redirector
> > -   GOV.UK Router
>
> c.  Provision a vShield Edge Gateway and associate it to the vDCs. The
>     edge gateway needs to be put into 'Full' mode; the default is
>     compact mode.
> d.  Allocate external IP addresses and configure a 10.0.0.0/8 subnet
>     on the vShield Edge Gateway.
> e.  Ensure that storage policies have a sufficient quota for the
>     amount of disk space required in for each vDC.
> f.  Ensure ingress access to the organisation on these TCP ports:
>
> > -   22 and 1022 (for jumpbox-2): for the [nat\_a IP
> >     address](https://github.gds/gds/govuk-provisioning/blob/69c299557f7c0600c17180e0dec05bd1765e02bc/vcloud-edge_gateway/vars/production_skyscape_vars.yaml#L29)
> > -   80 and 443 for all IP addresses
> >
> > > **note**
> > >
> > > Further restrictions on where traffic on these ports can go is
> > > handled later in the edge gateway firewall.
>
> g.  Ensure egress access from the vCloud organisation on these TCP
>     ports:
>
> > -   22
> > -   80
> > -   443
> > -   587
> > -   9418 (git)
> > -   11371
> >     ([hkp](http://en.wikipedia.org/wiki/OpenPGP_HTTP_Keyserver_Protocol))

## Creating vApp templates

"vApp templates" are machine images that are used to create virtual
machines. They are equivalent to an Amazon Machine Image (AMI).

The process for creating a vApp template is [documented in
govuk-provisioning](https://github.gds/gds/govuk-provisioning/blob/master/packer/README.md).

## Configuring the vDC networks

Internal networking is configured using
[vcloud-net\_launcher](https://github.com/gds-operations/vcloud-net_launcher).
The configuration files for networking are in
[govuk-provisioning](https://github.gds/gds/govuk-provisioning).

The input to vcloud-net-launch is a yaml file describing the networks to
launch.

1.  Start by copying the configuration from another environment
2.  Correct the following values:
    -   Edge Gateway name
    -   vDC names

3.  Run `vcloud-net-launch` with the yaml file as an argument

> **tip**
>
> Find your Skyscape API username using the link at the top-right of the
> [Portal](https://portal.skyscapecloud.com/).
>
> ![image](skyscape_api_link.png)

## Configuring edge gateways - firewalls, NAT and load balancing

Edge gateways:

1.  Firewall traffic
2.  Load balance at the transport layer (ie TCP and UDP)
3.  Translate addresses as part of Network Address Translation

Edge gateway configuration is automated; use the [vcloud-configure-edge
tool](https://github.com/gds-operations/vcloud-edge_gateway) with the
configuration checked in to
[govuk-provisioning/vcloud-edge\_gateway](https://github.gds/gds/govuk-provisioning/tree/master/vcloud-edge_gateway).
For example, to configure firewalls in the Carrenza Preview environment:

    # get an authentication token
    eval $(FOG_CREDENTIAL=foo bundle exec vcloud-login)

    FOG_CREDENTIAL=foo bundle exec vcloud-edge-configure \
      rules/firewall.yaml.mustache --template-vars vars/preview_carrenza_vars.yaml

    FOG_CREDENTIAL=foo bundle exec vcloud-logout

You will have to create a new template vars file for the new environment
but you should not have to change the firewall.yaml.mustache file unless
you are changing how firewalls are configured in all environments.

## Launching and configuring virtual machines

Note: When provisioning VMs, make sure your machine doesn't suspend
partway though. If you're using a Mac, you might need to use
[caffeinate](https://developer.apple.com/library/mac/documentation/Darwin/Reference/Manpages/man8/caffeinate.8.html)

> **note**
>
> In order to make sure we are billed for what we use, it is important
> to align the size of the machines being created with the sizes
> available from the IaaS supplier. vCloud allows unrestricted sizes,
> but in practise the vendor bills based on discrete sizes of machine.
>
> <http://www.skyscapecloud.com/what-we-do/infrastructure-as-a-service/compute/compute-service-production/#technical-specifications>
>
> Machine sizes should be aligned to the ones in use by your vendor.

### Troubleshooting VM provisioning

Should you encounter problems provisioning a VM and need to reprovision
it, see our guide &lt;reprovision&gt;. If you need to delete a VM that
you won't be recreating, you can remove it from Puppet and Icinga by
running the following command on `puppetmaster-1.management` (assuming
that has already been provisioned):

    govuk_node_clean accidental-box-1.vdc.environment

### Set up the Puppet Master

1.  Launch the Puppet Master VM:

        cd ~/govuk/govuk-provisioning

        # get an authentication token
        eval $(FOG_CREDENTIAL=foo bundle exec vcloud-login)

        FOG_CREDENTIAL=foo tools/launch_vapp.rb vcloud-launcher/environment_provider/management.yaml puppetmaster-1

        FOG_CREDENTIAL=foo bundle exec vcloud-logout

2.  Make sure you have the puppet repository checked out locally and
    have pulled the latest from the master branch.
3.  Make sure you have the deployment repository checked out locally and
    have pulled the latest from the master branch.
4.  Install ssh-copy-id if you do not have it already:

        brew install ssh-copy-id

5.  Run this script to push the Puppet code to the Puppet Master (you
    will need to pass the appropriate options to push-puppet.sh):

        cd ~/govuk/govuk-provisioning/tools
        ./push-puppet.sh -h

### Set up a deployment Jenkins

#### Provision

1.  Create any DNS records (deploy.preview.etc)
2.  Create a Jenkins machine:

        cd ~/govuk/govuk-provisioning

        # get an authentication token
        eval $(FOG_CREDENTIAL=foo bundle exec vcloud-login)

        FOG_CREDENTIAL=foo tools/launch_vapp.rb vcloud-launcher/environment_provider/management.yaml jenkins-1

        FOG_CREDENTIAL=foo bundle exec vcloud-logout

#### Configure

1.  On Github Enterprise, create a new configuration repository for
    your environment. Make sure that the
    [Bots](https://github.gds/organizations/gds/teams/3) team has access
    to to your new repository
2.  Add public half of the Jenkins user's SSH key to github.gds:

        ssh jenkins-1.management.staging 'sudo cat /var/lib/jenkins/.ssh/id_rsa.pub'

    You will need to "Fake GitHub Sign In" from the [staff tools user
    page](https://github.gds/stafftools/users).

3.  Also put that public half into the deploy user on puppetmaster-1
4.  Configure scm with details for git repo
5.  Clone the configuration repository for Jenkins:

        sudo rm -rf /var/lib/jenkins/scm-sync-configuration/checkoutConfiguration/
        git clone git@github.gds:gds/jenkins-config-p1production.git
        sudo mkdir /var/lib/jenkins/scm-sync-configuration/checkoutConfiguration
        sudo rsync -avPh ~bob/jenkins-config-p1production/ /var/lib/jenkins/scm-sync-configuration/checkoutConfiguration/
        sudo chown -R jenkins:jenkins /var/lib/jenkins/scm-sync-configuration/checkoutConfiguration/

6.  Tell scm-sync to reload from git. (in the UI "Manage Jenkins" -&gt;
    "Config System" -&gt; "Reload Config from SCM")
7.  Restart Jenkins by accessing
    `https://jenkins-url.example.com/restart`.
8.  

    Copy `jenkins@jenkins-1.management.production:.ssh/id_rsa.pub`

    :   into
        `puppetmaster-1.management.production:~deploy/.ssh/authorized_keys`

9.  Run the Jenkins job "Deploy: Puppet"

    > -   you will need to
    >     `chown -Rv deploy: /usr/share/puppet/production/releases/*`
    >     first

### Launch other virtual machines

1.  Run the "autosign loop" on the puppetmaster and keep an eye on the
    output:

        while true; do sudo puppet cert sign --all; sleep 10; done

2.  Create a vcloud-launch job on Jenkins that will run vcloud-launch
    over all of the yaml files in the `govuk-provisioning` repository

## Deploy applications

You can now use the deployment Jenkins to deploy applications. The order
of deployment matters and might have changed since this was written.
Here is the order that was used for building the Carrenza preview
environment:

> 1.  errbit
> 2.  router
> 3.  router-api
> 4.  whitehall
> 5.  publisher
> 6.  rummager
> 7.  signon
> 8.  smartanswers
> 9.  release
> 10. external\_link\_tracker
> 11. govuk\_content\_api
> 12. govuk\_need\_api
> 13. asset-manager
> 14. designprinciples
> 15. feedback
> 16. support
> 17. travel-advice-publisher
> 18. transaction-wrappers
> 19. frontend
> 20. static
> 21. govuk-delivery
> 22. transition
> 23. licencefinder
> 24. imminence
> 25. kibana
> 26. maslow
> 27. bouncer
> 28. calculators
> 29. calendars
> 30. licensify (it has separete Jenkins jobs)

## Other environment setup

### Build pipelines

Allow access to the new environment from CI. This might require firewall
changes.

While you're still setting things up, it's a good idea to create
separate, new, deployment jobs and have the old deployment jobs trigger
the new jobs after they successfully complete. This way, every
deployment goes to both environments during the switchover, but there is
no chance of breaking the build pipelines for anyone else.

### MySQL slaving

There are two MySQL clusters:

> -   "Normal" mysql
>     -   mysql-master-1
>     -   mysql-slave-1
>     -   mysql-slave-2
>     -   mysql-backup-1
> -   Whitehall mysql
>     -   whitehall-master-1
>     -   whitehall-slave-1
>     -   whitehall-slave-2
>     -   whitehall-backup-1

Both clusters need to be set up so that `slave-{1,2}` and `backup-1`
slave from the `master-1`.

To set up slaving, follow the documentation on [setting up mysql
replication](setup-mysql-replication.html) , except that you might need
to take the initial dump from a different environment. This is the case
if you are rebuilding preview.

### PostgreSQL slaving

There are two PostgreSQL clusters:

> -   "Normal" PostgreSQL
>     -   postgresql-primary-1
>     -   postgresql-standby-\[0-9\]
> -   Transition PostgreSQL
>     -   transition-postgresql-master-1
>     -   transition-postgresql-slave-\[0-9\]

To set up slaving, follow the documentation on [setting up PostgreSQL
replication](setup-postgresql-replication.html).

### Populating databases

You will need to copy them from production using the
`env-sync-and-backup` tools. There are existing Jenkins jobs for doing
this.

### Elasticsearch

Assuming Elasticsearch has been installed by Puppet, and is contactable
on :9200, then you can run the elasticsearch job in Jenkins to copy the
relevant data and indexes over.

If it turns out that this isn't the case, you can attempt to fix this
manually by using the HEAD plugin to check the indexes and aliases match
that of a known-working environment.

Failing this:

> -   download the existing Elasticsearch indexes from a known working
>     environment, and copy the files to /var/es\_dump on the new
>     environment's custer
> -   install the es\_dump\_restore Gem, at version 0.0.6 or above
> -   import the indexes using
>     `es_dump_restore restore "<http://localhost:9200/>" INDEX_NAME INDEX_FILE`

Then, ask Rummager to re-index:

> `RUMMAGER_INDEX=all bundle exec rake rummager:migrate_from_unaliased_index`
