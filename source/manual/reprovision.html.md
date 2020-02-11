---
owner_slack: "#re-govuk"
title: Reprovision a machine
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-06-27
review_in: 6 months
---

Make sure you are aware what the consequences will be of removing a
machine from the rotation and consider who needs to be aware of
potential downtime. In particular, removing a single-point-of-failure
machine will result in downtime.

## AWS

1.  Log into the AWS console, select the correct environment and go to the EC2 service
2.  Locate the instance and confirm it's the correct one by either instance ID or private IP address
3.  Select Terminate from the Actions -> Instance State menu
4.  The AWS Auto Scaling Group will reprovision the instance automatically

## Carrenza

1.  Schedule downtime for your host in Icinga using our [Fabric
    scripts](https://github.com/alphagov/fabric-scripts). This will
    prevent Icinga from alerting while you reprovision the machine:

        fab $environment nagios.schedule_downtime:mybox-2.somevdc.production,20

2.  Stop the machine in the vCloud Director.
3.  Delete the machine in the vCloud Director.
4.  Remove the certificate for the relevant machine on the
    organisation's Puppet master, e.g.

        sudo puppet cert clean mybox-2.somevdc.production

5.  Ensure that the Puppet master will sign the certificate for the
    newly reprovisoned VM; after 5 minutes the Puppet client will
    timeout and you would need to initiate the signing request
    again manually.

    An easy way to do this is to run the following loop on
    `puppetmaster-1.management` and monitor the output:

        screen
        while true; do sudo puppet cert sign --all; sleep 10; done

    Don't forget to kill the screen session when you're done.

6.  Reprovision the box using the "Launch VMs" Jenkins job in the
    enviroment's `deploy` Jenkins instance.
7.  Remove any entries for the box from your SSH
    `~/.ssh/known_hosts` file.
8.  Wait for the box to run Puppet so you can log in. It make take a few
    minutes before you can SSH into the box:

        until ssh mybox-2.somevdc.production; do sleep 10; done

9.  Check `/var/log/userdata.log` for Puppet run errors, and perhaps
    re-run Puppet manually to assert that all's well:

        sudo less /var/log/userdata.log
        govuk_puppet -v

10. Check all the services are running as expected, and if so, remove
    the downtime from Nagios (this can be done from the "Downtime" link
    in the left-hand sidebar).

> **Note**
>
> If you are still unable to connect to the newly reprovisioned VM after
> a long period of time (e.g. 20 minutes), try connecting to the
> machine's console from the vCloud Director. VMs have been known to
> wait at the Grub bootloader screen; if this is the case, press the
> enter key in the console to start Linux.
>
> You won't be able to connect to the Flash console if you're using the
> "emergency" SSH tunnel to access vCloud.
