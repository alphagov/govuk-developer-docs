---
owner_slack: "#govuk-developers"
title: Architectural summary of GOV.UK
section: Applications
type: learn
layout: manual_layout
parent: "/manual.html"
---

The following content is a high-level summary of GOV.UK architecture, intended for both developers and non-developers to refer to.

It's based on the [architectural deep-dive of GOV.UK](/manual/architecture-deep-dive.html) and describes what happens when a:

- user visits a page on GOV.UK
- publisher publishes content to GOV.UK

## A user visits a page on GOV.UK

This content goes through 3 scenarios where a user:

- visits the GOV.UK homepage
- visits a GOV.UK webpage
- searches GOV.UK

### A user visits the GOV.UK homepage

The user visits `https://www.gov.uk` or `https://gov.uk` to get to the GOV.UK homepage.

The user's browser uses [Domain Name System (DNS)](/manual/dns.html) to look up which IP address is associated with the GOV.UK domain. For the GOV.UK domain, the IP address is for [Fastly](https://www.fastly.com/).

GOV.UK uses the Fastly content delivery network (CDN) to handle most requests to GOV.UK. Fastly has servers all over the world, meaning that it is physically closer to our users, who then have a faster GOV.UK experience as a result.

Using Fastly reduces the load on the base GOV.UK infrastructure, otherwise known as Origin, by around 70%. Origin is a stack of computers in the AWS cloud with a load balancer entry point. Origin hosts all GOV.UK applications, and knows which applications respond to which requests. Origin sends requests to the machine running the application so that the application can respond to those requests.

If Fastly has the homepage cached, Fastly returns the homepage to the user.

If Fastly does not have the homepage cached, Fastly sends the request on to Origin.

Within Origin, the request goes to an application called [Router](https://github.com/alphagov/router) to determine which GOV.UK application will produce the page.

Router sends the request to [Frontend](https://github.com/alphagov/frontend). Frontend is one of several public-facing apps that render pages on GOV.UK. The GOV.UK homepage is one of the pages that Frontend is responsible for. The homepage's content is hard-coded in the Frontend application.

Frontend produces the homepage as an HTML response and sends that response back to Router.

Router sends the response to Fastly, which caches the response for 5 minutes. This means that Fastly can handle any subsequent requests for the homepage during this time, without needing to query Origin at all.

Finally, Fastly sends the response back to the user.

### A user visits a GOV.UK webpage

The user searches for a GOV.UK webpage, and selects the webpage link in the search results. For example, this [news page about changes to travel between Nigeria and England](https://www.gov.uk/government/news/uk-changes-travel-rules-for-travellers-from-nigeria-to-england).

The user's browser sends the request to the [Fastly](https://www.fastly.com/) content delivery network (CDN).

If Fastly has the page cached, Fastly returns the page to the user.

If Fastly does not have the page cached, Fastly sends the request on to GOV.UK Origin.

Within Origin, the request goes to an application called [Router](https://github.com/alphagov/router) to determine which GOV.UK application will produce the page.

Router chooses Frontend to produce the page, and forwards the request to Frontend.

[Frontend](https://github.com/alphagov/frontend) looks at the request and decides which content to get from the Content Store. The [Content Store](https://github.com/alphagov/content-store) is:

- a MongoDB database of almost all the content published on GOV.UK, excluding dynamic elements such as top links on taxon pages, navigation elements, or search result pages
- an application that exposes the [Content Store API](https://github.com/alphagov/content-store/blob/main/docs/content-store-api.md)

Frontend then queries the Content Store API to get the content in an [API response from the Content Store](https://www.gov.uk/api/content/government/news/uk-changes-travel-rules-for-travellers-from-nigeria-to-england).

Frontend then builds the page using the content in the API response, and sends that response back to Router.

Router sends the response to Fastly. Fastly sends the response back to the user.

### A user searches GOV.UK

The user goes to the [GOV.UK search page](https://www.gov.uk/search), and [searches for something, for example, "tax"](https://www.gov.uk/search/all?keywords=tax&order=relevance).

The user's browser uses DNS to figure out where to send the request, and sends that request to Fastly.

If Fastly has the search results page cached, Fastly returns that page to the user.

If Fastly does not have the search results page cached, Fastly sends the request on to Origin.

Within Origin, the request goes to an application called [Router](https://github.com/alphagov/router) to determine which GOV.UK application will produce the page.

[Finder Frontend](https://github.com/alphagov/finder-frontend) renders finder, search and search result pages for GOV.UK. Router sends the request to Finder Frontend.

Finder Frontend [queries the content store](https://www.gov.uk/api/content/search/all) for parts of the page content, such as the page title. Finder Frontend queries the Search API for the search results themselves. Search API provides a [JSON response with the search results](https://www.gov.uk/api/search.json?q=tax&count=2).

Finder Frontend then renders the response in a search results page, and sends that response to Router. Router sends the response to Fastly, which then sends the response to the user.

## A publisher publishes content on GOV.UK

GOV.UK has the following applications to publish content:

- Mainstream Publisher
- Whitehall
- Content Publisher
- Specialist Publisher
- Travel Advice Publisher
- Collections Publisher
- Manuals Publisher

The following sections describe what happens when a publisher publishes content to live and to draft using Mainstream Publisher (referred to as "Publisher").

### A publisher publishes content to live

A publisher signs into their [Signon](/repos/signon.html) account. Signon is a centralised single sign-on provider for GDS services that provides username/password and two-factor authentication.

The publisher creates or changes content in Publisher and [saves that content in draft](#a-publisher-publishes-content-to-draft).

When the publisher is ready to publish the content, they select __Publish__ in Publisher, which sends a request to the Publishing API.

The [Publishing API](https://github.com/alphagov/publishing-api) publishes content to the Content Store. This API stores all versions of content, and performs validation checks whenever the API receives a new version.

Publishing API updates the Content Store directly, which in turn updates [Router](https://github.com/alphagov/router) to say there is now content at a particular URL, and which frontend application will render that content.

Publishing API also puts the publishing event on a 'message queue', which multiple other applications listen to and use. For example:

- the Search API listens to this queue and updates its indexes when new content is published so that this content can be searched for by users
- the Email Alert Service listens to this queue so that it can send emails to users who have subscribed to that topic

### A publisher publishes content to draft

The previous content referred to the user-facing live stack, also known as Origin. Before publishing content to live, a publisher can preview their content in the draft stack, also known as Draft Origin.

The [Authenticating Proxy](https://github.com/alphagov/authenticating-proxy) adds authentication to the draft stack. This means that only publishers with a [Signon](/repos/signon.html) account, or a valid secret JSON web token (JWT) if the publisher is a fact checker, can access the draft stack.

The publishing apps, Publishing API and message queue only run in this draft stack. The draft stack also has its own copy of [Router](https://github.com/alphagov/router), [Content Store](https://github.com/alphagov/content-store), and all of the frontend apps. This enables publishers to see what their draft content will look like when rendered by the appropriate frontend application.

The only application that communicates with both the draft and live stacks is the Publishing API. When a publisher saves a draft in Publisher, Publishing API saves the content to the draft content store. When a publisher publishes a draft in Publisher, Publishing API saves the content to the live content store, which makes the content visible to users.
