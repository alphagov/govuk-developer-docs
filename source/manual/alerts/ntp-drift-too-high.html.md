---
title: 'ntp drift too high'
parent: /manual.html
layout: manual_layout
section: Alerts
---

# 'ntp drift too high'

There are tasks in fabric-scripts to make this less painful:

    fab $environment -H jumpbox-1.management ntp.status
    fab $environment -H jumpbox-1.management ntp.resync

