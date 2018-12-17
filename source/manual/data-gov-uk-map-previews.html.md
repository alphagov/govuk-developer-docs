---
owner_slack: "#govuk-platform-health"
title: WMS map previews on data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-12-17
review_in: 8 weeks
---

## Previewing Web Map Service data on DGU maps

[Data.gov.uk find](https://docs.publishing.service.gov.uk/apps/datagovuk_find.html) provides a map preview for Web Map Service (WMS) data. This data is represented as features on a map, eg. historic landfill sites in the UK.

The source code for the map rendering can be found in [alphagov/datagovuk_find javascript assets](https://github.com/alphagov/datagovuk_find/tree/master/app/assets/javascripts/map-preview). Maps are comprised of client-side javascript on top of [OpenLayers](https://openlayers.org/) and [Ext](https://www.sencha.com/extjs-for-open-source/) 3rd party javascript libraries.


## Key OpenLayers map preview concepts

OpenLayers is a slip map javascript framework, conceptually similar to Google Maps.  
Maps are comprised of a central map element which can be layered with additional data features such as bounded boxes, polygons and data points.  
The underlying map image is a series of tiled images which can be retrieved from an external service.  
Similarly the features which are overlayed on the map may come from external sources.

[Data.gov.uk find](https://docs.publishing.service.gov.uk/apps/datagovuk_find.html) maps typically group data features into sets which appear in a menu on the left hand side of the map. These controls allow the user to toggle visibility of the data features.


## External WMS data

The map preview page requests data from WMS compliant external APIs which respond with feature information (eg. data points or polygons) which can be toggled to appear on the maps. Subsequent interactions with the features may in turn request more information from these APIs.
Some of these requests are made via the controller proxy methods in the [datagovuk_find app](https://github.com/alphagov/datagovuk_find), and some requests are made via the OpenLayers Web Map Service libraries.

## External dependencies

Map previews rely on two Ext.js libraries, proj4j and OpenLayers plus some accompanying CSS assets. These are all currently hosted on the domain osinspiremappingprod.ordnancesurvey.co.uk, there's potential for the service to fail should these assets become unavailable.


## Common problems

Some communication with external endpoints is handled by OpenLayers WMS functionality. It's important that the external API can process the call for the corresponding version. OpenLayers is configured to use the latest version of the WMS spec (1.3.0) it's possible that some WMS endpoints will respond with an error unless the correct type of request is made.

There's also plenty of scope for a data set to contain WMS data relating to a WMS endpoint which is no longer available or has been updated or upgraded. Investigating the AJAX calls and other requests (eg. requests for map tiles) to the relevant WMS API can often shed light on why specific map functionality is not working.
