---
owner_slack: "#govuk-datagovuk"
title: WMS map previews on data.gov.uk
section: data.gov.uk
layout: manual_layout
type: learn
parent: "/manual.html"
---

## Harvesting data for Web Map Service map previews

In order to show map previews a harvest source needs to be created with the correct source type (`WAF`, `CSW`, etc) in the ckan publisher.

Manually uploading datasets will not generate map preview data, please create a harvest source with a `Single Gemini 2 document` source type.

## Previewing Web Map Service data on DGU maps

[Data.gov.uk find](https://data.gov.uk/search?q=&filters%5Bpublisher%5D=&filters%5Btopic%5D=&filters%5Bformat%5D=WMS&sort=best) provides a map preview for Web Map Service (WMS) data. This data is represented as features on a map, eg. historic landfill sites in the UK.

The source code for the map rendering can be found in [alphagov/datagovuk_find javascript assets](https://github.com/alphagov/datagovuk_find/tree/master/app/assets/javascripts/map-preview). Maps are comprised of client-side javascript on top of [OpenLayers](https://openlayers.org/) and [Ext](https://www.sencha.com/extjs-for-open-source/) 3rd party javascript libraries.

## Key OpenLayers map preview concepts

OpenLayers is a slip map javascript framework, conceptually similar to Google Maps.
Maps are comprised of a central map element which can be layered with additional data features such as bounded boxes, polygons and data points.
The underlying map image is a series of tiled images which can be retrieved from an external service.
Similarly the features which are overlayed on the map may come from external sources.

[Data.gov.uk find](https://data.gov.uk/search?q=&filters%5Bpublisher%5D=&filters%5Btopic%5D=&filters%5Bformat%5D=WMS&sort=best) maps typically group data features into sets which appear in a menu on the left hand side of the map. These controls allow the user to toggle visibility of the data features.

## External WMS data

The map preview page requests data from WMS compliant external APIs which respond with feature information (eg. data points or polygons) which can be toggled to appear on the maps. Subsequent interactions with the features may in turn request more information from these APIs.
Some of these requests are made via the controller proxy methods in the [datagovuk_find app](https://github.com/alphagov/datagovuk_find), and some requests are made via the OpenLayers Web Map Service libraries.

## External dependencies

Map previews rely on two Ext.js libraries, proj4j and OpenLayers plus some accompanying CSS assets. These are all currently hosted on the domain osinspiremappingprod.ordnancesurvey.co.uk, there's potential for the service to fail should these assets become unavailable.

## Common problems

### Map preview link not available

There are some cases where the map preview link is not showing despite the WMS service being available, this may be due to an incompatibility of the WMS service or the resource type being a dataset rather than a service.

Harvesting errors might be available in the harvest job logs:

https://ckan.publishing.service.gov.uk/harvest/[dataset name]/job

In order to begin investigating this issue you can use the link below which will provide further information:

https://ckan.publishing.service.gov.uk/api/action/package_show?id=[dataset name or uuid]

### Map preview not showing

Some communication with external endpoints is handled by OpenLayers WMS functionality. It's important that the external API can process the call for the corresponding version. OpenLayers is configured to use the latest version of the WMS spec (1.3.0) it's possible that some WMS endpoints will respond with an error unless the correct type of request is made.

There's also plenty of scope for a data set to contain WMS data relating to a WMS endpoint which is no longer available or has been updated or upgraded. Investigating the AJAX calls and other requests (eg. requests for map tiles) to the relevant WMS API can often shed light on why specific map functionality is not working.
