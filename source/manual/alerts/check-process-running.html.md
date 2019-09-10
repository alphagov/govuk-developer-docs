---
owner_slack: "#govuk-2ndline"
title: Check process running
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-10
review_in: 6 months
---

This alert means that a process which should be running is not.

It's likely that this process corresponds to a service, which you can check by looking in `/etc/init` or try running:

```bash
$ sudo service <process> status
```

This will also tell you the status of the service.

You can list all available services with `sudo service --status-all`.

If you cannot immediately find which service the process is corresponding to, it may be helpful to look through any
similar looking files in `/etc/init`, for example, the `postgresql` service runs the `postgres` process.

Often, it can be enough to just restart the service by using:

```bash
sudo service <service> start
```

If the service is referring to a GOV.UK application, it may be necessary to also restart the Procfile worker:

```bash
sudo service <service>-procfile-worker restart
```

If the process doesn't correspond to a service then it will be necessary to find out more about how the process runs.

If the process doesn't come back, then it's more likely that there is something going wrong with it. You can start
investigating by looking in the log files which could be in one of the following places:

- `/var/log/upstart/<process>.log`
- `/var/log/<process>/`
- `/var/log/<process>.log`
