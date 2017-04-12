---
owner_slack: '#2ndline'
review_by: 2017-05-08
title: 'defined cpu type does not match'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# defined cpu type does not match

We have two types of VM hosts that use either Intel or AMD processors.
Some VMs have significant performance degradation when on the AMD CPUs
and thus should live on the more performant Intel processor-based hosts.

If an alert reports that the defined CPU model name does not match what
it has been defined with, we should firstly try to find out why (has the
machine been recently rebuilt or vMotioned?) and then migrate the VM to
the correct host.

