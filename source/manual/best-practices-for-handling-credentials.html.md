---
owner_slack: "#govuk-platform-engineering-team"
title: Best practices for handling credentials
parent: "/manual.html"
layout: manual_layout
section: Security
type: learn
---

Occasionally, technologists need to access sensitive systems from their workstations. For example, a developer might use
the AWS CLI to examine an S3 bucket, or an API key to test some third party API.

The process of developing software introduces a supply-chain risk, which could result in malware on a workstation
stealing the credentials used to access these sensitive systems.

The following are some best practices which we recommend technologists follow when accessing systems from their
workstations.

## Git

Commits and pushes are a regular part of everyone's workflow. Our GitHub configuration prevents pushes to the `main`
branch, but there's still some risk that a piece of malware could automatically commit some piece of code without the
user of the workstation realising.

You COULD consider updating your workflow to require an interactive step before pushing commits to GitHub. You could do
this by configuring git to sign commits, and using a signing method that requires an interactive step (e.g. touching a
yubikey), or by disabling your ssh-agent so push / pull commands require your ssh password.

## AWS

You MUST avoid storing credentials in `~/.aws/credentials` \- use a tool like
the [gds-cli / aws vault](https://docs.publishing.service.gov.uk/manual/get-started.html#7-install-and-configure-the-gds-cli)
which stores credentials in the macOs keychain.

You SHOULD avoid running package manager commands in shell sessions
with access to AWS environment variables (e.g. if you run `gds aws govuk-production-developer \-s` use that shell only
for interacting with AWS, don't also run npm install or any other potentially untrustworthy commands in the shell).

You SHOULD use the role with the lowest privileges which will allow you to complete your task (e.g. if you only need
read access, use a readonly role).

## GCP

You SHOULD revoke any local auth credentials once you've finished working with gcloud (`gcloud auth revoke` / `gcloud auth
application-default revoke`)

## Other credentials

You SHOULD be careful when storing any credentials in plain text files (e.g. `.env`) - ensure that credentials have the
minimum set of access required, and delete them when you no longer need them. Even if the file is only local, it could
be stolen by malware on your workstation.
