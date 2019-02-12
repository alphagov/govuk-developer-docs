---
owner_slack: "#govuk-2ndline"
title: Connect to vCloud Director (Carrenza only)
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-02-12
review_in: 6 months
---

vCloud Director is the interface we use to manage our infrastructure in Carrenza.
This includes virtual machines, gateways, firewalls and VPNs between providers.

To access vCloud Director, you will need to connect to a Carrenza-provided VPN.
You can use either Cisco AnyConnect or openconnect to do this.

## Prerequisites

1. Get the VPN client certificate from the [2nd line password store](https://github.com/alphagov/govuk-secrets/blob/master/pass/2ndline/carrenza).
2. Save the certificate to a file on your machine (eg. `vcloud.pem`).
3. Get the VPN credentials, also from the 2nd line password store.
   You'll need to use an app (such as Google Authenticator) to turn the TOTP
   secret into a 2FA code.

## Connecting with Cisco AnyConnect

1. Convert the VPN client certificate from PEM format to PFX format by running
   `openssl pkcs12 -export -in vcloud.pem -out vcloud.pfx`. You'll be asked for
   two passwords. For the first one, enter the VPN password, and for the second
   one, enter the certificate passphrase.
2. Import the PFX format certificate into your Keychain by running
   `security import vcloud.pfx -k ~/Library/Keychains/login.keychain-db`.
   You'll be asked for a password. Enter the certificate passphrase.
3. Create a new file on your machine at `/opt/cisco/anyconnect/profile/carrenza-secure.xml`.
   and copy the following XML into that file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<AnyConnectProfile xmlns="http://schemas.xmlsoap.org/encoding/">
  <ServerList>
    <HostEntry>
      <HostName>Carrenza - Secure</HostName>
      <HostAddress>https://secure.carrenza.com</HostAddress>
      <PrimaryProtocol>SSL</PrimaryProtocol>
    </HostEntry>
  </ServerList>
</AnyConnectProfile>
```

4. Restart Cisco AnyConnect if it's already running.
5. Choose "Carrenza - Secure" from the drop down list and click "Connect".
6. The first password is the 2FA code.
7. The second password is the VPN password.

## Connecting with openconnect

1. Run `sudo openconnect https://secure.carrenza.com -c vcloud.pem`.
   Make sure you provide the correct path to where you've saved the VPN client certificate.
2. The first password is your machine password (requested by sudo).
3. The second password (the PEM pass phrase) is the VPN password
   (note, this is **not** the certificate passphrase).
4. The third password is the 2FA code.
5. The fourth password is the same password as in step 3.

## Accessing vCloud Director

Once you've connected to the VPN, visit https://vcloud.carrenza.com/cloud/org/<organisation>/.
You can get the organsation name from the 2nd line password store entry for the relevant
vCloud environment.
