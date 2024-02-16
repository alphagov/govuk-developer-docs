---
owner_slack: "#govuk-developers"
title: Set up a YubiKey
description: Guide for setting up and using a YubiKey
layout: manual_layout
section: Security
---

## Set up a YubiKey as an MFA device for AWS

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
