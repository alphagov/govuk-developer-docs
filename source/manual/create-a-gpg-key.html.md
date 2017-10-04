---
owner_slack: "#2ndline"
title: Create a GPG key
parent: "/manual.html"
layout: manual_layout
section: Support
last_reviewed_on: 2017-10-04
review_in: 6 months
---

We use GPG keys to encrypt our secrets, documentation for using your GPG key can be found [here](/manual/encrypted-hiera-data.html#common-tasks-for-handling-encrypted-hiera-data).

## Prerequisites

Install gpg if you don't already have it. [GPGtools](https://gpgtools.org/) is recommended if you are on a Mac.

Do not use the homebrew version. Mac users note there have been problems experienced by some when using homebrew installed `gnupg2`, where gpg can't connect to the gpg-agent and your passphrase doesn't get cached. For decrypting one credential that's ok, but when decrypting the [Hiera eYAML](encrypted-hiera-data.html) file it will ask you for your passphrase for each of the credentials.

Once installed, you will likely have both `gpg` and `gpg2` on your machine. Always use `gpg2`.

## Creating a GPG key (using the GUI)

[GPGtools](https://gpgtools.org/) comes with a GUI which can perform most of the operations you need.

To create a new key, click "New". The `Name` field should your name. For `Length` have at least 4096.

The creation process will give you the option to upload to a public server. Say yes. You can check your key has been uploaded using the Lookup Key button in the GUI.

On the main page which lists all of your keys you can double click your key to get the required details (fingerprint and id).

See below for checking your passphrase.

## Creating a GPG key (command line)

Create a gpg key `gpg2 --gen-key` using your
digital.cabinet-office.gov.uk email address. Defaults for the questions
should be fine although it's possibly worth going for a 4096 bit key.

> **NOTE:**
> You should also generate a [revocation
> certificate](http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto-3.html#ss3.4)
> with `gpg2 --gen-revoke` and store it in a safe place (*not* on your
> laptop, maybe a USB stick in your locker).

### Working out your key id and finger print

```
gpg2 --fingerprint firstname.lastname@digital.cabinet-office.gov.uk
```

Should look something like this.

```
pub   2048R/90E65803 2013-02-08
      Key fingerprint = 37CC 021A C5C2 4E27 C4D9  5735 9B0E 9DD1 90E6 5803
      uid                  my name <my.name@digital.cabinet-office.gov.uk>
      sub   2048R/FDD27DBE 2013-02-08
```

The key id is `90E65803` in this case. The fingerprint is `37CC 021A C5C2
4E27 C4D9 5735 9B0E 9DD1 90E6 5803`

### Upload your GPG key to a keyserver

Send your key to a keyserver by doing:

```
gpg2 --send-keys $KEYID
```
If you are having problems uploading your key, it's worth trying another keyserver. Those trying to receive your key may be connecting to a different keyserver than the one you sent your key to. This is fine, as the keyservers synchronise, but this may take some time to happen.

You now should be able to find your key on <http://keys.gnupg.net:11371/>

It occasionally takes a while for the keyserver to display pushed keys due to caching.

You can find an overview of the GPG keyserver pools [here](https://sks-keyservers.net/overview-of-pools.php)

## Make sure your passphrase works

You can test your passphrase like this:

```
echo "1234" | gpg2 -o /dev/null --local-user YOUR_FINGERPRINT_WITHOUT_SPACES -as - && echo "The correct passphrase was entered for this key"
```

If you have entered your passphrase correctly you will see "The correct passphrase was entered for this key" text.
