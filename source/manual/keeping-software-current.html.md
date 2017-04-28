---
owner_slack: "#2ndline"
title: Keeping software current
parent: "/manual.html"
layout: manual_layout
section: Tools
last_reviewed_at: 2017-01-30
review_in: 6 months
---

# Keeping software current

One of our core values is to use secure and up to date software. This document lays out the recommendations for keeping our Ruby on Rails software current.

## Introduction

We run a lot of Rails applications. This means that we have dependencies on both Rails and Ruby versions.

### Upgrading Rails

It's very important that we're running a currently supported version of Rails for all applications, otherwise we aren't covered by security fixes. We should:

- Be running on the current major version - this currently means 4.y.z
- Maintain our applications at the latest current bugfix release for the minor version we're on (expressed in Gemfile syntax as: ~> X.Y.Z)
- Keep abreast of breaking changes for the next major version (5.y.z), and have a plan to migrate our apps before 4.2.x is deprecated

### Upgrading Ruby

New versions of Ruby bring us improved performance and nicer syntax for certain things, but also can cause issues with the libraries etc. we use. We should:

- Be running on the current major version - this currently means 2.y.z
- Maintain our applications at the current or next-to-current minor version - this means 2.3.z, 2.2.z or 2.1.z depending on your app's dependencies

### Current state

The current state of the Ruby and Rails versions is:

[Listed in this versions spreadsheet with team ownership by Alex Tomlins][sheet]

[sheet]: https://docs.google.com/spreadsheets/d/1FJmr39c9eXgpA-qHUU6GAbbJrnenc0P7JcyY2NB9PgU
