---
owner_slack: "#2ndline"
title: Policy on keeping software current
parent: "/manual.html"
layout: manual_layout
section: Tools
last_reviewed_on: 2017-08-08
review_in: 6 months
---

One of our core values is to use secure and up to date software. This document lays out the policy for keeping our Ruby on Rails software current.

## Introduction

We run a lot of Rails applications. This means that we have dependencies on both Rails and Ruby versions.

### Upgrading Rails

It's very important that we're running a currently supported version of Rails for all applications, otherwise we aren't covered by security fixes. We should:

- Be running on the current major version
- Maintain our applications at the latest current bugfix release for the minor version we're on (expressed in Gemfile syntax as: ~> X.Y.Z)
- Keep abreast of breaking changes for the next major version (eg 5.y.z), and have a plan to migrate our apps before the current version is deprecated

### Upgrading Ruby

New versions of Ruby bring us improved performance and nicer syntax for certain things, but also can cause issues with the libraries etc. we use. We should:

- Be running on the current major version
- Maintain our applications at the current or next-to-current minor version

### Current state

The current state of the Ruby and Rails versions is [listed in this versions spreadsheet][sheet]  with team ownership by Alex Tomlins.

[sheet]: https://docs.google.com/spreadsheets/d/1FJmr39c9eXgpA-qHUU6GAbbJrnenc0P7JcyY2NB9PgU
