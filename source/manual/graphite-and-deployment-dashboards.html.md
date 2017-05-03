---
owner_slack: "#2ndline"
title: Graphite and deployment dashboards
section: Tools
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2017-03-09
review_in: 6 months
---

# Graphite and deployment dashboards

## How Graphite is used with deployment dashboards

Graphite is a data storage application for time stream data that is used to store data performance data, error counts and other statistics about gov.uk servers.

All data is stored with a key which is made up of multiple nodes which each node in the key representing a particular aspect of the data item - i.e. server name or metric type.

In addition to data storage is it possible to use graphite functions to manipulate the data streams, the below is a list of the most use functions/combinations of functions use in the dashboards. Full Graphite documentation can be found [here](http://graphite.readthedocs.io/en/0.9.13-pre1)

### [hitcount](http://graphite.readthedocs.io/en/0.9.13-pre1/functions.html#graphite.render.functions.hitcount)

This is helpful when trying to get actual volumes out of graphite as data is events per second for the time interval (usually but not always 5 seconds). This means that a value of 0.2 represents a single event in a 5 second interval, and means that summing the data in Grafana results in not integer values.  Wrapping the data in `hitcount` will convert it back to the expected count value.

The second parameter is the interval size that is summed together. Care must be taken with this value as data can be lost when a large time period is queried with a small interval, increasing the number of data points returned can ensure accurate data at the cost of performance.

### [integral](http://graphite.readthedocs.io/en/0.9.13-pre1/functions.html#graphite.render.functions.integral) + hitcount

Integral creates returns the sum of values for the time period, or if graphing the sum of values up until that point in time. Used with `hitcount` it can help by ensuring no data is lost as a result of using a small interval with a large time period.

The resulting data should not be graphed as in most cases, unless it is to compare to similar data with a time offset.

### [aliasByNode](http://graphite.readthedocs.io/en/0.9.13-pre1/functions.html#graphite.render.functions.aliasByNode)

Used to extract one node out of the key and then use that as the name of the data column. This is particularly helpful when needing to group summaries data.

### [sumSeries](http://graphite.readthedocs.io/en/0.9.13-pre1/functions.html?#graphite.render.functions.sumSeries)

Sum series data together, can be used by itself to return a single stream of data or with `aliasByNode` to return grouped sets of data.
