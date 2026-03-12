---
owner_slack: "#dev-notifications-ai-govuk"
title: Support GOV.UK Chat
section: GOV.UK Chat
type: learn
layout: manual_layout
parent: "/manual.html"
---

[GOV.UK Chat](https://github.com/alphagov/govuk-chat) is an conversational AI assistant that uses GOV.UK Content to answer users questions. Unusually, it is built and maintained by a team outside the GOV.UK programme, the Chat team, in the Products & Services programme.

## What it is

GOV.UK Chat is a Ruby-on-Rails application hosted on [GOV.UK Kubernetes infrastructure](/kubernetes). It makes use of [Amazon Bedrock](https://aws.amazon.com/bedrock/) to utilise large-language models.

## How it is used

GOV.UK Chat is a function in the GOV.UK App. GOV.UK Chat exposes a HTTP API which the GOV.UK app interacts with through a HTTP proxy in the app's infrastructure.

There is also a web interface to GOV.UK Chat, which is used by departments for testing chat functionality, and a web administrative environment for the Chat team to observe user behaviour.

## How it is supported

Supporting GOV.UK Chat is the same process as other GOV.UK applications, it is deliberately built to the same standards and conventions as other GOV.UK applications.

However, due to the different programme building and maintaining it, there are some differences to escalation routes. We
have documented these in a [Google Document](https://docs.google.com/document/d/157tV576o_wtT1cpLfrTrmi69iEpDF3RHMIV0gZ4kXyQ/edit?tab=t.34xblktiym67).
