---
owner_slack: "#re-govuk"
title: Manage Debian packages
section: Packaging
layout: manual_layout
parent: "/manual.html"
---

This page explains how we manage our Debian packaging.

## Considerations before creating or importing a package

Due to limited availability of up-to-date packages in long term support (LTS)
distributions, requirements of software may make installation of a package
outside of the distribution infrastructure (currently Ubuntu "Trusty" 14.04
LTS/Extended Security Maintenance) necessary.

GDS developers may also choose to use the Debian packaging system as a means to
distribute and maintain their locally developed software.

As always when considering the addition of new software, the first question has to be:
**"Is this really necessary?"**

Adding a package should be motivated by
security or architecture requirements and aim to minimise unnecessary
dependencies.

Additional guidance can be found in the [GDS way](https://gds-way.cloudapps.digital/standards/tracking-dependencies.html#dependency-management-tools)
as well as the [service manual](https://www.gov.uk/service-manual/technology/managing-software-dependencies#how-to-work-with-third-party-code).

If you are satisfied that adding a local or third party package via aptly is the
optimal solution, there are a number of ways packages may be sourced and added,
all carrying different advantages and disadvantages as well as security and
maintenance implications.

### Creating and maintaining packages locally

See section [Creating Packages](#creating-packages) for details on implementation.

- Creating local packages allows for the greatest flexibility with respect to
  installation, default configuration and fullfilment of requirements.

- Locally developed bug-fixes can be included and distributed independent of
  distribution services.

- Distribution bug-fixes and updates are not available and the package has to
  be actively maintained by GOV.UK.

- To minimise technical debt on future maintenance of packages, locally created
  packages should only be considered if there is no reliable and secure third
  party option available.

### Mirroring packages maintained by a third party

See section [Mirroring](#mirroring), in particular [Third-party Repos](#third-party-repos)
for details on implementation.

- If considering the use of a package created by a third party, the
  trustworthiness of said party is critical.

- General Debian packages explicitly labelled as suitable for Ubuntu Trusty,
  such as [Ubuntu packages provided by PostgreSQL](https://www.postgresql.org/download/linux/ubuntu/)
  or [PPA packages by LibreOffice](https://launchpad.net/~libreoffice/+archive/ubuntu/ppa)
  can be considered safe.

- With regard to packages provided by private contributors and/or smaller companies,
  both the maturity of the software and trust for the source need to be evaluated.
  Comments on maturity as well as the number of users of a package may be an
  indicator of its suitability for use in production.

- Development activity and update frequency are additional factors to consider.

- When in doubt about the trustworthiness or stability of a third party package,
  this option should be disregarded in favour of other solutions not
  compromising on reliability and security.

### Mirroring or importing .deb packages created for other distributions (e.g. Debian, Linux Mint, etc)

See section [Creating Packages](#creating-packages) for details on implementation.

- If great care is taken, it may be possible to make use of a software version
  which has been packaged for another Linux distribution, e.g. Debian.

- Despite Ubuntu being based on Debian experimental, **no Debian repository should ever
  be directly mirrored and made available through aptly to a Ubuntu system** _ever_.
  There will be severe complications including failing or erroneous package upgrades,
  broken dependencies and likely complete system failure.

- The safest way to use packages of other distributions is to use source packages. See
  the note in [Third-party Repos](#third-party-repos) for an idea of how to use them.

- Please note that resolution of building dependencies in source packages may not be possible or
  require significant work.

- The advantage of using source packages is that it ensures all library requirements of
  the created binaries are met by the original distribution (Ubuntu).

- This use of (current) Debian packages ensures updates and bug-fixes are
  readily available. However, the creation and  maintenance of the build
  environment may introduce significant overhead in itself.

## Creating packages

In the past we've used
[alphagov/packager](https://github.com/alphagov/packager) to push builds
to [Launchpad](https://launchpad.net/~gds/+archive/govuk).

The new way we prefer to build packages is using
[fpm](https://github.com/jordansissel/fpm) in the
[alphagov/packager](https://github.com/alphagov/packager) repo.

### Launchpad

We are using [Launchpad](https://launchpad.net/~gds/+archive/govuk) as
the source of all our Debian packages and
[alphagov/packager](https://github.com/alphagov/packager) which provides
an easy interface to build packages.

`alphagov/packager` creates intermediate files
(.changes/.dsc) which can be uploaded to Launchpad and which uses the files
to build the Debian package. The README for the repository explains how
to create packages for Launchpad.

Once a package is imported (published) from a given source (e.g. the Nginx
package is published from `nginx-stable-testing`) it cannot be
republished/superseded (even if deleted and published again) from a
different source on the same version number. To do so the version has to
be bumped up.

### fpm

Add an fpm recipe to packager and then use [the Jenkins
job](https://ci.integration.publishing.service.gov.uk/job/build_fpm_package/) to
create a Debian package.

#### Test the recipe

- The Jenkins job will produce a `.deb` package in the `Build Artifacts`.
- With Packager cloned to your local `govuk` folder, download your new package to
  the Packager root folder.
- Start the VM, move to the Packager project and run:

  ```
    $ sudo dpkg -i ./your_package_name.deb`
  ```

- Ensure your package has been successfully installed.

If successful, you can copy this package to the aptly machine and then add the
deb file to aptly.

## Uploading a new package

> **Note**
>
> The commands below should be run on the machine where aptly is
> running.
> The example used is for upgrading Ruby by adding a new package to the `rbenv-ruby` repository

1. Download the package to your local machine
2. Upload the package to the aptly machine:

    ```
      $ gds govuk connect scp-push -e <environment> aws/apt ~/Downloads/rbenv-ruby-2.6.1_1_amd64.deb /tmp
    ```

3. In the machine, add the package to the repo:

    ```
      $ sudo -i aptly repo add rbenv-ruby /tmp/rbenv-ruby-2.6.1_1_amd64.deb
        Loading packages...
        [+] rbenv-ruby-2.6.1_1_amd64 added
    ```

4. Create a snapshot:

    ```
      $ snapshot="rbenv-ruby-$(date +%Y%m%d)"
      $ sudo aptly snapshot create $snapshot from repo rbenv-ruby
        Snapshot rbenv-ruby-20190212 successfully created.

      $ sudo aptly snapshot show $snapshot
        Name: rbenv-ruby-20190212
        Created At: 2019-02-12 15:36:23 UTC
        Description: Snapshot from local repo [rbenv-ruby]
        Number of packages: 11
    ```

5. Check the package doesn't remove or replace a version we are currently using
   by checking the diff. You can find the previous snapshot by running `sudo aptly snapshot list`

    ```
      $ sudo aptly snapshot diff rbenv-ruby-20181023 $snapshot
        Arch   | Package          | Version in A  | Version in B
      + amd64  | rbenv-ruby-2.6.1 | -             | 1
    ```

6. Publish the new snapshot, you will be prompted to enter the passphrase for our
   APT account which is in [govuk-secrets](https://github.com/alphagov/govuk-secrets/tree/master/pass) `./edit.sh 2ndline apt/passphrase`

    ```
    $ sudo -i aptly publish switch trusty rbenv-ruby $snapshot
      Loading packages...
      Generating metadata files and linking package files...
      Finalizing metadata files...
      Publish for snapshot rbenv-ruby/trusty [amd64] publishes {main: [rbenv-ruby-20190212]: Snapshot from local repo [rbenv-ruby]} has been successfully switched to new snapshot.
    ```

7. You can check it has been published by going to [https://apt.publishing.service.gov.uk](https://apt.publishing.service.gov.uk/).
   For this example navigate to [https://apt.publishing.service.gov.uk/rbenv-ruby/pool/main/r/](https://apt.publishing.service.gov.uk/rbenv-ruby/pool/main/r/). You can also test it works by running `apt-get` in one of the integration boxes:

    ```
      $ sudo apt-get install rbenv-ruby-2.6.1
    ```

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
shouldn't need to go out to the internet every time we install a package.
Especially if we're doing it 40x for all hosts in an environment. We also
shouldn't hit them with `apt-get update` every 30mins.

We will describe some common operations here and add to it as we do more
complex things. However the upstream documentation and examples are also
very good.

> **Note**
>
> The commands below should be run on the machine where aptly is
> running. We publish to our preview mirror from our production aptly
> machine.

### Setting up new machine

These instructions are only to be used when setting up a new machine to
serve aptly repos.

We only manage *some* parts of aptly using Puppet, because it requires
GPG keys and passwords, and updating repositories is something that
should be done ad-hoc rather than on a regular schedule.

```
PASSWORD_STORE_DIR=~/govuk/deployment/pass/2ndline pass apt/key > apt-1.management.key
```

Copy the `apt-1.management.key` file and import it on the aptly machine:

```
sudo -i gpg --import apt-1.management.key
```

When doing any of the `publish` actions below you will be prompted for
the password. This can be found in the same place. You will need to use
`sudo -i` for such actions, in order to reference root's GPG files.

> **WARNING**
>
> Please make sure that you use `sudo` and NOT a root shell so we
> have a record of the actions performed.

### Local repos

We maintain some local repos. These are typically used to manually
mirror an upstream repo where we need more than one version of a
package, and the upstream mirror removes old versions (eg Jenkins).

Recently the need to upgrade packages beyond versions maintained by the
Linux distribution (Currently Ubuntu 14.04 LTS Trusty) has arisen (The shipped
Python version 2.7.6 does not support current SSL anymore).

To avoid impact of custom built versions on the existing environment we prefix
these packages with "govuk-" (as in e.g. `govuk-python_2.7.14_amd64`) and aim
for installation in /opt. For a single dependency tree a new local repository
following the naming scheme, e.g. `govuk-python` to contain packages `govuk-python`
, `govuk-python-pip`, `govuk-python-setuptools`, etc.) should be created.

#### Initial setup

After setting up a `aptly::repo` resource in Puppet (do not use
`aptly repo create`) you configure it, add packages and publish it to a
prefix with:

```
$ sudo -i aptly repo edit -distribution="stable" govuk-jenkins
$ sudo -i aptly repo add govuk-jenkins /path/to/jenkins.deb
$ sudo aptly snapshot create govuk-jenkins-$(date +%Y%m%d) from repo govuk-jenkins
$ sudo -i aptly publish snapshot govuk-jenkins-$(date +%Y%m%d) govuk-jenkins
```

#### Updates

To add new packages download them, then add to the repo:

```
$ sudo -i aptly repo add govuk-jenkins /path/to/jenkins_1.554.2_all.deb
```

To remove unused packages:

```
$ sudo -i aptly repo remove govuk-jenkins 'jenkins (= 1.532.1)'
```

Create a new snapshot:

```
$ sudo aptly snapshot create govuk-jenkins-$(date +%Y%m%d) from repo govuk-jenkins
```

Confirm that the package changes look as expected and that it doesn't
remove/replace a version that we are currently using:

```
$ sudo aptly snapshot diff govuk-jenkins-20140101 govuk-jenkins-$(date +%Y%m%d)
  Arch   | Package     | Version in A  | Version in B
- amd64  | jenkins     | 1.532.1       | -
+ amd64  | jenkins     | -             | 1.554.2
```

Publish the new snapshot:

```
$ sudo -i aptly publish switch stable govuk-jenkins govuk-jenkins-$(date +%Y%m%d)
```

Finally, since we cache the mirror with Fastly, you'll need to purge the
content in the UI:

> 1. Log in at <https://app.fastly.com>
> 2. Click the 'Configure' tab along the top
> 3. Choose the 'Production Apt' service from the dropdown
> 4. Click 'Purge', then 'Purge All'

Note that whilst - typically - purging all is an expensive operation
(because requests will then hit origin until Fastly warms back up again,
which could take some time), in this case, the low amount, and type, of
traffic this service receives means it's safe.

#### Use a local repo in an app

To make a repository available on a machine it is necessary to include a class implementing
an `apt::source` object, e.g.:

```
class govuk_python::repo (
  $apt_mirror_hostname = undef,
) {
  apt::source { 'govuk-python':
    location     => "http://${apt_mirror_hostname}/govuk-python",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => 'DA1A4A13543B466853BAF164EB9B1D8886F44E2A';
  }
}
```

After this, packages can be included in the form:

```
  package { 'govuk-python':
    ensure  => $version,
    require => Apt::Source['govuk-python'],
  }
```

### Third-party repos

> **Note**
>
> Despite Ubuntu being based on Debian experimental, no Debian repository should ever
> be directly mirrored and made available through aptly to a Ubuntu system _ever_.
> There will be severe complications including failing or erroneous package upgrades,
> broken dependencies and likely complete system failure.
>
> The safest way to attempt to use a .deb package of another distro is to include its
> source repository and compile the package yourself. After adding e.g. the Debian source
> repository `deb-src http://deb.debian.org/debian/ experimental main contrib non-free`
> and executing `apt-get update`, compilation of the desired software can be
> attempted by invoking:
>
>  ```
>  apt-get build-dep <package> # For build dependencies
>  apt-get source --compile <package> # To download source and compile package
>  ```

#### Initial setup

After setting up a `aptly::mirror` resource in Puppet (do not use
`aptly mirror create`) you can sync and publish it to a prefix with:

```
$ sudo -i aptly mirror update puppetlabs
$ sudo aptly snapshot create puppetlabs-$(date +%Y%m%d) from mirror puppetlabs
$ sudo -i aptly publish snapshot puppetlabs-$(date +%Y%m%d) puppetlabs
```

#### Updates

To pull new packages from an upstream repo, first sync:

```
$ sudo -i aptly mirror update collectd
```

Assuming there are new packages then create a snapshot:

```
$ sudo aptly snapshot create collectd-$(date +%Y%m%d) from mirror collectd
```

Confirm that the package changes look as expected and that it doesn't
remove/replace a version that we are currently using:

```
$ sudo aptly snapshot diff collectd-20140101 collectd-20140102
  Arch   | Package                                  | Version in A                             | Version in B
! amd64  | collectd                                 | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1
! amd64  | collectd-core                            | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1
! amd64  | collectd-utils                           | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1
! amd64  | libcollectdclient-dev                    | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1
! amd64  | libcollectdclient1                       | 5.3.0-ppa8~precise1                      | 5.4.0-ppa1~precise1
```

Publish the new snapshot:

```
$ sudo -i aptly publish switch precise collectd collectd-20140102
```

Finally, since we cache the mirror with Fastly, you'll need to purge the
content in the UI as described above under [Local repos](#local-repos).

For more about aptly and aptly commands please see their [documentation](https://www.aptly.info/doc/overview/).

### PPAs

We use Launchpad PPAs mostly for their good build pipeline; sand-boxed
builds in well maintained environments. Even if they can be slow.

However PPAs have a restriction that you can only have one active
version of a package in a PPA at any one time, which makes it difficult
to test and promote package changes through environments. We work around
this by using snapshots.

#### Initial setup

Sync the repos created by Puppet's `aptly::mirror`. Mirrors are
distribution specific:

```
$ sudo -i aptly mirror update govuk-ppa-precise
$ sudo -i aptly mirror update govuk-ppa-trusty
```

Create a snapshot of each distribution (just one currently):

```
$ sudo aptly snapshot create govuk-ppa-precise-$(date +%Y%m%d) from mirror govuk-ppa-precise
$ sudo aptly snapshot create govuk-ppa-trusty-$(date +%Y%m%d) from mirror govuk-ppa-trusty
```

Publish each of them using environment-specific prefixes. Production and
Staging share the same prefix:

```
$ sudo -i aptly publish snapshot govuk-ppa-precise-$(date +%Y%m%d) govuk/ppa/preview
$ sudo -i aptly publish snapshot govuk-ppa-trusty-$(date +%Y%m%d) govuk/ppa/preview
$ sudo -i aptly publish snapshot govuk-ppa-precise-$(date +%Y%m%d) govuk/ppa/production
$ sudo -i aptly publish snapshot govuk-ppa-trusty-$(date +%Y%m%d) govuk/ppa/production
```

#### Updates

When you have pushed a new package to the PPA and want to try it out on
Preview, sync and create a new snapshot:

```
$ sudo -i aptly mirror update govuk-ppa-precise
$ sudo -i aptly mirror update govuk-ppa-trusty
$ sudo aptly snapshot create govuk-ppa-precise-$(date +%Y%m%d) from mirror govuk-ppa-precise
$ sudo aptly snapshot create govuk-ppa-trusty-$(date +%Y%m%d) from mirror govuk-ppa-trusty
```

Confirm that the changes look as expected:

```
$ sudo aptly snapshot diff govuk-ppa-precise-YYYYMMDD govuk-ppa-precise-$(date +%Y%m%d)
$ sudo aptly snapshot diff govuk-ppa-trusty-YYYYMMDD govuk-ppa-trusty-$(date +%Y%m%d)
```

Promote the snapshots to the Preview environment only:

```
$ sudo -i aptly publish switch precise govuk/ppa/preview govuk-ppa-precise-$(date +%Y%m%d)
$ sudo -i aptly publish switch trusty govuk/ppa/preview govuk-ppa-trusty-$(date +%Y%m%d)
```

If you're happy with the results on Preview then you can repeat the
publish step for Production (Staging uses the production mirror).

Finally, since we cache the mirror with Fastly, you'll need to purge the
content in the UI as described above under [Local repos](#local-repos).

### Removing mirrors no longer in use

To remove a mirror that is no longer in use, run the following in order:

```
# Remove published repository
# Pay attention to the syntax, it's not <repo>/<distribution>
# as per the output of `aptly publish list`.
sudo aptly publish drop <distribution> <repo>

# Remove snapshots
sudo aptly snapshot list
sudo aptly snapshot drop <repo>-<date>

# Remove mirror
sudo aptly mirror drop <repo>
```
