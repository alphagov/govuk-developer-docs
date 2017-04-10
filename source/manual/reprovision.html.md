---
title: Reprovision a machine in vCloud Director
section: howto
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/reprovision.md"
---



> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/reprovision.md)


# Reprovision a machine in vCloud Director

Make sure you are aware what the consequences will be of removing a
machine from the rotation and consider who needs to be aware of
potential downtime.

## Steps

1.  Schedule downtime for your host in Icinga using our [Fabric
    scripts](https://github.com/alphagov/fabric-scripts). This will
    prevent Icinga from alerting while you reprovision the machine:

        fab $environment nagios.schedule_downtime:mybox-2.somevdc.production,20

2.  Stop the machine in the vCloud Director using the Flash UI.
3.  Delete the machine in the vCloud Director.
4.  Remove the certificate for the relevant machine on the
    organisation's puppetmaster, e.g.

        sudo puppet cert clean mybox-2.somevdc.production

5.  Ensure that the Puppet master will sign the certificate for the
    newly reprovisoned VM; after 5 minutes the Puppet client will
    timeout and you would need to initiate the signing request
    again manually.

    An easy way to do this is to run the following loop on
    `puppetmaster-1.management` and monitor the output:

        screen
        while true; do sudo puppet cert sign --all; sleep 10; done

    Don't forget to kill the screen(1) session when you're done.

6.  Reprovision the box using the Jenkins job specific to
    the environment.
7.  Remove any entries for the box from your SSH
    `~/.ssh/known_hosts` file.
8.  Wait for the box to run Puppet so you can log in. It make take a few
    minutes before you can SSH into the box:

        until ssh mybox-2.somevdc.production; do sleep 10; done

9.  Check `/var/log/userdata.log` for puppet run errors, and perhaps
    re-run puppet manually to assert that all's well:

        sudo less /var/log/userdata.log
        govuk_puppet -v

10. Check all the services are running as expected, and if so, remove
    the downtime from Nagios (this can be done from the "Downtime" link
    in the left-hand sidebar).

> **note**
>
> If you are still unable to connect to the newly reprovisioned VM after
> a long period of time (e.g. 20 minutes), try connecting to the
> machine's console from the vCloud Director Flash UI. VMs have been
> known to wait at the Grub bootloader screen; if this is the case,
> simply press enter in the console to start Linux.

