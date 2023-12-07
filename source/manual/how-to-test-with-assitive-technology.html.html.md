---
owner_slack: "#govuk-frontenders"
title: How to test with Assistiv Labs
section: Frontend
layout: manual_layout
parent: "/manual.html"
---

GOV.UK has to meet government [accessibility requirements](https://www.gov.uk/service-manual/helping-people-to-use-your-service/making-your-service-accessible-an-introduction), digital services must work on the most commonly used assistive technologies - including screen magnifiers, screen readers and speech recognition tools

[Assistiv Labs](https://assistivlabs.com/) remotely connects you to real assistive technologies, like NVDA, JAWS, and Windows High Contrast Mode, using any modern web browser.

## Get set up

Contact the Head of Frontend or a Lead Frontend Developer to request an account.

## Local testing with AssistivTunnel

AssistivTunnel is a small command line interface (CLI) that creates a secure connection between your computer and virtual machines or mobile devices running in Assistiv Labs, which enables you to test...

- Any site or server running on `localhost`
- Internal staging servers that may require VPN

[How to get set up with AssistivTunnel](https://assistivlabs.com/support/assistivtunnel)

## Using Assistiv Labs

We have been assured by Assistiv Labs that the Virtual Machine (VM) is deleted when you exit, however in the interests of security and to make sure we do not leak any personal data or sensitive material:

- treat the VM you are using as if it was a shared device – like using a public computer in an internet cafe or library
- do not use it to test any confidential or secret service, or services containing content that is considered sensitive
- do not use any credentials from live systems with access to "real data" during your testing
- do not sign in to any accounts, unless those accounts are used solely for the purposes of testing (for example, a test account in an integration or staging environment)
- make configuration changes to the system through your own device rather than the VM

You should also make sure you understand how using the service affects any other requirements for your service, such as PCI (Payment Card Industry) compliance, and assess any additional risks. You can speak to your service's information assurance lead or the GDS Privacy Team for specific guidance.

[Read more within the GDS Way](https://gds-way.digital.cabinet-office.gov.uk/manuals/accessibility.html#testing-with-assistive-technologies)
