---
owner_slack: "#govuk-platform-health"
title: Use AWS X-Ray to trace app requests
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-04-08
review_in: 6 months
---

AWS X-Ray is a service provided by Amazon that allows request trace data to be collected from apps and analysed using a graphical interface.

## Request tracing

Request tracing is a technique that captures data every time an instrumented app (one that has been set up for tracing) makes requests to other apps and services.

This data can be useful when troubleshooting errors in microservice-architectured apps where the error does not necessarily originate in the app that serves it to the end user. It also provides information about bottlenecks, unnecessary and/or multiple requests and long-running processes.

> **Note**
>
> Due to the large amount of data that would be generated and the cost, only 1% of requests an instrumented app makes are traced. This means individual requests of interest cannot always be isolated.

## Using trace data

![](/manual/images/aws-xray.png)

Log in to AWS and visit the [X-Ray service map](https://eu-west-1.console.aws.amazon.com/xray/home?region=eu-west-1#/service-map). The initial view shows a summary of all traced requests.

All requests start with a client on the left-hand side visiting an instrumented app. This is generally a frontend app. From this app, lines lead to other apps that have received requests from this initial app.

Hovering over an arrow highlights it for easier viewing of the whole request journey. Each app consists of a circle which is a pie chart summarising the percentage of traced requests that resulted in a success (OK), 4xx (error), 5xx (fault) and 429 (throttle) response.

Clicking a circle shows a graph of response times and a button to view individual trace data.

Individual trace data breaks down a whole request journey into its individual requests along with timings and response statuses.

## Instrumenting an app

The [`govuk_app_config`](https://github.com/alphagov/govuk_app_config) gem automatically installs and configures the X-Ray gem to send trace data.

The default configuration traces 1% of all requests. The can be changed on a per-app basis by specifying the `XRAY_SAMPLE_RATE` environment variable with a number between 0 (no tracing) and 1 (100% request tracing).

> **WARNING**
>
> A high sampling rate can result in app slowness since each trace takes some non-zero time to complete. It will also result in cost increases since charges are based on the amount of data sent to the X-Ray service.

## X-Ray daemon

The X-Ray daemon is an app installed on all machines that run instrumented apps. It acts as a proxy between individual apps and the X-Ray service.

The X-Ray gem in an instrumented app sends trace data to the daemon, which collects data into batches before sending it to the X-Ray service. This provides resilience against service downtime and slowness as well as optimising bandwidth usage.
