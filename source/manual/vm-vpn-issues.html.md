---
owner_slack: "#govuk-dev-tools"
title: Access the VM after using the VPN
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-13
review_in: 6 months
---

## Using the GDS VPN

Using Cisco AnyConnect will prevent traffic to *.dev.gov.uk from the host (i.e.
your machine) reaching the guest (i.e. the VM).

After disconnecting from the VPN, the routing can be restored using the following:

```
mac$ sudo ifconfig vboxnet0 delete 10.1.1.1
mac$ sudo ipconfig set vboxnet0 manual 10.1.1.1
```

