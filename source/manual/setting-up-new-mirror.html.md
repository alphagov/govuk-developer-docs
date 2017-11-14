---
owner_slack: "#2ndline"
title: Set up a new mirror for GOV.UK
section: Environments
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-10-09
review_in: 6 months
---

We mirror GOV.UK on a number of providers which run independently of
each other in order to ensure availability and integrity. In this
tutorial, we will cover how to create a new mirror from scratch on a new
provider.

## vCloud organisations and vDCs

First, request the creation of a new vCloud Organisation and vDC from
the vendor. We have specific conventions regarding creation of the
vCloud organisation which holds the mirrors as detailed below; these
should be followed where at all possible.

### Naming convention

The organisation should be named "Infrastructure Services
(\$firstinitial)" where \$firstinitial refers to the first letter of the
vendor's name. For instance, on Carrenza, our organisation is called
"Infrastructure Services (C)".

### vCloud vDC

A new, blank vDC, will need to be created. The naming convention here is
dictated by the supplier's preference, however a reference to mirror
should be included where possible.

### IPv4 addressing

NAT is used in order to reduce the number of public IPv4 addresses
required to mirror content, and also to circumvent some restrictions
regarding the lack of bridging between vDC networks and vShield Edge. To
that end, you will need a minimum of two public IPv4 addresses - one for
the vShield Edge, and one for the load balancer to accept connections
on.

## Launching VMs and vApps

Once you have provisioned an organisation, you need to then walk an
existing mirror. The output of this walk can then be fed to a script
that translates the JSON provided by
[vcloud-walker](https://github.com/alphagov/vcloud-walker) into YAML.
Finally, this YAML can be supplied to vCloud launcher to create the
machines in vCloud.

Firstly, use [vcloud-walker](https://github.digital.cabinet-office.gov.uk/gds/vcloud-tools) to
walk an existing mirror. Edit the output such that the only two vApps
defined in the output are those of the mirrors, as we are not interested
in launching other entities within the vDC. Find the generate\_input.rb
script in the
[govuk-provisioning](https://github.digital.cabinet-office.gov.uk/gds/govuk-provisioning) repo,
and invoke it as follows:

``` {.sourceCode .}
ruby generate_input.rb -i {$input_filename} -o {$output_filename} -
```

> **note**
>
> You may encounter an error on the line in which each vApp and VM name
> is defined, if the VM name does not contain a hyphen in the format
> 'host-0'.

With your shiny new YAML, you can now launch the vApps with
[vcloud-launch](https://github.digital.cabinet-office.gov.uk/gds/vcloud-launch) in the usual way.

A working
[example](https://github.digital.cabinet-office.gov.uk/gds/govuk_mirror-deployment/tree/master/vcloud_box/carrenza)
is available for Carrenza; the vApp definitions are contained in
[govuk\_mirrors.yaml](https://github.digital.cabinet-office.gov.uk/gds/govuk_mirror-deployment/blob/master/vcloud_box/carrenza/govuk_mirrors.yaml)
and these can be deployed using the
[jenkins.sh](https://github.digital.cabinet-office.gov.uk/gds/govuk_mirror-deployment/blob/master/vcloud_box/carrenza/jenkins.sh)
script.

> **note**
>
> External IP addresses are only visible at the border, and therefore
> are not able to be directly allocated to individual VMs. The vShield
> Edge is aware of external IPs as it is directly connected to the
> border, however it is not able to allocate them down further. To get
> around this, you'll need to use NAT rules. If you do not use NAT, you
> may receive bad request responses from vcloud-launch.

## Network configuration

Your vDC network can be configured using the jenkins.sh bash script,
which in turn runs vcloud-net-spinner to configure load balancing, NAT
and firewall rules. An
[example](https://github.digital.cabinet-office.gov.uk/gds/govuk_mirror-deployment/tree/master/vcloud_net/carrenza)
jenkins.sh script and its accompanying configuration files is available
for Carrenza; we recommend using these as a template.

Before running jenkins.sh, ensure that you have the following files
ready (these are included in the Carrenza example):

-   interfaces.yaml
-   nat.rb
-   firewall.rb

jenkins.sh depends on the vcloud-net-spinner gem which you can install
using:

``` {.sourceCode .}
gem install vcloud-net-spinner
```

### Modifying jenkins.sh

When modifying jenkins.sh, you will need two pieces of information:

-   the Edge Gateway UUID
-   the vDC UUID

To obtain these, use [vcloud-walk](https://github.digital.cabinet-office.gov.uk/gds/vcloud-walker) to
walk the environment where the mirrors will be deployed.

#### Obtaining the edge gateway UUID

Execute:

``` {.sourceCode .}
bundle exec vcloud_walk networks
```

The gateway's UID is listed as ID in the output, and should be inserted
after the API URL in an interfaces.yaml file.

#### Obtaining the vDC UUID

``` {.sourceCode .}
bundle exec vcloud_walk vdcs
```

The vDC UUID is listed as ID in the output, and should be inserted in
the [vcloud-net-spinner](https://github.com/alphagov/vcloud-net-spinner)
command as the -U switch:

``` {.sourceCode .}
vcloud-net-spinner -u <username> -p <password> -U <edgegateway_uuid> -c <component_type> -o <org_name> -r nat.rb -i interfaces.yaml <http_api_url>
```

> **note**
>
> When modifying lb.rb, IP addresses in the load balancing pool should
> be the internal IP addresses if using NAT.
>
> In the virtual\_server declaration, use the external interface and the
> external IP address you wish to assign to the load balancer.

> **warning**
>
> Even if you do intend to restrict traffic handled by the load balancer
> to :443 (HTTPS), you must include the HTTP directive in order for the
> load balancing rules to be accepted properly.

## DNS configuration

Configure a DNS 'A' record for the hostname of each of the virtual
machines you have created. Mirrors are named per the following syntax:

``` {.sourceCode .}
mirror-X.mirror.providerY.production.govuk.service.gov.uk
```

...where X is the mirror number (starting at 0), and Y is the provider
number (again, starting at 0). Not referring to the vendor by name in
the URL is a good idea.

1.  Log in to [Dyn](https://manage.dynect.net).
2.  Choose Manage DNS along the top.
3.  Find the govuk.service.gov.uk zone, and drill down to
    the mirror.providerY... level.
4.  Add your new A record in at the correct level using the UI.

## Deploying Puppet

To configure the new VMs that you have created, you will need to deploy
the
[govuk\_mirror-puppet](https://github.com/alphagov/govuk_mirror-puppet)
repository to those machines. This is done using a Fabric script.

In the
[govuk\_mirror-deployment](https://github.digital.cabinet-office.gov.uk/gds/govuk_mirror-deployment)
repository, open fabfile.py for editing.

Find the lines below, assuming that you wish to use the development
environment, and replace the mirror{0,1}.example.com hosts with the
hostnames of the new VMs you created:

``` {.sourceCode .python}
@task
@runs_once
def development():
  env.environment = 'development'
  env.skip_bad_hosts = True
  env.hosts = [
    'mirror-0.example.com',
    'mirror-1.example.com',
  ]
```

Run:

``` {.sourceCode .}
fab -u ubuntu -p password $ENVIRONMENT deploy
```

...where \$ENVIRONMENT corresponds to the environment you just
configured in fabfile.py. If prompted for a password or passphrase,
enter ubuntu. The Puppet run should now complete on all of the hosts
specified in fabfile.py. Note that Puppet will delete the ubuntu user
during its run.

## Configuring mirror synchronisation

The GOV.UK site is crawled daily at midnight and the static content is
transferred to the mirror boxes using rsync. For more information,
please see [the govuk\_crawler module
manifests](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_crawler/manifests/init.pp).

You will need to specify the new mirror boxes you have just created in
the Puppet repository so that the govuk\_sync\_mirror script knows where
to rsync the static content to. You can specify these in hieradata by
setting govuk\_crawler::targets.

## Configure the CDN to serve from the new mirrors

Finally, you will need to configure the CDN to serve content from these
mirrors if the primary origin fails; this currently falls outside the
scope of this document.
