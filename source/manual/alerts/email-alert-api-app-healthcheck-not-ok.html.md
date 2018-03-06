---
owner_slack: "#email"
title: email-alert-api app healthcheck not ok
section: Icinga alerts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-03-06
review_in: 1 month
---

If there is a health check error showing for Email Alert API, you can click on the alert to find out more details about what’s wrong. Here are the possible problems you may see:

## High queue size (queue_size)
This means that there are a high number of items in the queue. This may indicate a problem down the line which is preventing workers from being processed. It may also imply the threshold is too low if a large number of emails have being sent out due to a content change.

## High queue latency (queue_latency)
This means the time it takes for a job to be processed is unusually high. This may indicate a problem down the line which is preventing workers from being processed. It may also imply the threshold is too low if a large number of emails have being sent out due to a content change.

## High retry queue size (retry_size)
This means there are a high number of items in the retry queue. The Email Alert API relies on the retry queue for rate limiting, so it’s not unusual to see items in the queue, but if it is very high it suggests that there may be a problem down the line which is preventing jobs from being processed. It may also imply the threshold is too low if a large number of emails have been sent out due to a content change.

## Status updates (status_update)
This means that we haven’t received status updates from Notify on some emails and it’s been 72 hours since the emails were sent out. This could mean there is a problem with our system, or there could be a problem with Notify.

## Technical failures (technical_failure)
This means that we’ve received a technical failure status code back from Notify or a request to send an email via Notify failed within the last hour. This means that there may be a problem with our system or that Notify is unable to send emails.
