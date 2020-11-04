---
owner_slack: "#govuk-2ndline"
title: Check process running
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
---

This alert means that a process which should be running is not. It's highly likely that this process corresponds to a service.

If the process doesn't correspond to a service then it will be necessary to find out more about how the process runs. Read [troubleshooting the process](#troubleshooting-the-process) at the end of this page.

## Check the status of the service

```bash
$ sudo service <process> status
```

If this doesn't work, you may need to do some digging to find out the name of the service. For example, the `postgresql` service runs the `postgres` process.

### Determining the name of the service

Look in `/etc/init` for services that may be in charge of the process.

You can also list services with `sudo service --status-all`, though this doesn't show processes started with [upstart](http://upstart.ubuntu.com/).

## Fixing the issue

If the service isn't running, it can be enough to just restart the service by using:

```bash
sudo service <service> start
```

If the service is referring to a GOV.UK application, it may be necessary to also restart the Procfile worker:

```bash
sudo service <service>-procfile-worker restart
```

Sometimes, a process might appear to be running, but is actually stalled by a child process that has completed but not been garbage collected:

```bash
$ ps -ef | grep defunct
root      2735     1  0 Jun08 ?        00:02:09 [prometheus] <defunct>
```

You can confirm this is a child process of the process in the alert by running `ps faux` to see where it is descended from.

Running `sudo service <service> restart` should bring the process down, kill of any child processes and start it up again, but if the defunct process is still hanging around (and especially if its parent process is now `init`/`1`), you may need to [reboot the machine](/manual/alerts/rebooting-machines.html).

## Troubleshooting the process

If the process doesn't come back, then it's more likely that there is something going wrong with it. You can start
investigating by looking in the log files which could be in one of the following places:

- `/var/log/upstart/<process>.log`
- `/var/log/<process>/`
- `/var/log/<process>.log`

If you see something in the logs such as

```bash
---> Spinning up 'govuk_crawler_worker' (type bare) in 'production' environment
/usr/local/bin/govuk_spinup: 30: cd: can't cd to /var/apps/govuk_crawler_worker
```

This suggests that the crawler hasn't been deployed to the machine. You can try re-deploying
via [deploy jenkins](https://deploy.blue.staging.govuk.digital/).
