---
owner_slack: '#2ndline'
review_by: 2017-07-13
title: Handle encrypted hieradata
parent: "/manual.html"
layout: manual_layout
section: Deployment
---
# Handle encrypted hieradata

[Hiera](https://docs.puppetlabs.com/hiera/1/) is a key/value lookup tool
that we use for storing [Puppet](https://docs.puppetlabs.com/puppet/)
configuration data. We use [Hiera eYAML
GPG](https://github.com/sihil/hiera-eyaml-gpg) to encrypt sensitive
Hiera data.

Hiera eYAML GPG acts as a
[backend](https://docs.puppetlabs.com/hiera/1/custom_backends.html) to
Hiera; like a plugin. It enables us to encrypt Hiera data using GPG
keys. In our case, we encrypt the data using the GPG keys of all
security-cleared members of 2nd line.

Hiera eYAML GPG works by encrypting only the Hiera values rather than
encrypting a whole file. It also encrypts each Hiera value individually,
which makes for meaningful output from git-diff(1) such that it's
possible to identify exactly which Hiera key has changed in any given
Git commit.

## What Hiera data do we encrypt?

Currently, we only encrypt the data in the
credentials files found in the
[hieradata/](https://github.com/alphagov/govuk-puppet/tree/master/hieradata)
directories of the alphagov/govuk-puppet and gds/deployment repositories. These
files contain secrets such as passwords and private keys.

Only secrets for the production, staging and integration environments
are actually sensitive. The
[vagrant_credentials.yml](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/vagrant_credentials.yaml)
file, used with the [Vagrant test
VMs](https://github.com/alphagov/govuk-puppet/blob/master/Vagrantfile),
should not contain any sensitive data but can be used to test Hiera
eYAML GPG using dummy data.

There is currently no support for encrypted Hiera data using the
[development
VM](https://github.com/alphagov/govuk-puppet/tree/master/development-vm);
this is intentional for reasons of simplicity.

## Why do we encrypt Hiera data?

Before encrypted Hiera data was supported we used (and continue to use)
a separate repository,
[gds/deployment](https://github.gds/gds/deployment), to store secrets
and sensitive data in Hiera. Whereas the
[alphagov/govuk-puppet](https://github.com/alphagov/govuk-puppet) repository is
open to all developers, access to the gds/deployment repository is
restricted to a small number of staff.

Upon deploying Puppet, the gds/deployment repository is copied over the
files in the [alphagov/govuk-puppet](https://github.com/alphagov/govuk-puppet)
repository such that both sets of files are read by Puppet.

This patten enables us to restrict access to sensitive credentials while
still allowing developers to access the main Puppet repository.

There are some limitations and disadvantages of this pattern, however;

-   Sensitive data would be unencrypted on disk. Despite everyone having
    access to the gds/deployment repository using full disk encryption,
    secrets would be readable if a laptop was infected by malware or if
    a secret was accidentally commited to a public repository or copied
    accidentally to an unencrypted disk.
-   There was the possibility of secrets being sent over plaintext email
    as part of GitHub notifications if comments were made on specific
    lines of a pull request that included changes to sensitive data.
-   A vulnerability in GitHub Enterprise or an administrative
    error when setting access permissions could expose secrets.

By encrypting Hiera data using GPG; we are able to strictly define who
has access to these secrets (using GPG keys) and have assurances that
should the encrypted data be leaked or exposed, we have the additional
protection of GPG encryption which mitigates some of the scenarios
outlined above and gives us additional time to change credentials in
case of accidental exposure.

Note that there are no plans currently to merge the alphagov/govuk-puppet and
gds/deployment repositories; having them separate still provides
additional protection against accidental exposure.

## Common tasks for handling encrypted Hiera data

Hiera eYAML provides a command-line tool for viewing and editing
encrypted data.

There is a
[Rakefile](https://github.gds/gds/deployment/blob/master/puppet/Rakefile)
in the puppet/ directory of the
[gds/deployment](https://github.gds/gds/deployment) repository which
wraps the Hiera eYAML tool and helps to ensure that sensitive data is
only accessible to the intended recipients.

You must use the rake tasks to modify encrypted hieradata.

### Prerequisites

1. Pull the latest changes from the [gds/deployment](https://github.gds/gds/deployment)
   repo

2.  Next, run bundler(1) to install dependencies:

        cd puppet/
        bundle install

3.  You'll need to [create a GPG key](create-a-gpg-key.html)
    before you can access or modify encrypted Hiera data.

4.  You will need to ask someone who already has access to the
    credential file to add your GPG fingerprint to the relevant
    recipient file and re-encrypt the credential file so that you can
    access it.

    You can find your GPG fingerprint by running:

        gpg --fingerprint

    To re-encrypt the credentials, ask the person with access to run:

        bundle exec rake eyaml:recrypt[integration]

    ...where integration is the name of the environment whose
    credentials you wish to access.

Once complete, you should run git pull to obtain the re-encrypted copy.

You should now be able to use the rake(1) tasks below to access and
modify encrypted Hiera data.

> **note**
>
> If you use [ZSH](http://zsh.sourceforge.net/) as your local shell, you
> will need to either enclose the rake(1) command in single quotes or
> set the
> [noglob](http://zsh.sourceforge.net/Doc/Release/Options.html#index-NOGLOB)
> option.

### Encrypting a Hiera key

1.  Where integration is the name of the environment whose credentials
    you wish to edit, run:

        bundle exec rake eyaml:edit[integration]

    You will be asked for your GPG passphrase. If you encounter an
    error, please see the troubleshooting section below.

    The above command will open a text editor (as determined by the
    `$EDITOR` environment variable) showing the undecrypted Hiera data in
    YAML format.

    An unencrypted Hiera key and value might look like:

        password: 'thisisasecret'

2.  To encrypt the Hiera value, enclose it in square brackets prefixed
    with the string DEC::GPG and suffixed with a trailing exclamation
    mark (!).

    The above example would look as follows:

        password: DEC::GPG[thisisasecret]!

    Do not enclose it in single or double quotes as this will get
    interpreted as part of the secret.

Once you have finished, save the file and quit the editor. The changes
you made will be encrypted by Hiera eYAML. Should you encounter an
error, please see the troubleshooting section below.

> **NOTE**: When editing a Hiera key that has previously been encrypted, you will
> notice a number enclosed in parentheses after the word GPG; for
> example: DEC::GPG(1). You should not make any changes to the number as
> this is used by Hiera eYAML GPG to identify existing encrypted data.

## Managing access to encrypted Hiera data

The list of people that have access to encrypted Hiera data in stored in
'recipient' file specific to each environment (.rcp extension).

The production and integration files are stored in the [deployment
repo](https://github.gds/gds/deployment/tree/master/puppet/gpg_recipients).
There is no separate staging file, the production file is used for both
staging and production.

The .rcp file for vagrant is stored in the [puppet
repo](https://github.com/alphagov/govuk-puppet/tree/master/gpg_recipients).

Each line in a recipient file corresponds to a [GPG
fingerprint](http://en.wikipedia.org/wiki/Public_key_fingerprint) and
usually is identified by a comment after the hash (\#) symbol denoting
its owner. Each GPG key (and owner of that key) listed in the recipient
file is able to decrypt data belonging to the environment that the
recipient file pertains to.

### What to do when someone leaves

Leavers should be removed from all recipient files (see above). This is
achieved by deleting the line where the leaver's name is referenced by a
comment.

Therefore, to revoke a leaver's access from future changes to
credentials;

1.  Delete the leaver's GPG fingerprint from each of the recipient files
    for
    [integration](https://github.gds/gds/deployment/blob/master/puppet/gpg_recipients/integration_hiera_gpg.rcp),
    [production](https://github.gds/gds/deployment/blob/master/puppet/gpg_recipients/production_hiera_gpg.rcp)
    and
    [vagrant](https://github.com/alphagov/govuk-puppet/blob/master/gpg_recipients/vagrant_hiera_gpg.rcp).
    Note that there is no separate recipients file for Staging.
2.  Commit your changes and raise a pull request for review.

> **warning**
>
> Removing a GPG key from the recipient key and re-encrypting the
> credentials files does **not** mean that the leaver is no longer able
> to read the secrets it currently contains.
>
> Anyone who has previously had access to a credentials file may have
> retained a copy of the data. They are still able to decrypt the
> current copy of the credentials file and have made unencrypted copies.
>
> We must assume that, until the credentials file is re-encrypted and
> the stored credentials are reset, any secrets contained in the
> credentials file can still be read by anyone with a GPG key previously
> listed in the recipient list.

### How to (re)generate GPG keys for a new environment

The environments that we recognise are [listed in the
Rakefile](https://github.gds/gds/deployment/blob/cfcbbaeb29e28e9a7dfaf77e18b366e655ef2ef8/puppet/Rakefile#L58).

To ensure consistency, new GPG keys are generated using a template
([example](https://github.gds/gds/deployment/blob/cfcbbaeb29e28e9a7dfaf77e18b366e655ef2ef8/puppet/gpg_templates/production_hiera_gpg_template.txt)).
To generate a new key, run the following rake(1) task:

    bundle exec rake 'eyaml:gpg_create[integration]'

...where integration is the name of the environment to create the GPG
key for.

The GPG key will be saved to the [2ndline cred
store](https://github.gds/gds/deployment/tree/master/creds) in the
[gds/deployment](https://github.gds/gds/deployment) repository, or in
the `gpg` directory of the
[alphagov/govuk-puppet](https://github.com/alphagov/govuk-puppet) repository if you
are generating a key for the 'vagrant' environment'.

Follow the on-screen instructions to amend the recipient files and
ensure that the old key is removed and revoked if necessary.

You will need to re-encrypt the credentials using the new key:

    bundle exec rake eyaml:recrypt[integration]

### Configuring the Puppet Master

The GPG key, stored in the [2ndline cred
store](https://github.gds/gds/deployment/tree/master/creds) in the
[gds/deployment](https://github.gds/gds/deployment) repository, must be
installed on the Puppet Master so that encrypted Hiera data is available
to Puppet:

1.  First, mount the 2ndline cred store as per the README.
2.  In the hiera-eyaml-gpg directory in the 2ndline cred store, you will
    find a directory for each environment. Production and Staging both
    use the production directory.
3.  Copy the contents of the appropriate environment directory to the
    Puppet Master in that environment, from your local machine:

        cd ~/govuk/deployment/creds
        rsync --rsync-path="sudo rsync" 2ndline/hiera-eyaml-gpg/integration/* puppetmaster-1.management.integration:/etc/puppet/gpg/

4.  Be sure to set the correct permissions for the contents of
    \`/etc/puppet/gpg\`:

        ssh puppetmaster-1.management.integration sudo chown -R puppet: /etc/puppet/gpg
        ssh puppetmaster-1.management.integration sudo chmod -R 0700 /etc/puppet/gpg

> **warning**
>
> Please be sure not to copy the Production GPG keys to the Preview
> environment.

### Rotating GPG keys

1.  Follow the instructions in How to (re)generate GPG keys for a new
    environment\_ and raise a pull request with your changes.
2.  Deploy Puppet so that the credentials which have been re-encrypted
    with the new key during the last step are present on the
    Puppet master.
3.  Copy the new key to the Puppet master, following the steps
    in Configuring
    the Puppet Master\_.

## Troubleshooting

### Encryption fails when running the Rake task

If the Rake task to edit the encrypted credentials fails, with errors
such as:

    $ bundle exec rake eyaml:edit[integration]
    [gpg] !!! Warning: General exception decrypting GPG file
    [hiera-eyaml-core] !!! Bad file descriptor

Check that you're using GPG version 2 or above. Hiera eYAML GPG appears
to fail when using GPG version 1 with a large number of credentials.

If you see this error:

    General error

Check if any of the GPG keys in the recipients list have expired.

If you see this error:

    [hiera-eyaml-core] !!! Bad passphrase

Check that your GPG configuration is sane. Try encrypting and decrypting
some dummy text using the `gpg` command:

    echo 'foo' | gpg --armor --encrypt --recipient matt.bostock@digital.cabinet-office.gov.uk | gpg --decrypt

The `gpg` command above might give a more useful error message than the
gpgme library, which Hiera eYAML GPG uses.

If you see this error:

    [hiera-eyaml-core] !!! Decryption failed

Make sure that another PR re-encrypting the credentials was not merged
before your one. If this is the case, the credentials will need to be
re-encrypted again, making sure that your GPG key fingerprint is in the
relevant recipient files.

### Puppet fails because my it can't find a usable GPG key

When Puppet runs, you may see the following error:

    Hiera eYAML GPG encryption backend is not working; check that Puppet has a valid GPG key

This error can occur for the following reasons:

-   Puppet cannot find a GPG keyring in /etc/puppet/gpg. Note that this
    should only occur in development or test VMs **or** on the
    Puppet Master. If this is a non-Vagrant environment (e.g.
    Production), check that you have copied the GPG keys from the
    2ndline cred store to /etc/puppet/gpg; see encryptedpuppetmaster.
    Servers running puppet-agent(1), do not require a GPG key as they
    rely on the Puppet Master to provide and, when necessary, decrypt
    Hiera data.
-   The GPG key has expired, it should be renewed if possible or
    replaced with a new key.
-   The Hiera YAML files contain encrypted data for which the GPG keys
    in /etc/puppet/gpg is not listed as a recipient. Check the GPG
    recipient files and compare the fingerprint there to the fingerprint
    of the GPG keyring in /etc/puppet/gpg. You can find the fingerprint
    by executing the following command on the server:

        GNUPGHOME=/etc/puppet/gpg gpg --fingerprint

-   The shared folder configured in the
    [Vagrantfile](https://github.com/alphagov/govuk-puppet/blob/master/Vagrantfile)
    for Vagrant boxes is not being mounted correctly at /etc/puppet/gpg.
    Check the output of mount(1) and try reloading the machine using:

        vagrant reload

    You should also check that the version of VirtualBox guest additions
    you are using is current and compatible with the VirtualBox version
    you are using.

### Puppet fails because it can't find gpgme\_n

The error occurs because the Ruby load path is missing a directory
containing a shared object file belonging to the gpgme Ruby gem.

To fix this, you should destroy and re-provision your VM. For example,
for the development VM:

    vagrant destroy
    vagrant up

Alternatively, you can add the `$LOAD_PATH` to `/usr/bin/puppet` as shown
in [this
commit](https://github.com/alphagov/govuk-puppet/commit/b7743452875b1dd83fda982e28ae8e776bc3a8b8).
