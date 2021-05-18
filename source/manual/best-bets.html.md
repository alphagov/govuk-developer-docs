---
owner_slack: "#govuk-data-labs"
title: Change search results on GOV.UK
section: Data Community Documentation
layout: manual_layout
parent: "/manual.html"
---

The Search Admin tool can manually change GOV.UK site search results by:

- boosting a page in search results for a specific search term, also known as creating a best bet
- stopping a page from appearing in search results for a specific search term, also known as creating a worst bet
- removing search results from the search index

## When you should use a best bet

You should use a best bet to:

- temporarily boost a topical page in search results, for example to make sure that searches for “budget” produce results relating to a recently announced budget rather than a previous budget
- make sure a page that we think is high value to users ranks highly in search results
- make sure a page that does not contain a certain term appears in search results for that term, because the page content is relevant to the user need for that term

Before using a best bet, consider whether it might affect any other results for that search term.

### Choose the type of best bet.

A best bet can be exact or stemmed.

An exact best bet only applies to the exact term that’s been searched for.

A stemmed best bet applies to words or phrases that derive from the stem word. For example, a stemmed best bet for ‘budget’ would also show up for ‘budgets’, ‘budgeted’ and ‘budgeting’.

Consider using a stemmed best bet when there are a number of possible variations someone may use when searching for a term. Otherwise, you should use an exact best bet.

Before setting up a stemmed best bet, a performance analyst will look at search data to make sure this best bet will not affect other searches.

## When to use a worst bet

You should use a worst bet when a non-relevant page is showing up highly in results for a search term.

Worst bets exclude pages completely rather than lower their ranking. You must make sure that the excluded page is not relevant for any user searching for that term.

## Create a best or worst bet

You must have access to the [Search Admin tool](https://search-admin.publishing.service.gov.uk/) to create a best or worst bet.

[Contact the GOV.UK Finding Stuff](mailto:govuk-findingstuff-team-members@digital.cabinet-office.gov.uk) to get access to the Search Admin tool.

To create a best or worst bet, first specify the query search term and match type.

1. Go to the [Search Admin tool](https://search-admin.publishing.service.gov.uk/).
1. Select the __Queries__ tab.
1. Select __+ New Query__.
1. Enter the best or worst bet search term into the __Query__ field.
1. Select the __Match type__ as __Exact__ or __Stemmed__.
1. Select __Save__.

The __Add new bet__ window will appear.

1. Enter the URL slug of the page you would like to best or worst bet into the __Link__ field.
1. If this is a best bet, specify what search result rank you would like for your page in the __Position__ field.
    If this is a worst bet, select the __Is worst bet?__ checkbox instead.
1. If applicable, enter information on the Zendesk ticket into the __Comment__ field.
1. Select __Save__.

Your best or worst bet will be on site search within 5 minutes.

## Request a best or worst bet

If you do not have access to the [Search Admin tool](https://search-admin.publishing.service.gov.uk/), you can request a best or worst bet.

Raise a Zendesk ticket and assign it to Tara Stockford in 3rd Line–-Performance Analytics. This ticket will be picked up by a performance analyst in the GOV.UK Insights team.

Include the following information in the ticket:

- the page you want to set up a best bet for
- any search terms you want that page to rank highly for
- which department or GDS team the request came from
- what the department or team’s justification for the request was
- how long the best bet should be in place for, or when it should be reviewed
- if there’s any existing data from the department, for example how often the search terms are searched for

The performance analyst will:

- decide whether the best bet should be implemented due to a known issue with search or some other reason, if at all
- make sure the new best or worst bet won’t adversely affect the search results, or any best or worst bets already in place
- decide whether the bet will be for a specific time period, or set a review deadline
- check to see that it’s having the desired impact
- remove or review the best or worst bet when appropriate

## Change a best bet

You can change a best bet in the following ways:

- change the search term used by a best bet
- change the best bet type
- OTHERS

To change the search term used by a best bet or the best bet type, remove the best bet and create a new one with the updated search term or type.

To do other changes...

Sometimes you might want to change the search term used by a best bet, or change an existing best bet from exact to stemmed, or vice versa. In these cases, you'll need to expire the existing best bet, then add a new one in its place. You don't need to do this if you just want to change, add or remove a link to an existing best bet.

Simply editing the term or type of an existing best bet actually leaves the old version intact in the backend, but that version then isn't visible on Search Admin. It's possible to remove the old, now invisible entry by creating a new entry with the old term/type and then deleting it. However, it's much easier just to remove the existing best bet first, then create a new one with the updated term or type (exact/stemmed).

## Identify best bets in search results

To identify best bets in search results, add `&debug_score=1` to the end of a search result URL. Top results that are best bets will have a huge score compared to the remaining results.

You can add `&debug_score=1` to the end of a search results URL to show some extra information about each result. Top results that are best bets will have a huge score compared to the remaining results.

There's a bookmarklet to add this debug parameter:

`javascript:window.location=window.location.href+(window.location.href.indexOf("?")==-1?"?":"&")+"debug_score=1";`

## Request a search result removal

Sometimes a page that no longer exists may still appear in search results. You can ask for a link to be completely removed from the site search index by raising a Zendesk ticket for the GOV.UK Search team.
