---
title: 'rkhunter warnings'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# rkhunter warnings

rkhunter (Rootkit Hunter) is software installed on our machines to
detect potential rootkits and exploits. rkhunter runs every morning
across our machines.

In most cases you could verify that the warning is something we expect
to be happening on our machines and then acknowledge it.

If we miss the schedule on Integration (e.g. if Jenkins doesn't start
the servers up on time), we get a 'freshness threshold' warning for each
machine. It's possible to resolve this across all machines in an
environment by running rkhunter via a fabric script, e.g.:

    fab integration all rkhunter

If this encounters an error while running, it's useful to continue
running rkhunter only on those machines that are still reporting this
warning.:

    fab integration vm.nagios.loadhosts:rkhunter rkhunter

If the warning shows `rkhunter definitions not updated`, then you need
to update the definitions.:

    fab integration all rkhunter.update

