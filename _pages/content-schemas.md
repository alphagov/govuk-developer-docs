---
layout: content_schema
title: Content schemas
navigation_weight: 40
source_url: https://github.com/alphagov/govuk-content-schemas
permalink: content-schemas.html
---

This repo contains schemas and examples of the content formats used on GOV.UK.

The aim of it is to support 'contract testing' between the frontend and publisher apps by expressing the schema and examples in strict, machine processable formats.

We use JSON Schema to define the formats.

For each format there are three possible representations:

- the 'publisher' representation, which is used when a publishing application transmits data to the content store.
- the 'frontend' representation, which is produced by the content store when a frontend application requests data
- the 'notification' representation, which is used when broadcasting messages about content items on the message queue
