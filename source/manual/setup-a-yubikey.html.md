---
owner_slack: "#govuk-developers"
title: Set up a YubiKey
description: Guide for setting up and using a YubiKey
layout: manual_layout
section: Security
---

# Set up a YubiKey for GPG and SSH (for Git)

This guide describes recommended steps to set up a YubiKey for use with GPG (for commit signing) and SSH (for Git authentication with GitHub).

> **⚠️ Warning**
>
> Once you have followed this guide, your YubiKey is effectively now your only way to get into AWS or to Sign or push commits up to GitHub.
>
> You should treat your YubiKey with care - do not lose it and do not leave it unattended unless you are prepared to get locked out of your systems.

## Pre-Requisites

This guide assumes you are using a GDS-issued "Developer Build" MacBook Pro. We will predominantly use the CLI/terminal to interact with the YubiKey as this gives us the greatest flexibility with configuration.

You will need at least one YubiKey. We recommend having two: keep one in daily use and store a second as an offline backup in case the primary key is lost or damaged.

### Recommended Devices

Recommended: YubiKey 5C NFC.

Alternative form factors: YubiKey 5C and YubiKey 5C Nano (if you prefer a smaller device).

> **⚠️ Note**
>
> Yubico sells another product called **YubiKey Security Key**, which is a FIDO-only device that does not support the features required to perform commit signing or SSH authentication. Make sure you are requesting or purchasing the correct device.

If you need to obtain a YubiKey, speak to your Delivery Manager or Tech Lead about how to get one - alternatively, you may be able to expense them with approval from your Line Manager.

### Software Dependencies

You will first need to make sure the required software dependencies are installed and on the latest versions:

```sh
brew update
brew install gnupg
brew install libfido2
brew install openssh
brew install openssl
brew install ykman
```

## Yubikey Initial Checks

Insert your YubiKey and open your favourite terminal. Run `ykman list` - you should see a result like this:

```
YubiKey 5C NFC (5.7.1) [OTP+FIDO+CCID] Serial: 31234567
```

The output might change slightly depending on the model of Yubikey and the Firmware version - for security reasons, Firmwares are permanently fixed and cannot be flashed or updated, as Yubikey operates on a "black box" security model.

You can also confirm which applications are supported and enabled or disabled on your YubiKey by running `ykman info` - you should get output like this:

```
Device type: YubiKey 5C NFC
Serial number: 31234567
Firmware version: 5.7.1
Form factor: Keychain (USB-C)
Enabled USB interfaces: FIDO, CCID
NFC transport is enabled

Applications    USB         NFC
Yubico OTP      Enabled     Enabled
FIDO U2F        Enabled     Enabled
FIDO2           Enabled     Enabled
OATH            Enabled     Enabled
PIV             Enabled     Enabled
OpenPGP         Enabled     Enabled
YubiHSM Auth    Enabled     Enabled
```

If you see an output that resembles something like this...

```
Device type: YubiKey Security Key
Serial number: 31234567
Firmware version: 5.7.1
Form factor: Keychain (USB-C)
Enabled USB interfaces: FIDO
NFC transport is enabled

Applications    USB             NFC
Yubico OTP      Not Supported   Not Supported
FIDO U2F        Enabled         Enabled
FIDO2           Enabled         Enabled
OATH            Not Supported   Not Supported
PIV             Not Supported   Not Supported
OpenPGP         Not Supported   Not Supported
YubiHSM Auth    Not Supported   Not Supported
```

...then you have a YubiKey Security Key and you'll need to stop here and get a "proper" YubiKey 5 Series device before continuing.

Next, test that the GPG CLI can communicate with your YubiKey:

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

If you have reached this section, then `ykman` and GPG communication are working correctly and you can continue to configuration.

## Initial Configuration

This will now take you through the recommended initial configuration of the YubiKey before you start generating credentials. If some of these options are not set correctly, you may need to destroy and re-create your credentials.

### Default PINs

Some of the commands and options listed below will require you to confirm a User or Administrator PIN. If you have a new (or recently reset) YubiKey, the defaults will be:

- User: 123456
- Administrator: 12345678

### Disable YubiKey OTP

YubiKey has a proprietary OTP protocol that we currently do not use. It is generally recommended to turn this off to prevent accidental plaintext spam caused by touching the buttons on your YubiKey. You may be familiar with this if you have seen seemingly "random" messages from people on Slack such as `eerhtdgukfvhcetedhdejj`.

To turn this off, run the following commands:

```sh
ykman config usb --disable otp
ykman config nfc --disable otp
```

### Enable KDF (Recommended)

KDF is "Key Derived Format" - it means your PINs are transmitted and stored in a hashed format rather than in plaintext. This is optional but may harden your security posture.

The `kdf-setup` command may ask you for an Administrator PIN (the default is listed above). We will change this pin after enabling KDF, as this will reset the PINs anyway.

```sh
gpg --edit-card

gpg/card> admin
gpg/card> kdf-setup
```

### Set Maximum GPG Pin Entries

The YubiKey's GPG Application has a built-in mechanism to prevent brute-force attempts of the PIN. By default, this is set to `3 0 3` which represents:

- 3 Attempts of User PIN
- 0 Attempts of Reset PIN (Disabled by default)
- 3 Attempts of Administrator PIN

If the User PIN is entered incorrectly too many times, it must be unlocked using the Administrator PIN. If the Administrator PIN is entered too many times, the OpenPGP application on the YubiKey will be permanently locked and the key may need to be replaced or require a factory reset (which will remove stored keys).

We recommend setting these values to `10 10 10`. Increasing retry counts reduces the likelihood of accidentally locking yourself out while still making online brute-force attacks impractical for an attacker.

To set this, use the following command:

```
ykman openpgp access set-retries 10 10 10
```

### Set GPG User and Administrator PINs

Now you can set your User and Administrator PINs. If you enabled KDF earlier, this will have reset your PINs and you will need to set new ones here.

You will need to first confirm the "old" PINs - the Defaults are:

- User: 123456
- Administrator: 12345678

Note that whenever you are entering or setting a PIN in the terminal, it will be fully masked - you will not see any characters being output to the terminal when typing.

First, set your Admin PIN:

```sh
ykman openpgp access change-admin-pin

Enter Admin Pin: [12345678]
Enter New Admin Pin: [your new PIN here]
Confirm New Admin Pin: [confirm new PIN]
```

...and then set your User PIN:

```sh
ykman openpgp access change-pin

Enter User Pin: [123456]
Enter New Pin: [your new PIN here]
Confirm New Pin: [confirm new PIN]
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

Before generating the GPG key, set the key-attribute:

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

Now you have configured the basic settings for GPG, it is time to generate a GPG key:

```
gpg/card> generate
```

You may be asked to make a backup - say "no":

```
Make off-card backup of encryption key? (Y/n)
```

We strongly discourage backups as this increases security risk, as you would be allowing your private key to be exportable. We mitigate against this by suggesting you create a secondary key on a second YubiKey.

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

Once you have confirmed with "Okay", you should be asked to set a passphrase. Set this to something only you know and are happy to recite on a regular basis when prompted to use the key.

### Configure FIDO PIN

The FIDO pin will be used by the SSH process. We will need to set this before continuing - for simplicity, you may wish to set this as the same as your GPG User PIN:

```
ykman fido access change-pin
```

...then follow the instructions on screen.

### Configuring SSH to use the Yubikey

Once you have generated your key pair and set your FIDO PIN, set up SSH to use your GPG key. While this step will use ssh-keygen, all it is doing is creating a "pointer" to the Security Key (hence the -sk designation).

```
ssh-keygen -t ed25519-sk -O resident -O verify-required -C "Firstname Lastnamerson (GDS) <firstname.lastnamerson@digital.cabinet-office.gov.uk>"
```

If you encounter an error such as `"No FIDO SecurityKeyProvider specified"`, then head to the Troubleshooting part of this documentation for a solution.

Take note of the options above...

- `-O resident` instructs that the actual key is "resident" to the Security Key and is what should be used for signing.
- `-O verify-required` instructs that the key always requires touch "verification" each time it is to be used. If this option is omitted, the SSH client will not be forced to prompt the user (you) for a touch confirmation.

Optionally, if you want to store multiple SSH keys on a single YubiKey for some reason, you can differentiate between them by adding an extra option:

- `-O application=ssh:custom_name` overrides the FIDO2 application name so you can store more than one SSH key on the device. The default is just `ssh:`

During the creation process, you will be prompted to set a passphrase for the key and the filename to store the key - these are both optional. Normally we would recommend setting a passphrase, however, as this private key is a pointer to the credentials on the Security Key, the passphrase would be redundant.

Once the "pointer" file for the Security Key has been generated, the `ssh-keygen` command will output a path and filename of the new key. If you didn't change the defaults, the key files will be:

- Private Key (pointer): `id_ed25519_sk`
- Public Key: `id_ed25519_sk.pub`

Copy the path and filename and update your SSH config (located at `~/.ssh/config`) to add a block like this:

```
Host *
  IdentityFile /Users/firstname.lastnamerson/.ssh/id_ed25519_sk
  IdentitiesOnly yes
  IdentityAgent none
  AddKeysToAgent yes
```

This section will configure your SSH agent to use the Security Key for every connection you make, including for GitHub.

Make sure the `IdentityFile` property matches the name and path of your private key pointer. The default filename will be `id_ed25519_sk`. This instructs your SSH agent and Git to find and use the correct file.

### Configuring Git to use the SSH and Signing Keys

This is where we actually get to use the keys you have just generated. First we will configure authentication (via SSH) and then we will configure the Git client to sign all commits by default.

#### Configure Git to use your SSH Key

Once your SSH key is created and attached to the SSH agent, you will want to add the Public Key to your GitHub Profile.

- Go to your [GitHub Settings Page -> Access -> SSH and GPG keys](https://github.com/settings/keys).
- Click "New SSH key"
- Set the "Title" to something you can remember, e.g. "YubiKey SSH Key"
- Select "Key type" as "Authentication Key"
- Paste the contents of `~/.ssh/id_ed25519_sk.pub` into the "Key" field. Make sure this is the file ending in `.pub` and not the private key file.

Now this is done, you should be able to use your new key to pull and push to/from GitHub.

#### Configure Git to use your GPG Key

The next step will configure Git to sign your commits using your GPG key. This is to allow Git (and other users) to cryptographically verify that commits that were signed by your key came from you (and not an impersonator who has spoofed your email address).

First, you will need to find your key ID "fingerprint" from your YubiKey - run `gpg --card-status` to get something like this:

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

Note the key ID from the "sec" row, e.g. `A3F1E9C0B827D54E` and add it to your Git config in `~/.gitconfig` - make sure you have a config that looks like this:

```
[commit]
    gpgsign = true

[user]
    email = firstname.lastnamerson@digital.cabinet-office.gov.uk
    name = Firstname Lastnamerson
    signingkey = A3F1E9C0B827D54E
```

Now run this command from your terminal:

```
gpg --armor --export A3F1E9C0B827D54E
```

Take the output from this command and head back to [GitHub Settings Page -> Access -> SSH and GPG keys](https://github.com/settings/keys), scroll down to "GPG keys", then "New GPG key".

Again, set the "Title" to something you might find helpful and paste the Public Key Block (that was printed from the `gpg --armor --export` command earlier) into the "Key" field. GitHub will now be able to verify any commits you make as coming from your GPG key (and therefore probably from you).

### Setting Touch Preferences

You will want to set your touch preferences for when using your OpenPGP keys. The options are listed:

```
Off (default)  no touch required
On             touch required
Fixed          touch required, can't be disabled without deleting the private key
Cached         touch required, cached for 15s after use
Cached-Fixed   touch required, cached for 15s after use, can't be disabled
               without deleting the private key
```

We recommend the "Cached" option because it balances security and usability: it requires a touch when the key is first used and then gives 15 seconds of "grace" where the key will not prompt for another touch. If you would prefer higher assurance, you can use one of the other options.

Assuming you want to use the "Cached" option, this is how you set it for each of the PGP actions:

```
ykman openpgp keys set-touch sig cached
ykman openpgp keys set-touch dec cached
ykman openpgp keys set-touch aut cached
ykman openpgp keys set-touch att cached
```

### Testing your credentials and finishing-up

Now you have a hardware-backed key for authenticating with Git, SSH and GPG, you can test that your new key is working by disabling your old keys. The easiest way to do this is to set the file permissions of your old keys to `000`. For example, from your terminal:

```sh
cd ~/.ssh

ls -al

total 80
drwx------@ 11 firstname.lastnamerson  staff   352 22 Sep 14:40 .
drwxr-x---+ 64 firstname.lastnamerson  staff  2048 13 Oct 18:01 ..
-rw-------@  1 firstname.lastnamerson  staff   129 23 Sep 11:23 config
-rw-------@  1 firstname.lastnamerson  staff  2602 12 Jul  2023 google_compute_engine
-rw-------@  1 firstname.lastnamerson  staff   573 12 Jul  2023 google_compute_engine.pub
-rw-------@  1 firstname.lastnamerson  staff   436  1 Nov  2023 google_compute_known_hosts
-rw-------@  1 firstname.lastnamerson  staff   517 22 Sep 14:07 id_ed25519_sk
-rw-r--r--@  1 firstname.lastnamerson  staff   193 22 Sep 14:07 id_ed25519_sk.pub
-rw-------@  1 firstname.lastnamerson  staff   854 12 Jan 11:03 id_rsa
-rw-r--r--@  1 firstname.lastnamerson  staff   287 12 Jan 11:03 id_rsa.pub
-rw-------@  1 firstname.lastnamerson  staff  5720 19 Feb  2025 known_hosts

chmod 000 id_rsa
```

Now try to make an SSH connection to GitHub:

```
ssh -T git@github.com

Confirm user presence for key ED25519-SK SHA256:lrBwbswEEkWqyXAbd6WEPv9I++fSJdvkln1vlDkoFzs
Enter PIN for ED25519-SK key /Users/firstname.lastnamerson/.ssh/id_ed25519_sk:
Confirm user presence for key ED25519-SK SHA256:lrBwbswEEkWqyXAbd6WEPv9I++fSJdvkln1vlDkoFzs
User presence confirmed
Hi firstname-lastnamerson! You've successfully authenticated, but GitHub does not provide shell access.
```

If this worked, you have successfully set up a YubiKey for authentication with GitHub and commit signing. Now you should go and create a backup set of credentials with a second YubiKey which you can store in a safe place.

You may also want to go back and delete or revoke any old credentials that you do not plan to use any longer.

### Other useful commands

- `ykman fido credentials list` - List Resident Credentials (Keys)

## Setting up a YubiKey without `ykman`

If you are on a "non-tech" MacBook, then (at the time of writing) you will likely not be able to access the Mac terminal and therefore cannot use `git`, `ykman` or `gpg` from the terminal. If you are one of these people, you will be limited to what the Yubico Authenticator can support, which is management of OTP (TOTP MFA) codes and FIDO (Passkeys).

You will be able to set a Password (or PIN) for your OTP Codes, or a PIN for your Passkeys by using the Yubico Authenticator app.

## Set up a YubiKey as an MFA device for AWS

1. [Sign into the `gds-users` AWS account](https://gds-users.signin.aws.amazon.com/console).
2. Select your email address in the top-right corner of the page.
3. Choose __Security credentials__ from the drop-down menu.
4. Scroll down to the __Multi-factor authentication (MFA)__ section and select __Assign MFA device__.
5. Specify your email address as the MFA device name.
6. Select __Authenticator app__, not __Passkey or security key__.
7. Click to reveal the TOTP Token.
8. Use the command `ykman oath accounts add -t gds-users` and paste the TOTP Token in. The `-t` option forces touch verification.
9. Use the command `ykman oath accounts code gds-users` to generate two consecutive codes and then __Save__.
10. Configure gds-cli to use the YubiKey:

    ```
    gds config yubikey true
    ```

11. Go back to the __Security credentials__ page and add the YubiKey again as a second MFA device, but choose __Passkey or security key__ this time.

You have now:

- added your YubiKey as a U2F/FIDO2 Security Key for logging into the AWS web console more securely and conveniently
- added your YubiKey as a legacy OATH MFA device for compatibility with gds-cli/aws-vault on the command line

> ⚠️ Now that you have an unphishable Security Key as an MFA device, you should never type or copy/paste the 6-digit OATH one-time codes. They're only for use via the gds-cli/aws-vault.
>
> Always use the __Security Key__ option and not the legacy Authenticator app option when signing into the AWS web console, to reduce the risk of phishing attacks.

## Troubleshooting

### "MFA device already exists"

If you get this error message when trying to set up your MFA token on AWS:

```
MFA device already exists
```

This is because gds-users has an IAM policy requiring your Authenticator app device name to match your gds-users username. You should make sure that:

- Your main/primary YubiKey is the one configured for the "Authenticator app" setting.
- You create Passkeys on each YubiKey or Security Key you want to use, so you can log into gds-users at any time and swap or replace the "Authenticator app" if needed.

### "Not authorized to perform iam:CreateVirtualMFADevice"

If you get this error message when trying to set up your MFA token on AWS:

```
User: arn:aws:iam::123456789012:user/firstname.lastnamerson@digital.cabinet-office.gov.uk is not authorized to perform: iam:CreateVirtualMFADevice on resource: arn:aws:iam::123456789012:mfa/abc123 because no identity-based policy allows the iam:CreateVirtualMFADevice action
```

You need to make sure that your Authenticator app name is set to your email address (the same as your gds-users username), .e.g.

```
firstname.lastnamerson@digital.cabinet-office.gov.uk
```

### "No FIDO SecurityKeyProvider specified"

If you get this error message when trying to generate your SSH Key:

```
No FIDO SecurityKeyProvider specified
Key enrollment failed: invalid format
```

This is because the default OpenSSH client bundled with macOS does not support Hardware Security Keys. You will need to override this so the version installed by Homebrew takes precedence. [Follow this GitHub Gist for a solution](https://gist.github.com/BertanT/9d222da115ca2d1274ef34735c4260cf).
