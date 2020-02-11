---
owner_slack: "#re-govuk"
title: Connect to vCloud Director (Carrenza only)
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-26
review_in: 6 months
---

vCloud Director is the interface we use to manage our infrastructure in
Carrenza. This includes virtual machines, gateways, firewalls and VPNs between
providers.

To access vCloud Director, you will need to connect to a Carrenza-provided VPN.
You can use either Cisco AnyConnect or OpenConnect as a VPN client for this.

## Setting up the Cisco AnyConnect VPN profile on a Mac

1. Make sure you have the latest version of [govuk-secrets][].

1. Install `oathtool` (this will be used to generate one time passwords).

   ```sh
   $ brew install oath-toolkit
   ```

1. Get the VPN client certificate and private key from the 2nd line
   [password store](https://github.com/alphagov/govuk-secrets/tree/master/pass)
   and save the decrypted contents to a file on your machine (for example
     `~/carrenza-vpn-cert-and-key.pem`).

    ```sh
    $ PASSWORD_STORE_DIR=~/govuk/govuk-secrets/pass/2ndline pass carrenza/vpn-certificate > ~/carrenza-vpn-cert-and-key.pem
    ```

1. Get the VPN credentials, also from the 2nd line password store.

    ```sh
    $ PASSWORD_STORE_DIR=~/govuk/govuk-secrets/pass/2ndline pass carrenza/vpn-credentials
    Certificate passphrase: ...
    MFA key: ................
    Password: ...
    VPN gateway: ...
    ```

1. Convert the VPN client certificate from PEM format to PFX format. You will
   be asked for two passwords (one for decrypting the PEM and one for
   encrypting the PFX). The first password is the `Certificate passphrase`
   field from `carrenza/vpn-credentials`. The second password can be of your
   own choice. You will need it for the next few steps but you won't need to
   remember it after that.

    ```sh
    $ openssl pkcs12 -export -in ~/carrenza-vpn-cert-and-key.pem -out ~/carrenza-vpn-cert-and-key.pfx
    Enter pass phrase for /Users/.../carrenza-vpn-cert-and-key.pem: <Certificate passphrase from vpn-credentials>
    Enter Export Password: <Password from vpn-credentials>
    Verifying - Enter Export Password:
    ```

1. Import the PFX format certificate into your macOS login keychain. You'll be
   asked for a password. Enter the passphrase which you used to encrypt the PFX
   file (`Certificate passphrase` field from `carrenza/vpn-credentials`).

   ```sh
   $ security import ~/carrenza-vpn-cert-and-key.pfx
   ```

1. Delete the PFX file as it is no longer needed.

    ```sh
    $ rm ~/carrenza-vpn-cert-and-key.pfx
    ```

## Connecting with OpenConnect

1. Install OpenConnect: `brew install openconnect`
1. Run OpenConnect. Make sure you provide the correct path to where
   you've saved the VPN client certificate.

   ```sh
   $ sudo openconnect https://secure.carrenza.com -c ~/carrenza-vpn-cert-and-key.pem
   ```

1. The first password is your machine password (requested by sudo).
1. The second password (the PEM passphrase) is the certificate passphrase from
   the password store.
1. The third password is the 2FA code (use `oathtool -b
   <MFA-key-from-password-store> --totp`).
1. The fourth password is the password from the password store.

## Accessing vCloud Director

1. Fetch the VCloud Director credentials for the environment which you want to
   connect to.

    ```sh
    $ PASSWORD_STORE_DIR=~/govuk/govuk-secrets/pass/2ndline pass carrenza/vcloud-integration
    ......... <a long string which is the VCloud Director password>
    User: <username for logging into VCloud Director>
    Org: <this string goes in the URL path for accessing VCloud Director>
    ```

1. Ensure that you are connected to the Carrenza VPN (see above).

1. Visit https://vcloud.carrenza.com/tenant/{organisation}/ (replacing
   {organisation} with the value of the `Org` field from the password store
   entry.

1. Log in with the username and password from the password store entry.

[govuk-secrets]: https://github.com/alphagov/govuk-secrets
