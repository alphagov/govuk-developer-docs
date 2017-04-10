---
title: Jenkins Swarm Plugin
section: Testing
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/introductions/jenkins-slave-swarm.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/introductions/jenkins-slave-swarm.md)


# Jenkins Swarm Plugin

Plugin page: <https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin>

We use the Jenkins Swarm Plugin in our GOVUK CI environment. It allows
us to set up a network of Jenkins slaves without having to tell the
master all the details. Each slave instigates the relationship and
reaches out to the master.

## Master and slave Jenkins communication

> -   Slave makes a UDP broadcast looking for a master (upd 33848),
> -   Slave listens for a reply on a ephemeral udp user port (in the
>     range of 32768:65535)
> -   Master's reply contains its URL in return (the Jenkins URL set in
>     the Jenkins main config page)
> -   
>
>     Slave connects to master on url security details given by the slave and then they connect up
>
>     :   as jenkins master and slaves normally do using a ephemeral tcp
>         port on the master.
>
Note These conversations are in the open and unsecured, but the slaves
have a user and an API key to validate themselves against the Master
that is generated per Jenkins master instance.

## Debugging connection problems

Slave connection log can be found in: /var/log/upstart/jenkins-slave.log
(default upstart logging location)
