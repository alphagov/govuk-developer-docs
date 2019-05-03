---
owner_slack: "#govuk-2ndline"
title: Handle encrypted hieradata
parent: "/manual.html"
layout: manual_layout
section: Deployment
last_reviewed_on: 2019-05-02
review_in: 6 months
---

[Hiera](https://docs.puppetlabs.com/hiera/1/) is a key-value lookup tool
that we use for storing [Puppet](https://docs.puppetlabs.com/puppet/)
configuration data. We use [Hiera eYAML
GPG](https://github.com/sihil/hiera-eyaml-gpg) to encrypt sensitive
Hiera data.

Hiera eYAML GPG acts as a
[backend](https://docs.puppetlabs.com/hiera/1/custom_backends.html) to
Hiera; like a plugin. It enables us to encrypt Hiera data using GPG
keys. In our case, we encrypt the data using the GPG keys of all
security-cleared developers on GOV.UK.

Hiera eYAML GPG only encrypts the Hiera values, rather than the whole file.
It also encrypts each Hiera value individually, so you can see which ones
changed in a git commit.

## What Hiera data do we encrypt?

Currently, we only encrypt the data in the credentials files found in the
[hieradata/](https://github.com/alphagov/govuk-puppet/tree/master/hieradata)
directories of the [alphagov/govuk-puppet](https://github.com/alphagov/govuk-puppet) and [alphagov/govuk-secrets](https://github.com/alphagov/govuk-secrets)
repositories. These files contain secrets such as passwords and private keys.

Only secrets for the production, staging and integration environments
are sensitive. The
[vagrant_credentials.yml](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/vagrant_credentials.yaml)
file, used with the [Vagrant test VMs](https://github.com/alphagov/govuk-puppet/blob/master/Vagrantfile),
should not contain any sensitive data but you can use it to test Hiera
eYAML GPG using dummy data.

There is currently no support for encrypted Hiera data using the
[development VM](https://github.com/alphagov/govuk-puppet/tree/master/development-vm);
this is intentional for reasons of simplicity.

## Why do we encrypt Hiera data?

We store secrets and sensitive data in a separate repository,
[govuk-secrets](https://github.com/alphagov/govuk-secrets). This lets
us open the [govuk-puppet](https://github.com/alphagov/govuk-puppet)
repository to all developers, while restricting access to the
govuk-secrets repository to a small number of staff.

Deploying puppet copies govuk-secrets over the files in the
[govuk-puppet](https://github.com/alphagov/govuk-puppet) repository.

Even though we restrict who can see govuk-secrets, there are still downsides
to storing secrets in plain text:

-   It's dangerous to leave sensitive data unencrypted on disk. Even if
    everyone who has access to the govuk-secrets repository uses
    full disk encryption, secrets would be readable if a laptop is infected by
    malware, or if someone accidentally commits to a public repository or
    copies to an unencrypted disk.
-   GitHub notifications send secrets over plain text email if users comment
    on specific lines of a pull request that include changes to sensitive data.
-   A vulnerability in GitHub or an administrative error when setting
    access permissions could expose secrets.

By encrypting Hiera data using GPG, we can define who has access to these
secrets (using GPG keys) and we have the extra protection of GPG encryption,
which gives us time to change credentials when secrets are exposed.

There are no plans to merge the govuk-puppet and govuk-secrets repositories.
Having them separate still provides extra protection against accidental exposure.

## Common tasks for handling encrypted Hiera data

Hiera eYAML provides a command-line tool for viewing and editing
encrypted data.

There is a
[Rakefile](https://github.com/alphagov/govuk-secrets/blob/master/puppet/Rakefile)
in the puppet/ directory of the
[govuk-secrets](https://github.com/alphagov/govuk-secrets) repository
which wraps the Hiera eYAML tool and helps to ensure that sensitive data is
only accessible to the intended recipients.

You must use the rake tasks to change encrypted Hiera data.

### Prerequisites

1.  Pull the latest changes from the
    [govuk-secrets](https://github.com/alphagov/govuk-secrets) repository.

2.  Run `bundler` to install dependencies:

        cd puppet/
        bundle install
        cd puppet_aws/
        bundle install

### Encrypting a Hiera key

1.  Where `integration` is the name of the environment whose credentials
    you wish to edit, run:

        bundle exec rake eyaml:edit[integration]

    It will ask you for your GPG passphrase. If you get an
    error, please see the troubleshooting section below.

    The above command will open a text editor (as determined by the
    `$EDITOR` environment variable) showing the undecrypted Hiera data in
    YAML format.

    An unencrypted Hiera key and value looks like:

        password: 'thisisasecret'

2.  To encrypt the Hiera value, enclose it in square brackets prefixed
    with the string DEC::GPG and suffixed with a trailing exclamation
    mark (!).

    The above example would look as follows:

        password: DEC::GPG[thisisasecret]!

    Do not enclose it in single or double quotes as this will get
    interpreted as part of the secret.

    Once you have finished, save the file and quit the editor.
    Hiera eYAML will encrypt your changes. If you get an error, please see the
    troubleshooting section below.

    > **Note**
    >
    > When editing a Hiera key that has been encrypted before, you will
    > notice a number in parentheses after the word GPG; for
    > example: DEC::GPG(1). You should not make any changes to the number, as
    > Hiera eYAML GPG uses this to identify existing encrypted data.

3.  Check that the value is really encrypted! If you make a typo in your markup,
    Hiera eYAML doesn't always treat it as an error.

        GIT_PAGER='less -S' git diff

## Managing access to encrypted Hiera data

The list of people that have access to encrypted Hiera data in stored in a
recipient file specific to each environment (`.rcp` extension).

The production and integration files are stored in the govuk-secrets repo for
[Carrenza](https://github.com/alphagov/govuk-secrets/tree/master/puppet/gpg_recipients)
and [AWS](https://github.com/alphagov/govuk-secrets/tree/master/puppet_aws/gpg_recipients).
There is no separate staging file; the production file is used for both
staging and production.

The `.rcp` file for Vagrant is stored in the [govuk-secrets repo](https://github.com/alphagov/govuk-secrets/tree/master/puppet/gpg_recipients).

Each line in a recipient file corresponds to a [GPG fingerprint](http://en.wikipedia.org/wiki/Public_key_fingerprint) and
usually is identified by a comment after the hash (\#) symbol denoting
its owner. Each GPG key (and owner of that key) listed in the recipient
file is able to decrypt data belonging to the environment that the
recipient file pertains to.

### What to do when someone joins

1.  Ask the joiner to [create a GPG key](create-a-gpg-key.html) and upload it
    to a public key server (such as <https://pgp.mit.edu/>).
2.  Get the fingerprint of the new GPG key by running `gpg --fingerprint`.
3.  Add the joiners's GPG fingerprint to each of the recipient files
    for Carrenza
    [integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/integration_hiera_gpg.rcp)
    and [production](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/production_hiera_gpg.rcp),
    AWS [integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet_aws/gpg_recipients/integration_hiera_gpg.rcp)
    and [production](https://github.com/alphagov/govuk-secrets/blob/master/puppet_aws/gpg_recipients/production_hiera_gpg.rcp),
    and
    [Vagrant](https://github.com/alphagov/govuk-puppet/blob/master/gpg_recipients/vagrant_hiera_gpg.rcp).
    There are no staging recipient files since these are the same as the
    production recipient files.
4.  Recrypt the hieradata by running `re-encrypt-all.sh <message>` where `<message>`
    is something like "Adding new key for Jane Smith".
5.  Commit your changes and raise a pull request for review.
6.  Check that the joiner has uploaded their gpg key.
    If their key isn't on a public keyserver it interupts other people's workflow so please make sure it has been uploaded.
7.  Take care when rebasing changes to master that have been merged since you
    started your PR. The encrypted hieradata files are effectively binary data
    that git's text diff may not correctly merge. You will likely have to
    reset your recrypted versions and start again from the versions on master.

### What to do when someone leaves

Remove leavers from all recipient files, so that they can no longer change
credentials.

1.  Delete the leaver's GPG fingerprint from each of the recipient files
    for Carrenza
    [integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/integration_hiera_gpg.rcp)
    and [production](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/production_hiera_gpg.rcp),
    AWS [integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet_aws/gpg_recipients/integration_hiera_gpg.rcp)
    and [production](https://github.com/alphagov/govuk-secrets/blob/master/puppet_aws/gpg_recipients/production_hiera_gpg.rcp),
    and
    [Vagrant](https://github.com/alphagov/govuk-puppet/blob/master/gpg_recipients/vagrant_hiera_gpg.rcp).
    There are no staging recipient files since these are the same as the
    production recipient files.
2.  Commit your changes and raise a pull request for review.

> **WARNING**
>
> Removing a GPG key from the recipient key and re-encrypting the
> credentials files does **not** mean that the leaver is no longer able
> to read the secrets it currently contains.
>
> Anyone who has previously had access to a credentials file may have
> retained a copy of the data. They are still able to decrypt the
> current copy of the credentials file and have made unencrypted copies.
>
> We must assume that, until the stored credentials are rotated and the
> credentials file is re-encrypted any secrets contained in the
> credentials file can still be read by anyone with a GPG key previously
> listed in the recipient list.

## How to (re)generate GPG keys for an environment

If a new environment is added or the Puppet GPG key for an existing environment
expires or is compromised, a new GPG key must be generated. This key allows
Puppet to read encrypted Hiera data.

To ensure consistency, new GPG keys are generated using a template
([example](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_templates/production_hiera_gpg_template.txt)).

To generate a new key:

1.  Generate a random passphrase using a secure method (such as a password
    manager).
2.  Run `bundle exec rake 'eyaml:gpg_create[integration]'`, where integration is
    the name of the environment to create the GPG key for, entering the
    passphrase when prompted.
3.  Depending on the version of `gpg` you are using, you may end up with either
    `.gpg` or `.kbx` files saved to the [2ndline password store](https://github.com/alphagov/govuk-secrets/tree/master/pass) in the
    [govuk-secrets](https://github.com/alphagov/govuk-secrets)
    repository, or in the `gpg` directory of the [govuk-puppet](https://github.com/alphagov/govuk-puppet)
    repository if you are generating a key for the 'vagrant' environment.
4.  If you have `.kbx` files as a result of step 3, you'll need to export the
    public and secret keys into `.gpg` files by running
    `gpg --keyring pubring.kbx --export > pubring.gpg` and
    `gpg --keyring pubring.kbx --export-secret-key > secring.gpg`. You'll need
    to set `GNUPGHOME` to the path that contains the keyring file
    (for example, `GNUPGHOME=~/govuk/govuk-secrets/pass/2ndline/hiera-eyaml-gpg/integration`).
5.  Remove all files from the folder apart from `pubring.gpg`, `secring.gpg`
    and `trustdb.gpg` (usually `S.gpg-agent`, `S.gpg-agent.browser`,
    `S.gpg-agent.extra` and `S.gpg-agent.ssh`).
6.  Add the passphrase you used when creating the new key to the 2nd line
    password store by running `PASSWORD_STORE_DIR=~/govuk/govuk-secrets/pass/2ndline PASSWORD_STORE_GPG_OPTS="--trust-model always" pass insert hiera-eyaml-gpg/integration-gpg-key-passphrase`.
    Note that `PASSWORD_STORE_GPG_OPTS` is required here other GPG will refuse
    to encrypt the data since the new GPG key isn't trusted by default.
7.  Change the relevant recipients file to remove the fingerprint of the old
    key and add the new fingerprint ([recipients file for integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/integration_hiera_gpg.rcp)).
8.  Run `bundle exec rake eyaml:recrypt[integration]` to recrypt the encrypted
    hieradata with the new GPG key.
9.  Open a pull request with all the changes so far and get it approved and
    merged.
10. Now, configure the Puppet Master in the relevant environment using the
    instructions in the next section.

> **WARNING**
>
> If you're generating a new key because the old one has been compromised, or
> if it has not yet expired, you should revoke the old key to prevent it being
> used.

### Configuring the Puppet Master

The GPG key, stored in the [2ndline password
store](https://github.com/alphagov/govuk-secrets/tree/master/pass) in the
[govuk-secrets](https://github.com/alphagov/govuk-secrets) repository,
must be installed on the Puppet Master so that encrypted Hiera data is available
to Puppet:

1.  Remove the passphrase from the secret key, where `6DB296C0` is the ID or
    fingerprint of the new key (the Puppet Master requires a secret key without
    a passphrase):

          $ gpg --edit-key 6DB296C0
          gpg> passwd
          Enter passphrase: <enter the passphrase>
          Enter the new passphrase for this secret key.
          Enter passphrase: <press enter>
          Repeat passphrase: <press enter>
          gpg> save
          $ gpg --export-secret-key 6DB296C0 > secring.gpg

2.  SSH to the Puppet Master (for example,
    `puppetmaster-1.management.staging`).
3.  Change to the root user (`sudo su -`).
4.  Go to `/etc/puppet/gpg`.
5.  Create a new folder (for example, `old`) and move all files currently in the
    `gpg` folder into there as a backup.
6.  Copy the new files to the Puppet Master using rsync from your local machine:
    `rsync --rsync-path="sudo rsync" ~/govuk/govuk-secrets/pass/2ndline/hiera-eyaml-gpg/integration/* puppetmaster-1.management.staging:/etc/puppet/gpg/`
7.  Make sure the new files have the correct permissions:
    `sudo chown -R puppet: /etc/puppet/gpg` and
    `sudo chmod -R 0700 /etc/puppet/gpg`.
8.  Deploy Puppet to pick up the changes.
9.  Send the new key to a key server, so that other people re-encrypting the
    Hiera data can obtain it easily: `gpg --send-keys 6DB296C0`.

> **WARNING**
>
> Make sure **not** to copy the production GPG key to the integration environment.

> **Note**
>
> In the time between adding the new keys to the Puppet Master, deploying
> puppet, and it running on all machines in the relevant environment, you
> will see alerts in Icinga about puppet not being able to read config files.
> These alerts will go away as each machine runs puppet.

## Troubleshooting

### Encryption fails when running the Rake task

If the rake task to edit the encrypted credentials fails, with errors
such as:

    $ bundle exec rake eyaml:edit[integration]
    [gpg] !!! Warning: General exception decrypting GPG file
    [hiera-eyaml-core] !!! Bad file descriptor

Check that you're using GPG version 2 or above. Hiera eYAML GPG appears
to fail when using GPG version 1 with lots of credentials.

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

### Puppet fails because it can't find a usable GPG key

When Puppet runs, you may see the following error:

    Hiera eYAML GPG encryption backend is not working; check that Puppet has a valid GPG key

This error can occur for the following reasons:

-   Puppet cannot find a GPG keyring in `/etc/puppet/gpg`. This
    should only occur in development or test VMs **or** on the
    Puppet Master. If this is a non-Vagrant environment (e.g.
    production), check that you have copied the GPG keys from the
    2ndline pass store to `/etc/puppet/gpg` - see [configuring the Puppet Master](#configuring-the-puppet-master).
    Servers running `puppet-agent` do not require a GPG key as they
    rely on the Puppet Master to provide and, when necessary, decrypt
    Hiera data.
-   The GPG key has expired; it should be replaced with a new key -
    see [how to (re)generate GPG keys for an environment](#how-to-regenerate-gpg-keys-for-an-environment).
-   The Hiera YAML files contain encrypted data for which the GPG keys
    in `/etc/puppet/gpg` is not listed as a recipient. Check the GPG
    recipient files and compare the fingerprint there to the fingerprint
    of the GPG keyring in `/etc/puppet/gpg`. You can find the fingerprint
    by executing the following command on the server:

        GNUPGHOME=/etc/puppet/gpg gpg --fingerprint

-   The shared folder configured in the
    [Vagrantfile](https://github.com/alphagov/govuk-puppet/blob/master/Vagrantfile)
    for Vagrant boxes is not being mounted correctly at `/etc/puppet/gpg`.
    Check the output of `mount` and try reloading the machine using:

        vagrant reload

    You should also check that the version of VirtualBox guest additions
    you are using is current and compatible with the VirtualBox version
    you are using.

### Puppet fails because it can't find gpgme

The error occurs because the Ruby load path is missing a directory
containing a shared object file belonging to the gpgme Ruby gem.

To fix this, you should destroy and re-provision your VM. For example,
for the development VM:

    vagrant destroy
    vagrant up

Alternatively, you can add the `$LOAD_PATH` to `/usr/bin/puppet` as shown
in [this commit](https://github.com/alphagov/govuk-puppet/commit/b7743452875b1dd83fda982e28ae8e776bc3a8b8).

### zsh: no matches found

If you encounter an error similar to

```
zsh: no matches found: eyaml:edit[integration]
```

Try either enclosing the rake command in single quotes or
set the
[noglob](http://zsh.sourceforge.net/Doc/Release/Options.html#index-NOGLOB)
option.

```
noglob bundle exec rake eyaml:edit[integration]
```
