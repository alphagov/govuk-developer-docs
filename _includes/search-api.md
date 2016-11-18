---
layout: default
title: Search API
navigation_weight: 75
source_url: https://github.com/alphagov/rummager/blob/master/docs/search-api.md
edit_url: https://github.com/alphagov/rummager/edit/master/docs/search-api.md
---
 <!-- This file was automatically generated. DO NOT EDIT DIRECTLY. --> 

This API is the main endpoint for performing searches on GOV.UK.  It supports
keyword searching, ordering by relevance or date fields, filtering and
faceting.

At the time of writing, there is one other endpoint, the `advanced_search`
endpoint, which is slowly being replaced by the `search` endpoint.  The
`advanced_search` endpoint shouldn't be used by new code.

## Parameters

The search API supports many query string parameters.  It validates
parameters strictly - any unknown parameters, or parameters with invalid
options, will cause an HTTP 422 error.  This makes it likely that typos do not
result in silently returning the wrong results, and also makes it easier to
modify the API to add new features without risking breaking old calls.

Note that query parameters which are repeated may be specified in standard HTTP
style (ie, `name=value&name=value`, where the same name may be used multiple
times), or in Ruby/PHP array style (ie, `name[]=value&name[]=value`).  The `[]`
is simply ignored. This allows for easy calling from Ruby-style frameworks, or
from other languages which use standard HTTP conventions.  No more complex
structures are passed in the API.

The parameters supported are:

 - `q`: (single string) User-entered search query.  This should be exactly what
   the user typed into a search box, encoded as `UTF-8`.  Any well-formed
   `UTF-8` values are allowed.  Lots of complex processing will be performed on
   this field to try to determine the best matching documents for the query.

 - `start`: (single integer) Position in search result list to start returning
   results (0-based)  If the `start` offset is greater than the number of
   matching results, no results will be returned (but also no error will be
   returned).

 - `count`: (single integer) Maximum number of search results to return.  If
   insufficient documents match, as many as possible are returned (subject to
   the supplied `start` offset).  This may be set to 0 to return no results
   (which may be useful if only, say, facet values are wanted).  Setting this
   to 0 will reduce processing time.

 - `order`: (single string) The sort order.  A field name, with an optional
   preceding "`-`" to sort in descending order.  If not specified, sort order
   is relevance.  Only some fields can be sorted on - an HTTP 422 error will be
   returned if the requested field is not a valid sort field.

 - `filter_FIELD`: (single string, where `FIELD` is a field name); a filter to
   apply to a field.

   Multiple values may be given, and filters may be specified for multiple
   fields at once.  The filters are grouped by field name; documents will only
   be returned if they match all of these filter groups, and they will be
   considered to match a filter group if any of the individual filters in that
   group match (ie, only one of the values specified for a field needs to
   match, but all fields with any filters specified must match at least one
   value).

   The special value `_MISSING` may be specified as a filter value - this will
   match documents where the field is not present at all.

   For string fields, values are the field value to match.

   For date fields, values are date ranges.  These are specified as comma
   separated lists of `key:value` parameters, where `key` is one of `from` or
   `to`, and the value is an ISO formatted date (with no timezone).  UTC is
   assumed for all dates handled by rummager.  Date ranges are inclusive of
   their endpoints.

   For example: `from:2014-04-01 00:00,to:2014-04-02 00:00` is a range for 24
   hours from midnight at the start of April the 1st 2014, including midnight
   that day or the following day.

   Currently, it is not permitted to specify multiple values for a date field
   filter.

   Only some fields can be filtered on - an HTTP 422 error will be returned if
   the requested field is not a value sort field.

 - `reject_FIELD`: (single string where `FIELD` is a field name); a
   reject-filter to apply to a field.  This behaves just like a filter, but
   will return documents which don't match any of the supplied values for a
   field.

   If a filter and a reject are specified for the same field, an HTTP 422 error
   will be returned.  However, it is valid to specify a reject for some fields
   and a filter for others - documents will be required to match the criteria
   on both fields.

 - `facet_FIELD`: (single string where `FIELD` is a field name); count up
   values which are present in the field in the documents matched by the
   search, and return information about these.

   The value of this parameter is a comma separated list of options; the first
   option in the list is an integer which controls the requested number of
   distinct field values to be returned for the field.  Regardless of the
   number set here, a value will be returned for any filter which is in place
   on the field. This may cause the requested number of values to be exceeded.

   Subsequent options are optional, and are represented as colon separated
   key:value pairs (note, colon separated instead of comma, since commas are
   used to separate options).

   - `scope`: One of `all_filters` and `exclude_field_filter` (the default).

     If set to `all_filters`, the facet counts are made after applying all the
     filters.  If set to `exclude_field_filter`, the facet counts are made
     after applying all filters _except_ for those applied to the field that
     the facets are being counted for.  This is a convenient option for
     calculating values to show in common interfaces which use facets for
     narrowing down search results.

   - `order`: Colon separated list of ordering types.

     The available ordering types are:

      - `filtered`: whether the value is used in an active filter.  This can be
	used to sort such that the values which are being filtered on come
	first.
      - `count`: order by the number of documents in the search matching the
	facet value.
      - `value`: sort by value if the field values are string, sort by the
	`title` field in the value object if the value is an object.  Sorting
	is case insensitive in either case.
      - `value.slug`: the slug in the facet value object
      - `value.link`: the link in the facet value object
      - `value.title`: the title in the facet value object (case insensitive)

     Each ordering may be preceded by a "-" to sort in descending order.
     Multiple orderings can be specified, in priority order, separated by a
     colon.  The default ordering is "filtered:-count:slug".

   - `examples`: integer number of example values to return

     This causes facet values to contain an "examples" hash as an additional
     field, which contains details of example documents which match the query.
     The examples are sorted by decreasing popularity.  An example facet value
     in a response with this option set as "examples:1" might look like:

        "value" => {
          "slug" => "an-example-facet-slug",
          "example_info" => {
            "total" => 3,  # The total number of matching examples
            "examples" => [
              {"title" => "Title of the first example", "link" => "/foo"},
            ],
          }
        }

   - `example_scope`: `global` or `query`.  If the `examples` option is supplied, the
     `example_scope` option must be supplied too.

     The value of `global` causes the returned examples to be taken from all
     documents in which the facet field has the given slug.

     The value of `query` causes the returned examples to be taken only from
     those documents which match the query (and all filters).

   - `example_fields`: colon separated list of fields.

     If the examples option is supplied, this lists the fields which are
     returned for each example.  By default, only a small number of fields are
     returned for each.

 - fields: fields to be returned in the result documents.  By default, and for
   backwards compatibility, a fairly long set of fields is currently returned,
   but it is good practice to set this to only the fields you actually want
   information on (doing this will normally increase performance).

## Examples

For example:

    /search.json?
     q=foo&
     start=0&
     count=20&
     order=-public_timestamp&
     filter_organisations[]=cabinet-office&
     filter_organisations[]=driver-vehicle-licensing-agency&
     filter_section[]=driving
     facet_organisations=10

Returns something like:

```json
{
  "results": [
    {...},
    {...}
  ],
  "total": 19,
  "offset": 0,
  "spelling_suggestions": [
    ...
  ],
  "facets": {
    "organisations": {
      "options": [
        {
          "value": "department-for-business-innovation-skills",
          "documents": 788
        }, ...],
      "documents_with_no_value": 1610,
      "total_options": 94,
      "missing_options": 84
    }
  }
}
```
