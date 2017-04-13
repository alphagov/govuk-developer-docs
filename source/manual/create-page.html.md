---
owner_slack: '#2ndline'
review_by: 2017-08-09
title: Create a page in this manual
section: Manual
layout: manual_layout
parent: "/manual.html"
---

# Create a page in this manual

## Create a page

1. Add a page in Github to the [/source/manual](https://github.com/alphagov/govuk-developer-docs/tree/master/source/manual) directory.
2. Mark it with a section that makes sense for it to live in.
3. Add a review-by date.

## What pages should be about

Most pages will be about how to do a thing. Include just enough information to allow the reader to complete what they need to do.

Other pages help the reader understand how we use a particular technology or process. This is because they're working on something that requires that knowledge. Don't create pages to document why a decision was made if that information doesn't help the reader complete their task.

Don't duplicate what's already in existing documentation.

## Title

Put the most important word as near to the start of the title as possible. Short titles are good but descriptive titles are better.

Good examples:

> Reboot a machine
> Data sync: check failed data
> Assets: how they work

Bad examples:

> How to reboot a machine
> Data sync
> Ruby (too vague: what about Ruby?)


Don't use:

- "how to" at the start
- 'ing' at the end of verbs (for example use '"deploy an application", not "deploying an application")

## Structure

Put the 'how to do the thing' information at the top of the page. Put 'how it works' stuff lower down.

## Subheadings

Use subheadings to break up the page and allow readers to scan the page for what they're looking for. Don't repeat the title in the headings though.

Good example:

> Title: Rebooting machines
> Subheadings: Redis, Mongo, Elasticsearch

Bad example:

> Title: Rebooting machines
> Subheadings: Rebooting Redis machines, Rebooting Mongo machines, Rebooting Elasticsearch machines.

## Writing style

### Address the reader

Use "you" where possible.

Do say:

> You can export data to CSV.

Don't say:

> Data can be exported to CSV.

### Acronyms


Spell out acronyms the first time they're used on the page unless they're very widely known.

Examples of widely known acronyms:

- HTTP
- API
- XML
- CSV
- DNS
- JSON
- VPN
- URL
- MD5

Example of not widely known acronyms:

> DR (disaster recovery)

### Bullets and numbered lists

Bullet lists [make pages easier to read](https://www.nngroup.com/articles/presenting-bulleted-lists/). Use numbered lists to describe a linear progress, or when the number of items in the list is important.

## Related

- [Review a page in this manual](/manual/review-page.html)
