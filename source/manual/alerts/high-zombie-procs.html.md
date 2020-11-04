---
owner_slack: "#govuk-2ndline"
title: High zombie procs
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

You can check what the zombie processes are by SSHing onto the machine
and running the command:

```
ps -A -o user,pid,ppid,state,cmd | awk 'NR==1 || $4=="Z" { print }'
```

The `PPID` field gives you the parent process ID, which you may be able
to use to diagnose what caused the problem, or at least which process to
restart.

If there are a number of zombie processes on one of the backend machines,
restarting Imminence (with `sudo service imminence restart`) may fix the
problem; if that doesn't help, reboot the machine at a convenient time.
