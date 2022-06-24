---
owner_slack: "#govuk-2ndline-tech"
title: GOV.UK and Virtual Private Networks (VPNs)
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

## VPN between AWS and UKCloud for Licensify Civica payment status requests

There's a VPN between AWS Production (only) and UKCloud Production which exists
only as a workaround for routing certain requests from Licensify to Civica, one
of Licensify's payment gateways. This is undesirable and [recorded as
GOV.UK Tech Debt][tech-debt-card].

[tech-debt-card]: https://trello.com/c/CG5mc7Zi/213-licensify-connection-to-civica-still-goes-via-uk-cloud-and-vpn-from-aws

If this VPN is down:

* The [check_uk_cloud_vpn_up](https://alert.production.govuk.digital/cgi-bin/icinga/status.cgi?search_string=vpn.*licensify) alert will fire in Icinga.
* Users who are paying for licence applications to certain licencing authorities will still be able to complete their application but the last step of their journey will display a message saying "We have received your application, but were unable to confirm payment with the authority." ([source](https://github.com/alphagov/licensify/blob/master/frontend/app/views/licensing/payments/unknown.scala.html))
* The page still gives the user a reference number for their transaction and asks the user to contact the licencing authority to confirm that they have received the payment.
* Payments will still be processed as normal. The only difference is that Licensify is unable to tell the user whether the payment went through or not.
* Only those licencing authorities which use Civica as their payment processor are affected. This is a small but significant minority.
* Licencing authorities who do not use Civica are not affected.

### Troubleshooting Steps

Troubleshooting steps (aim is to switch off and on the VPN):

1. Go to Production Skyscape portal, the credentials are in GOV.UK 2ndline Pass under: `ukcloud/portal`.
2. Once you logged in, you have to log into the `Production` organization by selecting: `VMWARE CLOUD` and then `GOV.UK Production`. You will be asked for the password again.
3. In the `Production` organization, go to the `GOV.UK Management` virtual datacenter.
4. Click `edges` in the left column to bring the list of edges.
5. Click on the `GOV.UK Management` edges in the right main frame and `Services` above it.
6. In the pop-up window, click on `VPN` in the menu bar and then `IPsec VPN Sites`
7. In the list of VPN sites, select `UKC Licensify to AWS` VPN and click on the edit icon above.
8. In the new pop-up window, turn the VPN off by toggling the `enable` switch and clicking `KEEP`
9. The pop-up window will disappear and you need to click `save changes` in put into effect the VPN being now disabled.
10. Wait a few minutes and repeat step 7-9 to re-enable the VPN again.
