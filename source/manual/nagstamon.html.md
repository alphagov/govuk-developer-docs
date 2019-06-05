---
owner_slack: "@christopherbaines"
title: Nagstamon
section: AWS accounts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-05-22
review_in: 6 months
---

![nagstamon](images/nagstamon.png)

[Nagstamon][] can access multiple Icinga instances, display the
alerts, and allow you to easily act on them.

[Nagstamon]: https://nagstamon.ifw-dresden.de/

## Connecting to Icinga

To connect Nagstamon to an Icinga instance:

- Go in to the Settings
- Select "New server..."
- Enter an appropriate "Monitor name", "Integration" for example.
- Enter the URL for the Icinga instance to the Monitor URL and Monitor
  CGI URL fields.
- Make the Username and Password blank, and tick "Save password"
- Click "OK"

### Actions

Nagstamon supports performing actions, you can configure it to connect
to the relevant host via SSH, which can make it easier to investigate
and resolve issues.

To configure an SSH action:

- Go in to the Settings
- Select the "Actions" tab
- Delete all the existing actions (SSH, RDP, ...)
- Click "New action..."
- Select "Command" as the Action type.
- Put "SSH " as the Name
- The command depends on what operating system you're using:
    - For MacOS, enter the following command in the "String" field:
        - `osascript -e 'tell app "Terminal" to do script "~/govuk/govuk-guix/bin/govuk connect ssh --hosting-and-environment-from-alert-url $MONITOR$ $ADDRESS$"'`
        - This assumes you have the `govuk-guix` Git repository cloned in
          the usual location, and that you've got `govuk connect` working.
    - For GNU/Linux, with the Gnome Terminal installed (which includes
      Ubuntu), use the following command:
        - `/usr/bin/gnome-terminal -x govuk connect ssh --hosting-and-environment-from-alert-url $MONITOR$ $ADDRESS$`
        - This assumes you have the `govuk` wrapper script on your PATH,
          and you've got `govuk connect` working
- Click "OK"
