---
owner_slack: "#govuk-developers"
title: Setup a Yubikey
description: Guide for setting up and using a Yubikey
layout: manual_layout
section: Security
---

## Setup as an MFA device for AWS

1. Download the [Yubico Authenticator](https://www.yubico.com/products/yubico-authenticator/) app to your computer (or mobile device, if your Yubikey supports NFC).
1. Sign in to the [`gds-users` AWS console][gds-users-aws-signin].
1. Select the __IAM__ service.
1. Select __Users__ in the left hand menu and enter your name.
1. Select the link for your email address.
1. Select the __Security credentials__ tab.
1. Select __Manage__, which is next to __Assigned MFA device__.
1. Specify your email address as the MFA device name
1. Select "Authenticator app", not "Security Key"
1. When asked to scan the QR code with your mobile device, open the Yubico Authenticator app and use that to scan the QR code. The MFA code will now be present on your Yubikey.
1. Configure gds-cli to use the YubiKey:

```
gds config yubikey true
```
