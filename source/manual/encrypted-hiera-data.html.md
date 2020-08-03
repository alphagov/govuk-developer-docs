---
owner_slack: "#govuk-developers"
title: Handle encrypted hieradata
parent: "/manual.html"
layout: manual_layout
section: Deployment
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
directories of the
[alphagov/govuk-puppet](https://github.com/alphagov/govuk-puppet) and
[alphagov/govuk-secrets](https://github.com/alphagov/govuk-secrets)
repositories. These files contain secrets such as passwords and private keys.

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

- It's dangerous to leave sensitive data unencrypted on disk. Even if
  everyone who has access to the govuk-secrets repository uses
  full disk encryption, secrets would be readable if a laptop is infected by
  malware, or if someone accidentally commits to a public repository or
  copies to an unencrypted disk.
- GitHub notifications send secrets over plain text email if users comment
  on specific lines of a pull request that include changes to sensitive data.
- A vulnerability in GitHub or an administrative error when setting
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

1. Pull the latest changes from the
   [govuk-secrets](https://github.com/alphagov/govuk-secrets) repository.

2. Run `bundle` to install dependencies.

### Encrypting a Hiera key

1. Where `integration` is the name of the environment whose credentials
   you wish to edit, cd into the relevant directory:

       cd puppet_aws

   and run:

       bundle exec rake eyaml:edit[integration]

   It will ask you for your GPG passphrase. If you get an
   error, please see the troubleshooting section below.

   The above command will open a text editor (as determined by the
   `$EDITOR` environment variable) showing the undecrypted Hiera data in
   YAML format.

   An unencrypted Hiera key and value looks like:

       password: 'thisisasecret'

2. To encrypt the Hiera value, enclose it in square brackets prefixed
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

3. Check that the value is really encrypted! If you make a typo in your markup,
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

Each line in a recipient file corresponds to a [GPG fingerprint](http://en.wikipedia.org/wiki/Public_key_fingerprint) and
usually is identified by a comment after the hash (\#) symbol denoting
its owner. Each GPG key (and owner of that key) listed in the recipient
file is able to decrypt data belonging to the environment that the
recipient file pertains to.

### What to do when someone joins

1. Ask the joiner to [create a GPG key](create-a-gpg-key.html) and upload it
   to a public key server (such as <https://pgp.mit.edu/>).
2. Get the fingerprint of the new GPG key by running `gpg --fingerprint`.
3. Add the joiners's GPG fingerprint to each of the recipient files
   for Carrenza
   [integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/integration_hiera_gpg.rcp),
   AWS [integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet_aws/gpg_recipients/integration_hiera_gpg.rcp)
4. Recrypt the hieradata by running `re-encrypt-all.sh <message>` where `<message>`
   is something like "Adding new key for Jane Smith".
5. Commit your changes and raise a pull request for review.
6. Check that the joiner has uploaded their GPG key.
    If their key isn't on a public keyserver it interupts other people's workflow so please make sure it has been uploaded.
7. Take care when rebasing changes to master that have been merged since you
   started your PR. The encrypted hieradata files are effectively binary data
   that git's text diff may not correctly merge. You will likely have to
   reset your recrypted versions and start again from the versions on master.

### What to do when someone gets production access

Follow the steps above but add their GPG fingerprint to the production recipient files for Carrenza [production](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/production_hiera_gpg.rcp) and AWS [production](https://github.com/alphagov/govuk-secrets/blob/master/puppet_aws/gpg_recipients/production_hiera_gpg.rcp).

Note there are no staging recipient files - access to staging secrets is controlled by the production recipient files.

### What to do when someone leaves

Remove leavers from all recipient files, so that they can no longer change
credentials.

1. Delete the leaver's GPG fingerprint from each of the recipient files
   for Carrenza
   [integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/integration_hiera_gpg.rcp)
   and [production](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/production_hiera_gpg.rcp),
   AWS [integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet_aws/gpg_recipients/integration_hiera_gpg.rcp)
   and [production](https://github.com/alphagov/govuk-secrets/blob/master/puppet_aws/gpg_recipients/production_hiera_gpg.rcp).
   There are no staging recipient files since these are the same as the
   production recipient files.
2. Commit your changes and raise a pull request for review.

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

1. Generate a random passphrase using a secure method (such as openssl with
   command `openssl rand -base64 65 | tr -d '\n' | awk '{ print $0 }'` to
   generate a 65 characters random string).

2. Generate the GPG key pair (this assumes you are using GPG 2.x):
    1. Git clone the [govuk-secret](https://github.com/alphagov/govuk-secrets)

    2. Create a new directory where the GPG key pair will be created:
       e.g. `mkdir ~/new_hiera_gpg && cd ~/new_hiera_gpg`

    3. Create the GPG key ring (`pubring.kbx`) based on the appropriate template
       (this will depend on the environment that you want to create the GPG key
       for) in [govuk-secrets](https://github.com/alphagov/govuk-secrets/tree/master/puppet/gpg_templates):

       ```shell
       gpg --homedir $PWD --verbose --batch --gen-key <path_to_selected_template>
       ```

       where `<path_to_selected_template>` is the file path of the template you
       want to use. You will be prompted for the passphrase

    4. Extract the public key (`pubring.gpg`) of the GPG key pair by running:

       ```shell
       gpg --homedir $PWD --keyring ./pubring.kbx --export > ./pubring.gpg
       ```

       You should store this key in the appropriate location in govuk-secrets:
       e.g. for integration [here](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/hiera-eyaml-gpg/integration)
       and for production [here](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/hiera-eyaml-gpg/production)

    5. Extract the passphrase protected private key (`secring.gpg`) of the GPG
       key pair by running (you will have to supply the passphrase):

       ```shell
       gpg --homedir $PWD --keyring ./pubring.kbx --export-secret-key > ./secring.gpg
       ```

       You should store this key in the appropriate location in govuk-secrets:
       e.g. for integration [here](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/hiera-eyaml-gpg/integration)
       and for production [here](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/hiera-eyaml-gpg/production)

    6. You can obtain the fingerprint of the GPG key pair by running:

       ```shell
       gpg -n -q --import --import-options import-show pubring.gpg
       ```

       and noting the 41 character string in the output.

    7. Send the key to the ubuntu key server by running:

       ```shell
       gpg --homedir $PWD --keyserver keyserver.ubuntu.com --send-key <fingerprint>
       ```

       where `<fingerprint>` was obtained above.

3. Add the passphrase you used when creating the new GPG key to the 2nd line
   password store by running inside the [pass](https://github.com/alphagov/govuk-secrets/tree/master/pass) directory of the govuk-secrets:

   ```shell
   PASSWORD_STORE_GPG_OPTS="--trust-model always" ./edit.sh 2ndline hiera-eyaml-gpg/<environment_passphrase_key>
   ```

   where the `<environment_passphrase_key>` can be: `production-gpg-key-passphrase`
   or `integration-gpg-key-passphrase` depending on which environment you are
   modifying.
   Note that `PASSWORD_STORE_GPG_OPTS` is required here or otherwise GPG will
   refuse to encrypt the data since the new GPG key isn't trusted by default.

   If you get any error message, you should read the stored secret passphrase
   again to ensure that the correct value has been stored.

4. Change the relevant files to remove the fingerprint of the old
   key and add the new fingerprint (as obtained above). If you changed:
     1. integration:
       - [carrenza puppet recipients file for integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/integration_hiera_gpg.rcp)
       - [aws puppet recipients file for integration](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/integration_hiera_gpg.rcp)
       - [common puppet ruby recipient file](https://github.com/alphagov/govuk-secrets/blob/master/puppet_common/gpg_recipients.rb)

      2. production:
       - [carrenza puppet recipients file for production](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/production_hiera_gpg.rcp)
       - [aws puppet recipients file for production](https://github.com/alphagov/govuk-secrets/blob/master/puppet/gpg_recipients/production_hiera_gpg.rcp)

5. Add and commit locally your changes to govuk-secrets. You can then use
   the [re-encrypt-all.sh](https://github.com/alphagov/govuk-secrets/blob/master/re-encrypt-all.sh)
   to re-encrypt all the relevant parts of govuk-secrets.

6. Open a pull request with all the changes so far and get it approved and
   merged.

7. Next, you need, as detailed in subsequent sections, to:
    1. Configure the Puppet Master in the relevant environment

    2. Upload the non-passphrase protected private GPG key to AWS parameter store

> **WARNING**
>
> If you're generating a new key because the old one has been compromised, or
> if it has not yet expired, you should revoke the old key to prevent it being
> used.

### Configuring the Puppet Master

The GPG key `secring.gpg`, stored in the [2ndline password
store](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/hiera-eyaml-gpg) in the
[govuk-secrets](https://github.com/alphagov/govuk-secrets) repository,
must be installed on the Puppet Master so that encrypted Hiera data is available
to Puppet:

1. Create a new directory to do the GPG operations:

   ```shell
   mkdir ~/unprotected_gpg && cd ~/unprotected_gpg
   ```

2. Copy in the new directory the private GPG key `secring.gpg` of the relevant
    environment from the [directory](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/hiera-eyaml-gpg)
   in govuk-secrets.

3. In the new directory, get the fingerprint of the GPG key by running:

   ```shell
   gpg -n -q --import --import-options import-show secring.gpg
   ```

   and noting the 41 character string in the output.

4. Import the private GPG key:

   ```shell
   gpg --homedir $PWD --import secring.gpg
   ```

5. Extract the non-passphrase protected private key (`secring_unprotected.gpg`)
   by running: `gpg --homedir $PWD --edit-key <finderprint>`
   where `<fingerprint>` was obtained in the previous step. You will then
   enter the GPG prompt where you should type `passwd`. You will then be
   asked to provide the current passphrase of the private key and afterwards,
   you will be asked to provide a new passphrase which should be
   empty/nothing. You may get a prompt asking to confirm that you want to
   unprotect the key and you should confirm yes. You can quit the GPG prompt
   by typing `quit`

   You can extract the unprotected key by exporting it:

   ```shell
   gpg --homedir $PWD --export-secret-key <fingerprint> > secring_unprotected.gpg
   ```

   where `<fingerprint>` is the fingerprint obtained above.

5. SSH to the Puppet Master (for example,
   `puppetmaster-1.management.staging`).

6. Change to the root user (`sudo su -`).

7. Go to `/etc/puppet/gpg` directory.

8. Create a new folder (for example, `old`) and move all files currently in the
   `gpg` folder into there as a backup.

9. Copy the following files to the Puppet Master using from your local machine:
    1. `secring_unprotected.gpg` as `/etc/puppet/gpg/secring.gpg` on puppetmaster

    2. `pubring.gpg` (obtained from the appropriate environment/directory in [here](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/hiera-eyaml-gpg)) as `/etc/puppet/gpg/pubring.gpg` on puppetmaster.

10. Make sure the new files have the correct permissions:
    `sudo chown -R puppet:puppet /etc/puppet/gpg` and
    `sudo chmod -R 0700 /etc/puppet/gpg`.

11. Re-deploy Puppet to pick up the changes.

> **WARNING**
>
> Make sure **not** to copy the production GPG key to the integration environment.
>
> **Note**
>
> In the time between adding the new keys to the Puppet Master, deploying
> puppet, and it running on all machines in the relevant environment, you
> will see alerts in Icinga about puppet not being able to read config files.
> These alerts will go away as each machine runs puppet.

### Uploading private GPG key to AWS parameter store

The non-passphrase protected private GPG key must be uploaded to the AWS
parameter store so that if puppet is re-provisioned in AWS, the new instance of
puppet will automatically get the private GPG key to decrypt the secret hiera.

This can be done by:

1. Follow the steps in section `Configuring the Puppet Master` to get the
   non-passphrase protected private GPG key.

2. Split the non-passphrase protected GPG key into 3 parts due
   to the issue that the AWS parameter store has a size limit per item.
   This can be done by running:

   ```shell
   base64 secring_unprotected.gpg > secring_unprotected.gpg.base64
   tr -d 'n' < secring_unprotected.gpg.base64 > secring_unprotected.gpg.base64.trimmed
   split -b 4096 secring_unprotected.gpg.base64.trimmed secring_unprotected_part_
   ```

   You will obtained a number of files with name starting with
   `secring_unprotected_part_`.

3. Upload the `secring_unprotected_part_` parts to AWS parameter store:
    1. Login to the AWS web console of the environment to be modified

    2. Browse to the AWS Systems Manager and then to the Parameter Store (
       link is usually at the bottom of the left column of the Systems Manager)

    3. There will be 3 keys with prefix: `govuk_base64_gpg_` which you should
       update with the content of the files `secring_unprotected_part_`

## Troubleshooting

### Encryption fails when running the Rake task

If the rake task to edit the encrypted credentials fails, with errors
such as:

```
$ bundle exec rake eyaml:edit[integration]
[gpg] !!! Warning: General exception decrypting GPG file
[hiera-eyaml-core] !!! Bad file descriptor
```

Check that you're using GPG version 2 or above. Hiera eYAML GPG appears
to fail when using GPG version 1 with lots of credentials.

If you see this error:

```
General error
```

Try pulling `master` again - there's a good chance someone has made a
change since you made your changes. Otherwise, check if any of the GPG
keys in the recipients list have expired.

If you see this error:

```
[hiera-eyaml-core] !!! Bad passphrase
```

Check that your GPG configuration is sane. Try encrypting and decrypting
some dummy text using the `gpg` command:

```sh
echo 'foo' | gpg --armor --encrypt --recipient matt.bostock@digital.cabinet-office.gov.uk | gpg --decrypt
```

The `gpg` command above might give a more useful error message than the
gpgme library, which Hiera eYAML GPG uses.

If you see this error:

```
[hiera-eyaml-core] !!! Decryption failed
```

Make sure that another PR re-encrypting the credentials was not merged
before your one. If this is the case, the credentials will need to be
re-encrypted again, making sure that your GPG key fingerprint is in the
relevant recipient files.

If you see this error:

```
[hiera-eyaml-core] No key found on keyring for <fingerprint>
```

This means that you don't have one of the recipient's key on your keyring.
You can download one or more keys with the following command:

```shell
gpg --keyserver keyserver.ubuntu.com --recv-keys <fingerprint>
```

Alternatively, you can run the `govuk-secrets/pass/trust_all.sh` script. This
will fetch all recipient keys from the keyserver.
[More information can be found in the govuk-secrets README](https://github.com/alphagov/govuk-secrets/tree/master/pass#trust-user-public-keys).

### Puppet fails because it can't find a usable GPG key

When Puppet runs, you may see the following error:

```
Hiera eYAML GPG encryption backend is not working; check that Puppet has a valid GPG key
```

This error can occur for the following reasons:

- Puppet cannot find a GPG keyring in `/etc/puppet/gpg`. This
  should only occur in development or test VMs **or** on the
  Puppet Master. Check that you have copied the GPG keys from the
  2ndline pass store to `/etc/puppet/gpg` - see [configuring the Puppet Master](#configuring-the-puppet-master).
  Servers running `puppet-agent` do not require a GPG key as they
  rely on the Puppet Master to provide and, when necessary, decrypt
  Hiera data.
- The GPG key has expired; it should be replaced with a new key -
  see [how to (re)generate GPG keys for an environment](#how-to-regenerate-gpg-keys-for-an-environment).
- The Hiera YAML files contain encrypted data for which the GPG keys
  in `/etc/puppet/gpg` is not listed as a recipient. Check the GPG
  recipient files and compare the fingerprint there to the fingerprint
  of the GPG keyring in `/etc/puppet/gpg`. You can find the fingerprint
  by executing the following command on the server:

  ```
  GNUPGHOME=/etc/puppet/gpg gpg --fingerprint
  ```

### Puppet fails because it can't find gpgme

You can add the `$LOAD_PATH` to `/usr/bin/puppet` as shown
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
