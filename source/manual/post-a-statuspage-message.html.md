---
owner_slack: "#govuk-2ndline"
title: Post a message on the status page
section: 2nd line
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-08-01
review_in: 3 months
important: true
---

When something goes wrong on GOV.UK we follow our [incident management procedure][inc]. As part of that we update our status page [status.publishing.service.gov.uk][status]

The page is managed using a third party service called [Statuspage][sp].

Use [manage.statuspage.io][man] to post messages.

Remember: government publishers are the main audience of the page. Write in non-technical language. Prefer to use the templates, they've been proofread.

This is what the [Statuspage admin interface][man] looks like:

![](manual/images/create-new-incident.png)

## Title of the incident

This is to say which application is affected and what the fault is. You *can*
update the title, hover over it on the incident interface.

> Delay in publishing

<!-- -->
> Issue with Whitehall Publisher

<!-- -->
> Investigating issue with the website

## Status & message

As part of the incident, you will be selecting a status for the incident.

### "Investigating" status

Provide reassurance to publishers that we are working on the problem.

Example messages:

> We’ve been told that publishers aren’t able to upload attachments to pages. We’re looking into why this is happening.

<!-- -->
> No email alerts seem to be delivered. We are investigating the issue.

<!-- -->
> We're currently experiencing a delay when publishing new content. Your content may appear on the site later than usual. We're monitoring the situation and will update once the delays are over.

### "Identified" status

We've found that the problem is.

Example messages:

> We’ve found the problem – the server is overloaded and can’t process new files. We’re working on fixing it, we think it’ll take approximately 3 hours to fix.

<!-- -->
> We've identified the cause of the issue relating to our email alert system. We expect to restore full functionality in an hour.

### "Monitoring" status

We've fixed the issue - but keeping are an eye on it.

> We've solved the problem and implemented a fix. We're waiting for the unsent emails to go out.

### "Resolved" status

We've fixed the issue and everything is back to normal. Incident is closed.

> The problem has been resolved and the publishing platform is stable again. Apologies for the inconvenience.

<!-- -->
> The issue relating to email alerts has been resolved. All systems are back to normal.

<!-- -->
> The issues with the website have been resolved. Everything should be working as normal.

[inc]: /manual/incident-management-guidance.html
[status]: https://status.publishing.service.gov.uk
[sp]: https://statuspage.io
[man]: https://manage.statuspage.io
