---
owner_slack: "#govuk-infrastructure"
title: Debian packaging
section: Packaging
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-01-05
review_in: 6 months
---

This page explains how we're managing our Debian packaging.

## Creating packages

In the past we've used
[alphagov/packager](https://github.com/alphagov/packager) to push builds
to [Launchpad](https://launchpad.net/~gds/+archive/govuk).

The new way we prefer to build packages is using
[fpm](https://github.com/jordansissel/fpm) in the
[alphagov/packager](https://github.com/alphagov/packager) repo.

### Launchpad

We are using [Launchpad](https://launchpad.net/~gds/+archive/govuk) as
the source of all our Debian packages. We are using
[alphagov/packager](https://github.com/alphagov/packager) which provides
an easy interface to build packages. It creates intermediate files
(.changes/.dsc) which can be uploaded to Launchpad which uses the files
to build the Debian package. The README for the repository explains how
to create packages for Launchpad.

Once a package is imported (published) from a given source (eg the Nginx
package is published from `nginx-stable-testing`) it cannot be
republished/superceded (even if deleted and published again) from a
different source on the same version number. To do so the version has to
be bumped up.

### fpm

Add an fpm recipe to packager and then use [the Jenkins
job](https://deploy.publishing.service.gov.uk/job/build_fpm_package/) to
create a Debian package. You can copy this package to the aptly machine
and then add the deb file to aptly.

## Mirroring

We are using [aptly](http://www.aptly.info) to mirror third-party
repositories. We do this for:

**Availability**: Our ability to provision new and deploy to existing machines
shouldn't be affected by the availability/uptime of another vendor/project.
This doesn't necessarily apply to Ubuntu upstream, who have a good network of
mirrors.

**Consistency**:   We should be able to use a consistent set of package
versions across all environments. New versions should be staged in
when we choose to do so. This also guards us against some vendors/projects
who remove old packages without warning.

**Bandwidth**:   This is the least important, but is good netizen practice. We
shouldn't need to go out to the internet everytime we install a package.
Especially if we're doing it 40x for all hosts in an environment. We also
shouldn't hit them with `apt-get update` every 30mins.

We will describe some common operations here and add to it as we do more
complex things. However the upstream documentation and examples are also
very good.

> **note**
>
> The commands below should be run on the machine where aptly is
> running. We publish to our preview mirror from our production aptly
> machine.

### Setting up new machine

These instructions are only to be used when setting up a new machine to
serve aptly repos.

We only manage *some* parts of aptly using Puppet, because it requires
GPG keys and passwords, and updating repositories is something that
should be done ad-hoc rather than a regular schedule.

    $ PASSWORD_STORE_DIR=~/govuk/deployment/pass/2ndline pass apt/key > apt-1.management.key

Copy the `apt-1.management.key` file and import it on the aptly machine:

    $ sudo -i gpg --import apt-1.management.key

When doing any of the `publish` actions below you will be prompted for
the password. This can be found in the same place. You will need to use
`sudo -i` for such actions, in order to reference root's GPG files.

> **warning**

> Please make sure that you use `sudo` and NOT a root shell, so that we
> have a record of the actions performed.

### Local repos

We maintain some local repos. These are typically used to manually
mirror an upstream repo where we need more than one version of a
package, and the upstream mirror removes old versions (eg Jenkins).

#### Initial setup

After setting up a `aptly::repo` resource in Puppet (do not use
`aptly repo create`) you configure it, add packages and publish it to a
prefix with:

    $ sudo -i aptly repo edit -distribution="stable" govuk-jenkins
    $ sudo -i aptly repo add govuk-jenkins /path/to/jenkins.deb
    $ sudo aptly snapshot create govuk-jenkins-$(date +%Y%m%d) from repo govuk-jenkins
    $ sudo -i aptly publish snapshot govuk-jenkins-$(date +%Y%m%d) govuk-jenkins

#### Updates

To add new packages download them, then add to the repo:

    $ sudo -i aptly repo add govuk-jenkins /path/to/jenkins_1.554.2_all.deb

To remove unused packages:

    $ sudo -i aptly repo remove govuk-jenkins 'jenkins (= 1.532.1)'

Create a new snapshot:

    $ sudo aptly snapshot create govuk-jenkins-$(date +%Y%m%d) from repo govuk-jenkins

Confirm that the package changes look as expected and that it doesn't
remove/replace a version that we are currently using:

    $ sudo aptly snapshot diff govuk-jenkins-20140101 govuk-jenkins-$(date +%Y%m%d)
      Arch   | Package     | Version in A  | Version in B
    - amd64  | jenkins     | 1.532.1       | -
    + amd64  | jenkins     | -             | 1.554.2

Publish the new snapshot:

    $ sudo -i aptly publish switch stable govuk-jenkins govuk-jenkins-$(date +%Y%m%d)

Finally, since we cache the mirror with Fastly, you'll need to purge the
content in the UI:

> 1.  Log in at <https://app.fastly.com>
> 2.  Click the 'Configure' tab along the top
> 3.  Choose the 'Production Apt' service from the dropdown
> 4.  Click 'Purge', then 'Purge All'

Note that whilst - typically - purging all is an expensive operation
(because requests will then hit origin until Fastly warms back up again,
which could take some time), in this case, the low amount, and type, of
traffic this service receives means it's safe.

### Third-party repos

#### Initial setup

After setting up a `aptly::mirror` resource in Puppet (do not use
`aptly mirror create`) you can sync and publish it to a prefix with:

    $ sudo -i aptly mirror update puppetlabs
    $ sudo aptly snapshot create puppetlabs-$(date +%Y%m%d) from mirror puppetlabs
    $ sudo -i aptly publish snapshot puppetlabs-$(date +%Y%m%d) puppetlabs

#### Updates

To pull new packages from an upstream repo, first sync:

    $ sudo -i aptly mirror update collectd

Assuming there are new packages then create a snapshot:

    $ sudo aptly snapshot create collectd-$(date +%Y%m%d) from mirror collectd

Confirm that the package changes look as expected and that it doesn't
remove/replace a version that we are currently using:

    $ sudo aptly snapshot diff collectd-20140101 collectd-20140102
      Arch   | Package                                  | Version in A                             | Version in B
    ! amd64  | collectd                                 | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1
    ! amd64  | collectd-core                            | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1
    ! amd64  | collectd-utils                           | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1
    ! amd64  | libcollectdclient-dev                    | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1
    ! amd64  | libcollectdclient1                       | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1

Publish the new snapshot:

    $ sudo -i aptly publish switch precise collectd collectd-20140102

Finally, since we cache the mirror with Fastly, you'll need to purge the
content in the UI as described above under Local repos\_.

### PPAs

We use Launchpad PPAs mostly for their good build pipeline; sandboxed
builds in well maintained environments. Even if they can be slow.

However PPAs have a restriction that you can only have one active
version of a package in a PPA at any one time, which makes it difficult
to test and promote package changes through environments. We work around
this by using snapshots.

#### Initial setup

Sync the repos created by Puppet's `aptly::mirror`. Mirrors are
distribution specific:

    $ sudo -i aptly mirror update govuk-ppa-precise
    $ sudo -i aptly mirror update govuk-ppa-trusty

Create a snapshot of each distribution (just one currently):

    $ sudo aptly snapshot create govuk-ppa-precise-$(date +%Y%m%d) from mirror govuk-ppa-precise
    $ sudo aptly snapshot create govuk-ppa-trusty-$(date +%Y%m%d) from mirror govuk-ppa-trusty

Publish each of them using environment-specific prefixes. Production and
Staging share the same prefix:

    $ sudo -i aptly publish snapshot govuk-ppa-precise-$(date +%Y%m%d) govuk/ppa/preview
    $ sudo -i aptly publish snapshot govuk-ppa-trusty-$(date +%Y%m%d) govuk/ppa/preview
    $ sudo -i aptly publish snapshot govuk-ppa-precise-$(date +%Y%m%d) govuk/ppa/production
    $ sudo -i aptly publish snapshot govuk-ppa-trusty-$(date +%Y%m%d) govuk/ppa/production

#### Updates

When you have pushed a new package to the PPA and want to try it out on
Preview, sync and create a new snapshot:

    $ sudo -i aptly mirror update govuk-ppa-precise
    $ sudo -i aptly mirror update govuk-ppa-trusty
    $ sudo aptly snapshot create govuk-ppa-precise-$(date +%Y%m%d) from mirror govuk-ppa-precise
    $ sudo aptly snapshot create govuk-ppa-trusty-$(date +%Y%m%d) from mirror govuk-ppa-trusty

Confirm that the changes look as expected:

    $ sudo aptly snapshot diff govuk-ppa-precise-YYYYMMDD govuk-ppa-precise-$(date +%Y%m%d)
    $ sudo aptly snapshot diff govuk-ppa-trusty-YYYYMMDD govuk-ppa-trusty-$(date +%Y%m%d)

Promote the snapshots to the Preview environment only:

    $ sudo -i aptly publish switch precise govuk/ppa/preview govuk-ppa-precise-$(date +%Y%m%d)
    $ sudo -i aptly publish switch trusty govuk/ppa/preview govuk-ppa-trusty-$(date +%Y%m%d)

If you're happy with the results on Preview then you can repeat the
publish step for Production (Staging uses the production mirror).

Finally, since we cache the mirror with Fastly, you'll need to purge the
content in the UI as described above under Local repos\_.

### Removing mirrors no longer in use

To remove a mirror that is no longer in use, run the following in order:

    # Remove published repository
    # Pay attention to the syntax, it's not <repo>/<distribution>
    # as per the output of `aptly publish list`.
    sudo aptly publish drop <distribution> <repo>

    # Remove snapshots
    sudo aptly snapshot list
    sudo aptly snapshot drop <repo>-<date>

    # Remove mirror
    sudo aptly mirror drop <repo>
