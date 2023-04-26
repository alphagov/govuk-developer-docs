---
owner_slack: "#govuk-2ndline-tech"
title: How to flush the ARP cache
parent: "/manual.html"
layout: manual_layout
section: 2nd line
---

> These instructions should no longer be required. Please alert #govuk-platform-security-reliability-team if you have to use them.

We're aware of a rare situation where our servers can find themselves with
incorrect entries in their ARP cache (more detail below in [What is the ARP
cache?](#what-is-the-arp-cache) and [What is wrong with our ARP cache?](#what-is-wrong-with-our-arp-cache))

This causes the connection issues between the affected servers and some of the
internal APIs they call. The issues usually happen shortly after a spike in
traffic.

For example, in a recent incident our frontend servers couldn't connect to
content-store. We could reproduce this in an ssh session with:

```
$ curl --verbose https://content-store.production.govuk-internal.digital/content/vat-rates
* Hostname was NOT found in DNS cache
*   Trying 10.13.4.67...
* connect to 10.13.4.67 port 443 failed: Connection timed out
*   Trying 10.13.5.93...
* Connected to content-store.production.govuk-internal.digital (10.13.5.93) port 443 (#0)
```

The key line here is `connect to 10.13.4.67 port 443 failed: Connection timed
out` - if you see connection failures like this to a particular IP address it's
possible that there's an issue with the ARP cache.

If you suspect an issue with the ARP cache, flushing it is easy to do and
doesn't carry much risk.

## Flushing the ARP cache

Before you decide to flush the ARP cache, try to reproduce the connection issue
with curl. For example, on a frontend machine that's having connection issues
with content-store:

```
$ curl --verbose https://content-store.production.govuk-internal.digital/
```

Once you've reproduced the connection issue, flush the ARP cache with:

```
$ sudo ip neigh flush all
```

Then try to connect to the service you were having connection issues with again:

```
$ curl --verbose https://content-store.production.govuk-internal.digital/
```

If this succeeds, then it's extremely likely the instance was having issues
with its ARP cache.

If there are other machines with similar issues, you should flush the cache on
those too.

> Related: [how to run ssh commands on many machines](/manual/howto-run-ssh-commands-on-many-machines.html)

## What is the ARP cache?

Address Resolution Protocol (ARP) resolves IP addresses into MAC addresses. The
ARP cache keeps track of the mapping between IP addresses and MAC addresses.

If none of that makes any sense to you, there is a good explanation of the
underlying networking concepts in [Julia Evans' Networking! Ack! Zine](https://jvns.ca/networking-zine.pdf).

## What is wrong with our ARP cache?

Linux is supposed to manage the ARP cache invisibly, so developers should never
have to think about it. Unfortunately it seems that some versions of the Linux
kernel [have bugs which can occasionally mean things go wrong with the ARP
cache](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1715812).

As of February 2022 we're discussing how to work around these issues, but in the
meantime this document covers how to manually fix the issues.
