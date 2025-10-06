---
owner_slack: "#govuk-developers"
title: Set up a YubiKey
description: Guide for setting up and using a YubiKey
layout: manual_layout
section: Security
---

# Set up a YubiKey for GPG and SSH (for Git)

This guide is considered "best practice" - we will walk you through how to set up GPG (for Commit Signing) and SSH (for Authentication with GitHub).

## Pre-Requisites

This guide assumes you are using a GDS-issued "Developer Build" MacBook Pro. We will predominantly use the CLI/Terminal to interact with the YubiKey as this gives us the greatest flexibility with configuration.

Naturally, you will need at least one YubiKey. (We recommend having two, so you have a backup in case one is lost.)

### Recommended Devices

We recommend the YubiKey 5C NFC, alternatively, you may prefer the form factor of a YubiKey 5C or YubiKey 5C Nano.

### Software Dependencies

You will first need to set up the following dependencies:

```sh
brew update
brew install gnupg
brew install ykman
```

## Yubikey Initial Checks

Insert your YubiKey and open your favourite Terminal. Run `ykman list` - you should see a result like this:

```
YubiKey 5C NFC (5.7.1) [OTP+FIDO+CCID] Serial: 31234567
```

The output might change slightly depending on the model of Yubikey and the Firmware version - for security reasons, Firmwares are permanently fixed and cannot be flashed or updated, as Yubikey operates on a "black box" security model.

You can also confirm which applications are supported and enable or diabled on your Yubikey by running `ykman info` - you should get output like this:

```
Device type: YubiKey 5C NFC
Serial number: 31234567
Firmware version: 5.7.1
Form factor: Keychain (USB-C)
Enabled USB interfaces: FIDO, CCID
NFC transport is enabled

Applications	USB     	NFC    
Yubico OTP  	Enabled	    Enabled
FIDO U2F    	Enabled 	Enabled
FIDO2       	Enabled 	Enabled
OATH        	Enabled 	Enabled
PIV         	Enabled 	Enabled
OpenPGP     	Enabled 	Enabled
YubiHSM Auth	Enabled 	Enabled
```

If you see an output that resembles something like this...

```
Device type: YubiKey Security Key
Serial number: 31234567
Firmware version: 5.7.1
Form factor: Keychain (USB-C)
Enabled USB interfaces: FIDO
NFC transport is enabled

Applications	USB     	    NFC    
Yubico OTP  	Not Supported   Not Supported
FIDO U2F    	Enabled 	    Enabled
FIDO2       	Enabled 	    Enabled
OATH        	Not Supported   Not Supported
PIV         	Not Supported   Not Supported
OpenPGP     	Not Supported   Not Supported
YubiHSM Auth	Not Supported   Not Supported
```

...then you have a YubiKey Security Key and you'll need to stop here and get a "proper" YubiKey 5 Series device before continuing.

Next you will want to test that the GPG CLI can communicate with your YubiKey:

```
gpg --card-status

Reader ...........: Yubico YubiKey FIDO CCID
Application ID ...: D2760001240100000006322522270000
Application type .: OpenPGP
Version ..........: 3.4
Manufacturer .....: Yubico
Serial number ....: 31234567
[truncated]
```

If at this point, you've successfully tested the `ykman` tool and GPG communication, you can continue...

## Initial Configuration

If you passed the previous steps, this will now take you past the recommended initial configuration before you have to risk repeating any steps.

### Disable YubiKey OTP

YubiKey has a proprietary OTP protocol that we currently do not use. It is generally recommended to turn this off to prevent accidental plaintext spam caused by touching the buttons on your YubiKey. You may be familiar with this if you have seen seemingly "random" messages from people on Slack such as `eerhtdgukfvhcetedhdejj`.

To turn this off, run the following commands:

```sh
ykman config usb --disable otp
ykman config nfc --disable otp
```

### Enable KDF (Optional)

KDF is "Key Derived Format" - it means your PINs are transmitted and stored in a hashed format rather than in plaintext. This is optional but may harden your security posture.

```sh
gpg --edit-card

gpg/card> admin
gpg/card> kdf-setup
```

### Set Maximum GPG Pin Entries

The YubiKey's GPG Application has a built-in mechanism to prevent brute-force attempts of the PIN. By default, this is set to `3 0 3` which represents:

* 3 Attempts of User PIN
* 0 Attempts of Reset PIN (Disabled by default)
* 3 Attempts of Administrator PIN

If the User PIN is entered incorrectly too many times, it must be unlocked using the Administrator PIN. If the Administrator PIN is entered too many times, the key will 

We would recommend setting these values to `10 0 10` which reduces the risk of accidentally locked or lost keys without increasing the risk of bruteforce attempts.

### Set User and Administrator PINs

If you have enabled KDF and set your retries policy, you can now set your User and Administrator PINs.

You will need to first confirm the "old" PINs - the Defaults are:

* User: 123456
* Administrator: 12345678

You should set your Admin PIN:
```sh
ykman openpgp access change-admin-pin

Enter Admin Pin: 12345678
Enter New Admin Pin: xxxxxxxx
Confirm New Admin Pin: xxxxxxxx
```

...and then you can set your User PIN:
```
Enter Admin Pin: 123456
Enter New Pin: xxxxxx
Confirm New Pin: xxxxxx
```

### Configuring GPG

Once your PINs are set, you can start to configure GPG (and then generate a key-pair)

```sh
gpg --edit-card

gpg/card> admin
gpg/card> help # Shows you the supported options
gpg/card> name # Set to your name
gpg/card> login # Set to your email address
```

We are almost ready to start generating a key, however, before we start, you should set the key-attribute:

```
gpg/card> key-attr

key-attr
Changing card key attribute for: Signature key
Please select what kind of key you want:
   (1) RSA
   (2) ECC
Your selection?  ECC
```

We recommend **ECC** as it is more modern and secure than RSA and is now supported by the vast majority of applications.

### Generate Key Pair

Now you have configured

```
gpg/card> generate
```

You may be asked to make a backup - say "no":

```
Make off-card backup of encryption key? (Y/n)
```

You will be asked to set a validity for the key - we recommend setting it to "does not expire":
```
Please specify how long the key should be valid.
         0 = key does not expire
         <n>  = key expires in n days
         <n>w = key expires in n weeks
         <n>m = key expires in n months
         <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y
```

Next you will be asked to confirm your personal details - use the prompts to confirm:
```
Real name: Firstname Lastnamerson
Email address: firstname.lastnamerson@digital.cabinet-office.gov.uk
Comment: GDS
You selected this USER-ID:
    "Firstname Lastnamerson (GDS) <firstname.lastnamerson@digital.cabinet-office.gov.uk>"
```

When you are happy, Enter "O" and continue:
```
Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
```

Lastly, you will be asked to set a Passphrase. Set this to something only you know and are happy to recite on a regular basis when prompted to use the key.

### Configuring SSH to use the Yubikey

Once you have generated your key pair, you can now set up SSH to use it. While this step will use ssh-keygen, all it is doing is effectively creating a "pointer" to the Security Key (hence the -sk designation).

```
ssh-keygen -t ed25519-sk -O resident -O verify-required -C "Firstname Lastnamerson (GDS) <firstname.lastnamerson@digital.cabinet-office.gov.uk>"
```

Once you have generated the "pointer" file for the Security Key, you will want to make sure your SSH config (located at `~/.ssh/config`) contains a block like this:

```
Host *
  IdentityFile /Users/firstname.lastnamerson/.ssh/id_ed25519_sk
  IdentitiesOnly yes
  IdentityAgent none
  AddKeysToAgent yes
```

This should mean that your SSH Agent (and Git) will find and use the correct file.

### Configuring Git to use the SSH and Signing Keys

This is where we actually get to use the keys you have just generated.

#### Configure Git to use your SSH Key

Once your SSH key is created and attached to the SSH agent, you will want to add the Public Key to your GitHub Profile.

* Go to your [GitHub Settings Page -> Access -> SSH and GPG keys](https://github.com/settings/keys).
* Click "New SSH key"
* Set the "Title" to something you can remember, e.g. "YubiKey SSH Key"
* Select "Key type" as "Authentication Key"
* Paste the contents of `~/.ssh/id_ed52219_sk.pub` into the "Key" field.

Once this is done, you should now be able to use your new key to pull and push to/from GitHub.

#### Configure Git to use your GPG Key

We also believe that signing your commits is considered "best practice". This helps verify that your commits came from you and not just from someone claiming to be you. In order for Git to Sign your commits, you will need to find your Key ID from your YubiKey.

Run `gpg --card-status` to get something like this:

```
gpg --card-status
Reader ...........: Yubico YubiKey FIDO CCID
Application ID ...: D2760001240100000006322522270000
[truncated]
General key info..: pub  ed25519/A3F1E9C0B827D54E 2025-09-23 Firstname Lastnamerson (GDS/DSIT) <firstname.lastnamerson@digital.cabinet-office.gov.uk>
sec>  ed25519/A3F1E9C0B827D54E  created: 2025-09-23  expires: never     
                                card-no: 0006 31234567
ssb>  ed25519/4B7E0C1F8A9D6325  created: 2025-09-23  expires: never     
                                card-no: 0006 31234567
ssb>  cv25519/9E5D2A6C8F0B4173  created: 2025-09-23  expires: never     
                                card-no: 0006 31234567
```

Note the Key ID from the sec row, e.g. `A3F1E9C0B827D54E` and add it to your Git Config in `.git/config` - make sure you have a config that looks like this:

```
[commit]
    gpgsign = true

[user]
    email = firstname.lastnamerson@digital.cabinet-office.gov.uk
    name = Firstname Lastnamerson
    signingkey = A3F1E9C0B827D54E
```

Now run this command from your Terminal:

```
gpg --armor --export A3F1E9C0B827D54E
```

Take the output from this command and head back to [GitHub Settings Page -> Access -> SSH and GPG keys](https://github.com/settings/keys) and scroll down to "GPG keys" and "New GPG key".

Again, set the "Title" to something you might find helpful and paste the Public Key Block into the "Key" field. GitHub will now be able to Verify any commits you make as coming from your GPG key (and therefore probably from you).

# Set up a YubiKey as an MFA device for AWS

1. Install the [Yubico Authenticator](https://www.yubico.com/products/yubico-authenticator/) app on your computer.
1. [Sign into the `gds-users` AWS account](https://gds-users.signin.aws.amazon.com/console).
1. Select your email address in the top-right corner of the page.
1. Choose __Security credentials__ from the drop-down menu.
1. Select __Manage__, which is next to __Assigned MFA device__.
1. Specify your email address as the MFA device name.
1. Select __Authenticator app__, not __Security Key__.
1. Click to reveal the QR code.
1. Open the Yubico Authenticator app, choose Add Account from the hamburger menu at the top-right of the window and choose Scan QR code.
1. Make sure __Require touch__ is enabled.
1. Enter two consecutive codes from Yubico Authenticator and press __Save__.
1. Configure gds-cli to use the YubiKey:

    ```
    gds config yubikey true
    ```

1. Go back to the __Security credentials__ page and add the YubiKey again as a second MFA device, but choose __Security Key__ this time.

You have now:

- added your YubiKey as a U2F/FIDO2 security key for logging into the AWS web console more securely and conveniently
- added your YubiKey as a legacy OATH MFA device for compatibility with gds-cli/aws-vault on the command line

> ⚠️ Now that you have an unphishable security key as an MFA device, you should never type or copy/paste the 6-digit OATH one-time codes. They're only for gds-cli/aws-vault now, not for you.
>
> Always use the __Security Key__ option and not the legacy Authenticator app option when signing into the AWS web console.
