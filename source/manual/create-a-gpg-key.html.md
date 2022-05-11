---
owner_slack: "#govuk-developers"
title: Create a GPG key
parent: "/manual.html"
layout: manual_layout
section: Accounts
---

We use GPG keys to encrypt our secrets. Documentation for using your GPG key can be found [here](/manual/encrypted-hiera-data.html#common-tasks-for-handling-encrypted-hiera-data).

## Prerequisites

Install `gpg` if you don't already have it.

You can use `brew install gpg-suite` to install the graphical [GPG Suite](https://gpgtools.org/). This comes with GPG Mail, which you may not want - you can install a [mailless version](https://formulae.brew.sh/cask/gpg-suite-no-mail) by running `brew install --cask gpg-suite-no-mail` instead.

## Creating a GPG key (using the GUI)

[GPGtools](https://gpgtools.org/) comes with a GUI which can perform most of the operations you need.

Before creating your key, make sure that your keyserver (the public server where your key is stored) is set to `hkps://keys.openpgp.org/` (the default). You can do this by going to preferences and setting your keyserver.

To create a new key, click "New". The `Name` field should be your name. For `Length`, you should have at least 4096.

The creation process will give you the option to upload to a public server. Say yes. You can check your key has been uploaded using the Lookup Key button in the GUI.

On the main page which lists all of your keys you can double click your key to get the required details (fingerprint and id).

See below for checking your passphrase.

## Creating a GPG key (using the command line)

Create a gpg key with `gpg --gen-key` using your
digital.cabinet-office.gov.uk email address. Defaults for the questions
should be fine, although you should choose a 4096-bit key.

> **Note**
>
> You should also generate a [revocation
> certificate](http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto-3.html#ss3.4)
> with `gpg --gen-revoke` and store it in a safe place (*not* on your
> laptop, maybe a USB stick in your locker).

### Working out your key ID and fingerprint

```
gpg --fingerprint firstname.lastname@digital.cabinet-office.gov.uk
```

Should look something like this.

```
pub   rsa2048 2013-02-08 [SC]
      37CC 021A C5C2 4E27 C4D9  5735 9B0E 9DD1 90E6 5803
      uid                  [ultimate] Firstname Lastname <firstname.lastname@digital.cabinet-office.gov.uk>
      sub   rsa2048 2013-02-08 [E]
```

The  fingerprint is `37CC 021A C5C2 4E27 C4D9 5735 9B0E 9DD1 90E6 5803`,
and the key ID is `90E65803` — the last 8 characters of the fingerprint.

## Save your public key to `govuk-secrets`

In the [`govuk-secrets` repository](https://github.com/alphagov/govuk-secrets), dump your public key into the `gpg_public_keys` directory then open a PR.

```
gpg --export -a --output ~/govuk/govuk-secrets/gpg_public_keys/your_name.asc your.email@digital.cabinet-office.gov.uk
```

## Make sure your passphrase works

You can test your passphrase like this:

```
echo "1234" | gpg -o /dev/null --local-user YOUR_FINGERPRINT_WITHOUT_SPACES -as - && echo "The correct passphrase was entered for this key"
```

You will be prompted to enter your passphrase upon running this command then if you have entered your passphrase correctly you will see "The correct passphrase was entered for this key".

## Backup a GPG key

### Backup and transfer GPG key to another computer (using the GUI)

To backup your key, select the key you want to backup in [GPG Keychain](https://gpgtools.org/) and then click on "Export". This will download your key in the following format:

`Name (keyID) – Public.asc` or `Name (keyID) – Secret.asc`

Then add your key to an encrypted zip file (see below for how to do this) and store it somewhere else, for example your Google Drive.

On your new machine, click on "Import" in GPG Keychain and select the `.asc` file your downloaded earlier.

When your key has been imported you should see it listed on the main page.

Instructions taken from [GPG Tools FAQ](https://gpgtools.tenderapp.com/kb/gpg-keychain-faq/backup-or-transfer-your-keys#transfer-keys-to-another-computer)

### Creating an encrypted zip file using the terminal

To zip one file, go to the directory containing the file and then do:

`zip -e {zipped filename} {original filename}`

so to encrypt your GPG key you'll use:

`zip -e "Name (keyID) – Public.asc.zip" "Name (keyID) – Public.asc"`

## Extend an expired GPG key

If your GPG key has expired, the easiest way to update it is to [extend the expiry date](https://superuser.com/questions/813421/can-you-extend-the-expiration-date-of-an-already-expired-gpg-key).

You may also find that you have sub-keys that are due to expire too. If you are using a Mac, the easiest way to check is to use the GPG Keychain application. In GPG Keychain, double-click on your key to see the details and go the the "Subkeys" tab. If you have a sub-key that is due to expire, you'll be asked if you want to update it.

After extending (or renewing) your GPG key, you will need to [extract the public key](#save-your-public-key-to-govuk-secrets) and raise a PR to update `govuk_secrets`.
