---
owner_slack: "#govuk-platform-engineering"
title: View GOV.UK logs in Logit
section: Logging
layout: manual_layout
parent: "/manual.html"
---

GOV.UK sends application logs and origin HTTP request logs to Logit, a
software-as-a-service log storage and retrieval system based on the
[Elasticsearch, Logstash, Kibana
stack](https://logit.io/blog/post/elk-stack-guide/#what-is-the-elk-stack).

> **Fastly CDN logs are not stored in Logit.** See [Query CDN
> logs](/manual/query-cdn-logs.html).

## Access Logit

### Log into Logit

You can [log into Logit directly via Google Workspace
single-sign-on](https://accounts.google.com/o/saml2/initsso?idpid=C01ppujwc&spid=408557323201&forceauthn=false).

Alternatively, you can open Logit from the Google Workspace apps menu in Gmail,
Calendar, and Drive. Click the 3x3-grid-of-dots icon next to the GDS logo in
the top-right corner, scroll all the way to the bottom of the list of icons
that appears, then choose Logit.

Once you are logged in, you should see the Logit Dashboard page.

### Launch Kibana

From the Logit Dashboard page, choose Launch Kibana for the appropriate stack.
Each environment (production, staging, integration) has its own ELK stack in
Logit named `GOV.UK <environment> EKS`.

There are also separate stacks for the legacy EC2/Puppet environments, named
`GOV.UK <environment> AWS`.

### Alternative login method

1. Go to [https://dashboard.logit.io/sign-in](https://dashboard.logit.io/sign-in).
1. Enter your `<username>@digital.cabinet-office.gov.uk` email address. The
   password box should disappear when you do this.
1. Press Return.
1. If you are signed into multiple Google accounts, you will be prompted to
   choose one. Choose your `digital.cabinet-office.gov.uk` account.
1. If you are accessing Logit for the first time, you may need to allow
   Logit to connect with your Google Workspace account if prompted.
1. You should be redirected to `dashboard.logit.io` and see a list of available
   stacks.

### If you don't have access to Logit

> Make sure you have followed the [instructions](#log-into-logit) precisely.
>
> If you chose _Sign in with Google_ (or any of the other _Sign in with_ links)
> on the Logit _Sign into your account_ page, you may be logged in but with no
> stacks visible. Sign out using the link at the bottom-left corner of the page
> and try again.

Your tech lead should have already set up your logs access when you joined your
team. If you are unable to view logs in Logit, get in touch with your tech lead
or a member of [GOV.UK Senior Tech].

## Useful Kibana queries

See [Useful Kibana queries](/manual/kibana.html).

## Administration guide

For an overview of GOV.UK's logging architecture, see [How logging works on
GOV.UK](/manual/logging.html).

### If Logit is down

1. Check the [Logit status page](https://status.logit.io/) to see if there is a
   known issue.

1. Check that you can sign into other third-party services via Google Workspace
   SSO, for example Terraform Cloud. If not then the problem is likely with
   your account or GDS's Google Workspace setup. Contact the [IT
   helpdesk](https://gds.slack.com/channels/ask-it) if you suspect this.

1. Try from a different network (for example by tethering your work mobile
   phone to your laptop, or by disconnecting from the office VPN) to make sure
   it's not a local network issue.

1. Have someone else check that it's down for them too, in case the problem is
   specific to your user account. Your tech lead (during office hours) or
   secondary on call (if you're on call out of hours) can help with this.

1. If you are sure there is a Logit outage, contact [Logit telephone
   support](https://docs.google.com/document/d/1TFsMkCafynS6e4S0PL6qN8Ml7JgorbAG8AWoHGelaGk/view)
   (access restricted to GDS). If unsure, ask your tech lead or a member of
   [GOV.UK Senior Tech].
    - You will be prompted to enter the PIN and leave a voicemail message.
    - Mention your name, that you're calling from GDS, a brief description of
      the problem and a contact number for them to reach you.
    - This will page someone at Logit and they should call you back within half
      an hour.

### If new logs stop appearing altogether

Logs should normally become available to query in Kibana within a minute or two
of being written.

Find out when logs stopped appearing. Run an empty query in Kibana Explore
with the time range set to "last 7 days" and check the bar graph of message
count per time window.

On the source Kubernetes cluster, make sure the filebeat daemonset is healthy
and look for errors in its logs. [Platform Engineering
team](https://gds.slack.com/channels/govuk-platform-engineering) can help you
with this.

```sh
k -n cluster-services describe ds/filebeat-filebeat
```

```sh
k -n cluster-services logs ds/filebeat-filebeat
```

Check for ingestion errors in Logstash:

1. From the Logit dashboard, choose Settings for the affected stack.
1. Choose Diagnostic Logs from the left-hand menu.

> If you don't have the Settings option, ask your tech lead or someone in
> [GOV.UK Senior Tech] for help.

If there seems to be no recent data in Kibana when there really should be, you can try restarting the Logstash instance:

1. From the Logit dashboard, choose Settings for the affected stack.
1. Select Logstash Filters in the left hand menu.
1. Under Danger Zone, press Restart Logstash.

### Grant logs access to new users

If you cannot see the user in the user list, they need to first attempt to login via SSO to Logit.  Only once they have attempted to login to Logit will their account be visible for you to then assign them to a team.

1. Go to the main "Dashboard"
2. Click "Manage Teams", then "Team Settings" and then click the appropriate team.
3. Scroll down until you see a list of users and for the particular user give them "Member" access
4. Click "Apply Changes"

### Update Logstash configuration

At present there is no automated way to configure Logstash configuration.

1. Click the "Settings" button next to the stack you wish to configure.
2. Go to "Logstash Filters"
3. Amend the configuration
4. Click "Validate"
5. If correctly validated, click "Apply"

We store our configuration in the [govuk-saas-config](https://github.com/alphagov/govuk-saas-config)
repository. Any changes to the configuration should be stored in here, and they
should be consistent across stacks.

## Retention period

- Production: 14 days
- Staging: 7 days
- Integration: 7 days

The retention window for an environment is configurable under the Settings page
for the corresponding Logit stack, for users with the Stack Editor permission.

## Further reading

See [How logging works on GOV.UK](/manual/logging.html).

[GOV.UK Senior Tech]: https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govuk-senior-tech-members/members
