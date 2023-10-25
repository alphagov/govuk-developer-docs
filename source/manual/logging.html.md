---
owner_slack: "#govuk-platform-engineering"
title: How logging works on GOV.UK
section: Logging
layout: manual_layout
type: learn
parent: "/manual.html"
---

> **To view logs, see [View GOV.UK logs in Logit](/manual/logit.html).**

## Overview

GOV.UK sends its application logs and origin HTTP request logs to managed [ELK
stacks](https://logit.io/blog/post/elk-stack-guide/#what-is-the-elk-stack)
hosted by [Logit.io](https://logit.io/), a software-as-a-service provider. Each
environment has its own ELK stack in Logit.

> [Fastly CDN request logs](/manual/query-cdn-logs.html) use a different system
> to this because of the much higher data rates involved.

![Block diagram showing data flow from containers in Kubernetes through to the
managed ELK
stack.](https://docs.google.com/drawings/d/1m0ls6d7dEkHeRgLLnrXrtDOUSnptF3npzJCxrYqmZ5I/export/svg)
<small>
[edit diagram](https://docs.google.com/drawings/d/1m0ls6d7dEkHeRgLLnrXrtDOUSnptF3npzJCxrYqmZ5I/edit)
</small>

## Components in the logging path

### Application container

The application container, or a sidecar/adapter container such as the nginx
reverse proxy, writes log lines to stdout or stderr.

Log lines can be structured (JSON) or unstructured (arbitrary text).

> Application workloads in GOV.UK's Kubernetes clusters run with
> `readOnlyRootFilesystem: true` and should not write logs anywhere other than
> stdout/stderr. Only logs written to stdout/stderr will be collected by the
> logging system.

### Kubernetes worker node

The container runtime ([`containerd`](https://containerd.io/)) and
[`kubelet`](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)
on the worker node are responsible for:

- writing the workload containers' stdout/stderr streams to files in
  `/var/log/containers`
- rotating those log files so as not to run out of space

### Filebeat

The
[Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-overview.html)
daemon runs on each Kubernetes worker node and is responsible for:

- finding and tailing log files on the local filesystem
- applying some transformations such as parsing JSON-formatted log lines and
  dropping some unwanted fields
- sending logs to Logstash (at Logit)

Filebeat runs as a
[daemonset](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
in the `cluster-services` namespace.

As of mid-2023, Filebeat is installed [by a Helm chart via
Terraform](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/logging.tf)
and its
[configuration](https://github.com/alphagov/govuk-infrastructure/blob/main/terraform/deployments/cluster-services/filebeat.yml)
is also managed using Terraform. In the future, Argo CD could replace this
usage of Terraform as part of ongoing efforts to reduce toil.

### Logstash

[Logstash](https://www.elastic.co/guide/en/logstash/current/introduction.html)
is a log ingestion pipeline, essentially an
[ETL](https://en.wikipedia.org/wiki/Extract,_transform,_load) system for logs.
Logstash and the remaining components in the logging path are hosted by
[Logit.io](https://logit.io/).

Logstash is responsible for:

- receiving streams of log messages from each node's Filebeat process via TLS
  over the Internet
- parsing the semi-structured log messages from Filebeat and transforming them
  where necessary, for example to fit the [Elastic Common
  Schema](https://www.elastic.co/guide/en/ecs/current/index.html)
- loading the logs into Elasticsearch for storage and indexing

### Elasticsearch

[Elasticsearch](https://www.elastic.co/what-is/elasticsearch) is a search
engine and storage/retrieval system. It is responsible for:

- [storing the log data](https://www.elastic.co/blog/found-dive-into-elasticsearch-storage)
- indexing the stored logs for efficient search and retrieval
- running queries and returning the results to the user interface (Kibana)

### Kibana

[Kibana](https://www.elastic.co/what-is/kibana) is the user interface for
viewing logs. It is responsible for:

- rendering the web UI
- parsing user queries written in Lucene/KQL into Elastic
- querying the Elasticsearch indices
- displaying the results

### Vulnerability Scanners

Occasionally you may see some logs that look suspicious. For example, see the `controller` part of the following made up example:

`http_request_duration_seconds_count { action="1", container="app", controller="../../../../../etc/passwd", endpoint="metrics", job="govuk", namespace="apps", pod="static-abc123-de7f" }`

This sort of thing often originates from vulnerability scanners and isn't necessarily something to worry about. However, you should consider _how_ such activity ended up leaking into your logs, and whether or not there's anything you could/should do to patch it up. Read our [internal guidance on the issue](https://docs.google.com/document/d/1BZ_SBPuZmO8pseniqj1tlq7pss9iU3JslqQHp_JS9Wg/edit#heading=h.17fwpvs3mt0x).
