---
owner_slack: "#govuk-platform-engineering"
title: Query GOV.UK logs in Logit (using Kibana)
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

## Set up the UI

The default view for Kibana includes a timestamp and a grouped `_source` column of all information per log. Depending on what you're trying to achieve, you may find it beneficial to re-organise your view.

You can specify a field in the logs list by navigating the "Available Fields" list on the left hand side, hovering over a field you want to interrogate and clicking "add". Some useful fields include:

- application
- controller
- route
- path
- status
- request
- tags

You can additionally remove fields by following the same steps above for "Selected Fields" and clicking "remove".

You can also manage the timeline bar chart at the top fo the view by changing the dropdown above the bar chart from "auto" to whichever delimitater suits your needs (hourly, daily, weekly etc) and specify the time frame of the bar chart by clicking the time range in the top right-hand corner.

## Examples

You can save and load queries using the buttons in the top right. You may want to use one of the existing queries as a starting point instead of writing a query from scratch.

![Kibana saved searches](images/kibana_saved_searches.png)

Every change to the query changes the URL in the browser. This URL is rather long and unfriendly, and often gets mangled by the Slack or Trello parser when trying to share it. Instead, you can generate a "short URL" by clicking the "Share" link in the top right, followed by "Short URL".

### All requests rendered by the content_items controller in government-frontend

```rb
application: government-frontend AND tags: request AND controller: content_items
```

### All requests within the /government/groups path

```rb
tags: request AND path: \/government\/groups\/*
```

### 5xx errors returned from cache layer

```rb
host:cache* AND (@fields.status:[500 TO 504] OR status:[500 TO 504])
```

### Nginx logs

```rb
tags:"nginx"
```

Nginx logs for frontend:

```rb
tags:"nginx" AND application:frontend*
```

> **Note**
>
> The `@timestamp` field records the request END time. To calculate request start time subtract `request_time`.
### Application production.log files

```rb
tags:"application"

tags:"application" AND application:"smartanswers"
```

### MongoDB slow queries

```rb
application:"mongodb" AND message:"command"
```

### Mirrorer logs

```rb
syslog_program:"govuk_sync_mirror"
```

### Publishing API timeouts

```rb
message:"TimedOutException" AND (application:"specialist-publisher" OR application:"whitehall" OR application:"content-tagger")
```

### Example Elasticsearch query

You can use Elasticsearch queries by clicking "Add a filter" and then specifying "Edit Query DSL".
Here is an example of finding all requests to the Transition Checker login page (ignoring URL query parameters) which resulted in a 410:

```json
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "status": 410
          }
        },
        {
          "regexp": {
            "request": {
              "value": ".+transition-check/login.+"
            }
          }
        }
      ]
    }
  }
}
```

This has no advantage over using Lucene query syntax in the search bar, which is much simpler: `request:*transition-check\/login* AND status:410`.

However, if you wanted to count the number of unique IP addresses that were served this response, you need an [aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations.html), which requires the Elasticsearch syntax.

Choose "Dev Tools" in the menu on the left, then fill out your JSON search, ensuring that you retain the `GET _search` on line 1.
You'll probably want to specify your date range in JSON as there is no way to do this through the UI on this screen.

```json
GET _search
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "status": 410
          }
        },
        {
          "range": {
            "@timestamp": {
              "time_zone": "+01:00",
              "gte": "2021-06-16T12:00:00",
              "lt": "2021-06-16T17:00:00"
            }
          }
        },
        {
          "regexp": {
            "request": {
              "value": ".+transition-check/login.+"
            }
          }
        }
      ]
    }
  },
  "aggs": {
    "unique-ips": {
      "terms": {
        "field": "remote_addr"
      }
    }
  }
}
```

Press the "Play" icon to run the query, whose results will appear in the panel on the right.
You'll see a `hits` array for each matching record, and also an `aggregations` object where your aggregations are grouped into `buckets`.
From here it should be quite simple to count the number of unique IPs.

## Gotchas

- Score: does a aggregation of field on last 2000 results
- Terms is not an aggregation of field, it is an aggregation of terms in the field across 1 recent indices
- For more elaborate searching, [read about the Lucene and Elasticsearch syntax][kibana-search]
- `@timestamp` of nginx log entries records [request end time is sometimes confusing][end]

[kibana-search]: https://www.elastic.co/guide/en/kibana/current/search.html
[end]: http://serverfault.com/questions/438880/what-does-nginxs-time-local-logging-variable-mean-specifically/438891#438891

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

[GOV.UK Senior Tech]: /manual/ask-for-help.html#contact-senior-tech
