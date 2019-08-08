---
owner_slack: "#govuk-2ndline"
title: Connect to vCloud Director (Carrenza only)
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-08-08
review_in: 6 months
---

vCloud Director is the interface we use to manage our infrastructure in Carrenza.
This includes virtual machines, gateways, firewalls and VPNs between providers.

To access vCloud Director, you will need to connect to a Carrenza-provided VPN.
You can use either Cisco AnyConnect or OpenConnect as a VPN client for this.

## Setting up the Cisco AnyConnect VPN profile on a Mac

1. Clone the govuk-secrets private Git repo. The repo is very large but there is no need to download the full history.
```
mkdir -p ~/govuk && cd ~/govuk
git clone --depth 10 git@github.com:alphagov/govuk-secrets.git
```
2. Get the VPN client certificate and private key from the 2nd line [password store](https://github.com/alphagov/govuk-secrets/tree/master/pass) and save the decrypted contents to a file on your machine (for example ~/carrenza-vpn-cert-and-key.pem).
```
cd govuk-secrets/pass
export PASSWORD_STORE_DIR=2ndline
pass carrenza/vpn-certificate >~/carrenza-vpn-cert-and-key.pem
```
3. Get the VPN credentials, also from the 2nd line password store.
```
pass carrenza/vpn-credentials
Certificate passphrase: ...
MFA key: ................
Password: ...
VPN gateway: ...
```
4. Add the MFA key to an app such as Google Authenticator. This will be your second factor for logging into the Carrenza VPN.
5. Convert the VPN client certificate from PEM format to PFX format by running
   `openssl pkcs12 -export -in ~/carrenza-vpn-cert-and-key.pem -out carrenza-vpn-cert-and-key.pfx`.
   You'll be asked for two passwords (one for decrypting the PEM and one for encrypting the PFX). The first one is the `Certificate passphrase` field from `carrenza/vpn-credentials`. You can choose the second one, or use the same as the first.
```
openssl pkcs12 -export -in ~/carrenza-vpn-cert-and-key.pem -out ~/carrenza-vpn-cert-and-key.pfx
Enter pass phrase for /Users/.../carrenza-vpn-cert-and-key.pem: <Certificate passphrase from vpn-credentials>
Enter Export Password: <Password from vpn-credentials>
Verifying - Enter Export Password:
```
6. Import the PFX format certificate into your OS X login keychain by running
   `security import ~/carrenza-vpn-cert-and-key.pfx`.
   You'll be asked for a password. Enter the passphrase which you used to encrypt the PFX file (`Certificate passphrase` field from `carrenza/vpn-credentials`).
7. Create a new file on your machine at `/opt/cisco/anyconnect/profile/carrenza-secure.xml`.
   and copy the following XML into that file:

```
cat <<EOF >~/carrenza-secure.xml
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
EOF
sudo cp ~/carrenza-secure.xml /opt/cisco/anyconnect/profile/
```
8. Restart Cisco AnyConnect if it's already running.
9. Delete the key files created earlier as these are no longer needed. (The PEM file is needed if you plan to use OpenConnect, however.)
```
rm ~/carrenza-vpn-cert-and-key.{pem,pfx}
```

## Connecting with Cisco AnyConnect
1. Choose "Carrenza - Secure" from the drop down list and click "Connect". The very first time you connect, you may be asked (multiple times) for your Mac OS X username and password (that is, your LDAP username and password). This is for AnyConnect to store credentials in the System keychain and to read the key and certs which you imported into your account keychain. Press Always Allow when the option appears.
2. The first password is the second-factor (MFA) code. The second password is the VPN password. (Yes, they're the opposite way around compared to the GDS VPN.)

## Connecting with OpenConnect

1. Run `sudo openconnect https://secure.carrenza.com -c ~/carrenza-vpn-cert-and-key.pem`.
   Make sure you provide the correct path to where you've saved the VPN client certificate.
2. The first password is your machine password (requested by sudo).
3. The second password (the PEM passphrase) is the certificate passphrase from the password store.
4. The third password is the 2FA code.
5. The fourth password is the password from the password store.

## Accessing vCloud Director

1. Fetch the VCloud Director credentials for the environment which you want to connect to.
```
cd govuk-secrets/pass
export PASSWORD_STORE_DIR=2ndline
pass carrenza/vcloud-integration
......... <a long string which is the VCloud Director password>
User: <username for logging into VCloud Director>
Org: <this string goes in the URL path for accessing VCloud Director>
```
2. Ensure that you are connected to the Carrenza VPN (see above).
3. Visit https://vcloud.carrenza.com/cloud/org/{organisation}/ (replacing {organisation} with the value of the `Org` field from the password store entry.
4. Log in with the username and password from the password store entry.
