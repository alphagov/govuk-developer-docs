---
owner_slack: '#2ndline'
review_by: 2017-04-17
title: Create a GPG key
parent: "/manual.html"
layout: manual_layout
section: Support
---

# Create a GPG key

## Prerequisites

Install gpg if you don't already have it. [GPGtools](https://gpgtools.org/) is recommended if you are on a Mac.

Mac users note there have been problems experienced by some when using homebrew installed `gnupg2`, where gpg can't connect to the gpg-agent and your passphrase doesn't get cached. For decrypting one credential that's ok, but when decrypting the [Hiera eYAML](encrypted-hiera-data.html) file it will ask you for your passphrase for each of the credentials.

## Creating a GPG key

Create a gpg key `gpg --gen-key` using your
digital.cabinet-office.gov.uk email address. Defaults for the questions
should be fine although it's possibly worth going for a 4096 bit key.

> **NOTE:**
> You should also generate a [revocation
> certificate](http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto-3.html#ss3.4)
> with `gpg --gen-revoke` and store it in a safe place (*not* on your
> laptop, maybe a USB stick in your locker).

## Working out your key id and finger print

```
gpg --fingerprint firstname.lastname@digital.cabinet-office.gov.uk
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

## Upload your GPG key to a keyserver

Send your key to a keyserver by doing:

```
gpg --send-keys $KEYID
```

You now should be able to find your key on <http://keys.gnupg.net/>

It occasionally takes a while for the keyserver to display pushed keys
due to caching.
