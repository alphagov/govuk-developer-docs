---
owner_slack: "#2ndline"
title: Varnish port not responding
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2016-11-16
review_in: 6 months
---

# Varnish port not responding

Under high load, it is possible that the Varnish child process which
handles connections will timeout on the healthcheck from the parent. If
that happens and the replacement child process also fails to start,
varnish can get in a state where it is not responsive.

The 'varnish port not responding' check simply attempts to contact
<http://localhost:7999/> and get a response. If it doesn't, then it will
raise an urgent alert as this might lead to 1/3 of user requests
failing.

To diagnose, you should see messages like this:

    $ fab $environment -H cache-3.router sdo:'grep varnishd /var/log/messages'
    [cache-3.router] out: Jul  7 00:17:02 cache-3 varnishd[1620]: Child (1630) died signal=3
    [cache-3.router] out: Jul  7 00:17:03 cache-3 varnishd[1620]: child (27973) Started
    [cache-3.router] out: Jul  7 00:17:25 cache-3 varnishd[1620]: Child (27973) said Child starts
    [cache-3.router] out: Jul  7 00:17:25 cache-3 varnishd[1620]: Child (27973) said Child dies
    [cache-3.router] out: Jul  7 00:17:25 cache-3 varnishd[1620]: Child (27973) died status=1

And you should see only one process called /usr/sbin/varnishd in the
process table, with owner root. The child process if it exists will be
owned by nobody:

    $ fab $environment -H cache-3.router do:'ps -ef | grep [/]usr/sbin/varnishd'
    [cache-3.router] out: root      8273     1  0 06:08 ?        00:00:00 /usr/sbin/varnishd -P /var/run/varnishd.pid -a :7999 -f /etc/varnish/default.vcl -T 127.0.0.1:6082 -t 900 -w 1,1000,120 -S /etc/varnish/secret -s malloc,5985M
    [cache-3.router] out: nobody    8277  8273  1 06:08 ?        00:03:52 /usr/sbin/varnishd -P /var/run/varnishd.pid -a :7999 -f /etc/varnish/default.vcl -T 127.0.0.1:6082 -t 900 -w 1,1000,120 -S /etc/varnish/secret -s malloc,5985M

And you can check whether there are any children of the current parent
process (this check will fail where it succeeds below):

    $ fab $environment -H cache-3.router do:'/usr/lib/nagios/plugins/check_procs -c 1:1 -C 'varnishd' -p `< /var/run/varnishd.pid`''
    [cache-3.router] out: PROCS OK: 1 process with command name 'varnishd', PPID = 8273

### To resolve varnish port not responding

You just need to restart varnish on this machine:

    $ fab $environment -H cache-3.router cache.restart

### Varnish high memory consumption

**Caution** Talk to someone from webops/infrastructure first.

Varnish can be restarted with the fab task:

fab \$environment cache.restart

This isn't graceful and will stop and start varnish across the cache
machines which can result in a spike in request volume to the
applications and possibly errors.

