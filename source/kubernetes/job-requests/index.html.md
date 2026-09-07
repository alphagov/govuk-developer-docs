---
title: Kubernetes Job Requests
weight: 10
layout: multipage_layout
---

# Kubernetes Job Requests

If you are looking for how to create or review JobRequests, see the
[JobRequests User Guide](/kubernetes/job-requests/user-guide/)

If you are looking to understand how the JobRequest system works, see [the
JobRequest architecture guide](/kubernetes/job-requests/architecture).

## What is the JobRequest system

The JobRequest system allows for a user to run commands within containers in
Kubernetes in a way which is:

* Peer reviewed
* Audited
* Has isolated logs not mixed with regular application logs
* Easy to use
* Easy to see the logs for an executed command
* Does not require the user to create and understand kubernetes manifests
* Is garbage collected after a month

## What is the process for executing a Job using JobRequests

1. A user creates a JobRequest to run a command in Kubernetes, which will be
   run in a Pod that is a copy of an existing Pod or Deployment.
2. A different user reviews that request (either approving or rejecting).
3. If approved a Kubernetes Job will be created which:
    * Has its Pod spec copied from the requested Pod/Deployment
    * Has the command of the Pod overridden with the command the user requested

## Why might you use it

* To execute a Rake task in a Kubernetes cluster
* To receive a peer review for a command you are going to run in a Kubernetes cluster
* To have logs produced so you can see what your command did
