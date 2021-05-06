---
owner_slack: "#govuk-developers"
title: Create a Local Transaction
section: Applications
layout: manual_layout
parent: "/manual.html"
important: true
---

This document describes the steps required to create a postcode-based local transaction similar to [Apply for a Test and Trace Support Payment](https://www.gov.uk/test-and-trace-support-payment) and [Find a rapid lateral flow test site in your area](https://www.gov.uk/find-covid-19-lateral-flow-test-site).

## Outline

* [Get details of or create the service in the Electronic Service Delivery (ESD)](#get-details-of-or-create-the-service-in-the-electronic-service-delivery-esd) <sup>[1]</sup>
* [Get a list of local authority slugs and URLs](#get-a-list-of-local-authority-slugs-and-urls) <sup>[1]</sup>
* [Add the service to Publisher](#add-the-service-to-publisher) <sup>[2]</sup>
* [Make the service unavailable for a nation in Frontend](#make-the-service-unavailable-for-a-nation-in-frontend) <sup>[3]</sup>
* [Enable or create the service in Local Links Manager (LLM)](#enable-or-create-the-service-in-local-links-manager-llm)
* [Upload Local Authority URLs to Local Links Manager (LLM)](#upload-local-authority-urls-to-local-links-manager-llm)
* [Add content and publish the service in Publisher](#add-content-and-publish-the-service-in-publisher)

_[1]: These steps are manual and can be very time consuming. It is recommended they are started as early as possible to reduce delay._

_[2]: This step requires a PR that can be created and deployed (once approved) at any point prior to publishing the service._

_[3]: This step requires a PR that can be created and deployed (once approved) at any point._

## Get details of or create the service in the Electronic Service Delivery (ESD)

Newly created services are automatically imported into [Local Links Manager (LLM)](https://local-links-manager.publishing.service.gov.uk/) from [Electronic Service Delivery (ESD)](#electronic-service-delivery-esd) via a nightly import process. So, if you know the ID of the service you want to use, [check if it exists in ESD](https://standards.esd.org.uk/?tab=search) and [LLM](https://local-links-manager.publishing.service.gov.uk/services).

If the service exists in [ESD](#electronic-service-delivery-esd) but not LLM, and it is not possible to wait overnight, you can run [this rake task](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/lib/tasks/import/service_interactions.rake#L12) to import them on demand.

On occasion the service you are looking to use does not exist in [ESD](#electronic-service-delivery-esd) and LLM. If this is the case, it may be possible to obtain a new service from...

```text
Nicki Gill (ESD Project Manager)
Tel: +44 20 8570 5086
Bon Marché Centre, 241–251 Ferndale Road, London SW9 8BJ
nicki.gill@esd.org.uk | esd.org.uk
```

While it is not essential that the service exists in [ESD](#electronic-service-delivery-esd) or LLM before starting this process, it is preferable. However, if you are unable to create the service within a suitable timeframe, it is possible to carry on with the process as it will create the service in LLM for you anyway.

Once you've found the service, gather the following information:

* An [LGSL_CODE](#lgsl-code) - the ID of the service in [ESD](#electronic-service-delivery-esd)
* An [LGIL_CODE](#lgil-code) - the ID of the interaction in [ESD](#electronic-service-delivery-esd)
* The service [`name`](#seek-content-advice)
* The service [`description`](#seek-content-advice)
* The service [`slug`](#seek-content-advice)
* The [providing tier(s)](#providing-tier) for the service
* Which (if any) nations the service is unavailable in

## Get a list of local authority slugs and URLs

We need to create a CSV file containing the `name`, `slug` and an empty space for a `url` for all available local authorities currently in LLM.

The service product owner (your PM or DM should be able to identify them for you) can then add the specific URLs for each local authority that offers the service and return the finished file to us for import. This is used to associate the URL with the service and the local authority in LLM.

Log into the LLM console...

```bash
$ gds govuk connect app-console -e integration local-links-manager

Connecting to the app console for local-links-manager, in the integration environment
The relevant hosting provider is aws
The relevant node class is backend
There are 2 machines of this class
Connecting to a random machine (number 1) #=> Make a note of this MACHINE_NO
```

Then in the rails console...

```ruby
lgsl_code = 1234

file = "#{Rails.root}/tmp/#{lgsl_code}.csv"

# Make a note of this REMOTE_FILE_PATH...
=> "/data/vhost/local-links-manager/releases/20210507085218/tmp/1234.csv"
```

Generate the CSV file and exit out of the rails console.

```ruby
CSV.open(file, 'w') do |csv|
  csv << ["name", "slug", "url"]
  LocalAuthority.order(name: :asc).each do |la|
    csv << [la.name, la.slug, nil]
  end
end
```

Download the CSV file just you just created to your local machine...

```bash
$ gds govuk connect scp-pull -e integration backend:MACHINE_NO REMOTE_FILE_PATH ~/Downloads
```

Substituting the MACHINE_NO and REMOTE_FILE_PATH from the earlier rails console session. For example:

```bash
$ gds govuk connect scp-pull -e integration backend:1 /data/vhost/local-links-manager/releases/20210507085218/tmp/1234.csv ~/Downloads
```

Hand this over to the service product owner.

_The `name` is only present in the CSV file to assist the product owner complete the URLs as differences between the local authority `name` and `slug` can make it tricky to match the local authority correctly. It is not used when importing the links into LLM._

## Add the service to Publisher

Create a PR that adds the following to the bottom of [this](https://github.com/alphagov/publisher/blob/a656ea44d0e3a086b096ff2b2053290f1b9fb4d9/data/local_services.csv) file:

| LGSL | Description | Providing Tier |
| ---- | ---- | ---- |
| [LGSL_CODE](#lgsl-code) | SERVICE_DESCRIPTION | PROVIDING_TIER |

_Where `SERVICE_DESCRIPTION` is the service [`description`](#seek-content-advice), and `PROVIDING_TIER` is the service [`providing tier(s)`](#providing-tier)._

Once your PR is merged and deployed, run [this rake task](https://github.com/alphagov/publisher/blob/b65989d9c37df639d53666ccb3cd801c1155d247/lib/tasks/local_transactions.rake#L3) in Publisher...

```bash
bundle exec rails local_transactions:fetch_and_clean
```

## Make the service unavailable for a nation in Frontend

__Note__: This is an optional step that can be done when the new service is live.

If the service is unavailable in one or more devolved nation, create a PR to add the service to the [Frontend local transaction configuration file](https://github.com/alphagov/frontend/blob/master/lib/config/local_transaction_config.yml).

This can be configured with or without `button_text` and `button_link`. [Seek content advice](#seek-content-advice) with the content.

For example (given an [LGSL code](#lgsl-code) of `1234`):

```yaml
1234:
  unavailable_in:
    Scotland:
      title: "This service is not available in Scotland"
      body: "We do not know if they offer this service. Search the Scottish Government website to see if they do, or what else they offer."
      button_text: "Find information for Scotland"
      button_link: "https://www.mygov.scot"
    Northern Ireland:
      title: "This service is not available in Northern Ireland"
      body: "This service is not available in Northern Ireland. You can find other services on your council website"
```

## Enable or create the service in Local Links Manager (LLM)

Run [this rake task](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/lib/tasks/service.rake#L3) in LLM. This creates the following internal model instances and associations:

* A [`Service`](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/app/models/service.rb#L1) instance (if the service doesn't already exist)
* Associations between the [`Service`](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/app/models/service.rb#L1) and [`Tier`](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/app/models/tier.rb#L1) models, giving us [`ServiceTier`](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/app/models/service_tier.rb#L1) instances
* An association between the [`Service`](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/app/models/service.rb#L1) and [`Interaction`](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/app/models/interaction.rb#L1) models, giving us a [`ServiceInteraction`](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/app/models/service_interaction.rb#L1)
* Enables the [`Service`](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/app/models/service.rb#L1) and [`ServiceInteraction`](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/app/models/service_interaction.rb#L1)

```bash
bundle exec rails service:enable[LGSL_CODE,LGIL_CODE,SERVICE_NAME,SERVICE_SLUG]
```

_Where `SERVICE_NAME` is the service [`name`](#seek-content-advice), and `SERVICE_SLUG` is the service [`slug`](#seek-content-advice)._

Then run [this rake task](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/lib/tasks/import/missing_links.rake#L5) in Local Links Manager to add (empty) links for all available local authorities...

```bash
bundle exec rails import:missing_links
```

## Upload Local Authority URLs to Local Links Manager (LLM)

Upload the completed CSV file that was sent to the product owner [in this step](#get-a-list-of-local-authority-slugs-and-urls)...

```bash
$ gds govuk connect scp-push -e integration backend LOCAL_FILE_PATH REMOTE_FILE_PATH
```

Run [this rake task](https://github.com/alphagov/local-links-manager/blob/a1a2b23982f62d28ffbe38208807f2d4199548e6/lib/tasks/import/service_links_from_csv.rake#L5) to import the links from the CSV file.

```bash
bundle exec rails import:service_links[LGSL_CODE,LGIL_CODE,REMOTE_FILE_PATH]
```

__Note__: If you intend to run the `import:service_links` rake task via Jenkins, you will need run scp-push against all of the backend machines. For example:

```bash
# To find out how many machines you'll need to copy the file to...
$ gds govuk connect ssh -e integration backend
There are 2 machines of this class  #=> Make a note of the number of machines
Connecting to a random machine (number 1)
$ exit

# Copy the file...
$ gds govuk connect scp-push -e integration backend:1 LOCAL_FILE_PATH REMOTE_FILE_PATH
$ gds govuk connect scp-push -e integration backend:2 LOCAL_FILE_PATH REMOTE_FILE_PATH
# ...
$ gds govuk connect scp-push -e integration backend:n LOCAL_FILE_PATH REMOTE_FILE_PATH
```

## Add content and publish the service in Publisher

Once __all__ of the above steps are complete, ask a content designer to create a new local transaction page in [Publisher](https://publisher.publishing.service.gov.uk) using the [LGSL code](#lgsl-code) and [LGIL code](#lgil-code).

## Glossary

### Electronic Service Delivery (ESD)

Behind each local transaction is a public service, overseen and delivered by the [Local Government Association (LGA)](https://www.local.gov.uk/), that all local authorities should (in principle) offer and supply. These services are listed on the [Electronic Service Delivery (ESD)](https://standards.esd.org.uk) website.

The ESD [defines services](https://standards.esd.org.uk/?uri=list%2Fservices&tab=details) as...

> "...a set of actions or activities undertaken by a council (or other public sector body) to deliver a product or conclusion."

### LGSL code

A Local Government Services List (LGSL) is a number that LLM uses to uniquely identify a service. They originate in [ESD](#electronic-service-delivery-esd) where it is used as the service ID.

### LGIL code

Along with services, [ESD](#electronic-service-delivery-esd) has the concept of an Interaction. Functionally, the relationship between service and interaction is many-to-many.

An interaction describes the reason, use, or purpose of the service.

Like an [LGSL code](#lgsl-code), LLM uses the interaction ID from [ESD](#electronic-service-delivery-esd) to uniquely identify an interaction. In LLM this is called the Local Government Interaction List (LGIL) code.

One thing to note is that [ESD](#electronic-service-delivery-esd) has deprecated the use of interactions. LLM has not however been updated to accommodate the replacement concept in [ESD](#electronic-service-delivery-esd). This means that services in LLM still need a relationship with one-or-more interaction in order to function correctly. If you are unsure which interaction(s) it is that you need, it is recommended that the [Providing information (LGIL code 8) interaction](https://standards.esd.org.uk/?uri=interaction%2F8) be used as this ist generic in nature.

### Seek content advice

For service details such as: `name`, `description` and `slug` - you must get a content designer to create them. It is highly unlikely that the details from [ESD](#electronic-service-delivery-esd) will work and the `slug` will be used for the URL of the service on GOV.UK.

For unavailability elements such as `title` and `body` standard text is available [here](https://docs.google.com/document/d/1V1oP9O25IAudOsM168sYbsOegZfRZgPAJvdVrRxoEyY/edit#).

### Providing tier

A providing tier is way of identifying the [levels](https://www.gov.uk/understand-how-your-council-works) at which a service is implemented by a local authority. A tier can be either:

* `county/unitary`
* `district/unitary`
* `all`

In LLM each tier has a nominal level indicator that makes them hierarchical in nature.

1. County
2. District
3. Unitary

This is important as, in order to present the most appropriate URL for a service to the user, the tiers are checked for a match starting at the lowest level (3) working up to the highest level (1). This way http://www.coventry.gov.uk/a-specific-serivce would be presented before http://www.coventry.gov.uk for example.

If the providing tier for a service is unknown, using `all` is recommended as this offers the best chance of finding the most appropriate URL.
