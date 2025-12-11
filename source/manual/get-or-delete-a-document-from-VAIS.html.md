---
owner_slack: "#govuk-search"
title: "How to get or delete a document from Vertex"
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
---
[link-1]: https://cloud.google.com/generative-ai-app-builder/docs/reference/rest
[link-2]: /manual/google-cloud-platform-gcp.html#using-the-cli
[link-3]: https://cloud.google.com/generative-ai-app-builder/docs/reference/rest/v1/projects.locations.collections.dataStores.branches.documents/get
[link-4]: https://cloud.google.com/generative-ai-app-builder/docs/reference/rest/v1/projects.locations.collections.dataStores.branches.documents/delete

## Interacting with the Discovery Engine REST API

Sometimes it can be useful to manually interact with the [Discovery Engine REST API][link-1] for debugging purposes. Make sure you have the [Google Cloud CLI installed][link-2] and configured for this.
The following example commands assume the production project, you should change both the header and the URL as appropriate if you want to access a different project’s resources.

### Get a document from the datastore

You can get a document’s JSON representation from the datastore using the [projects.locations.collections.dataStores.branches.documents.get][link-3] endpoint (replace the UUID at the end with the UUID-format GOV.UK content ID):

```ruby
curl -sH "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
-H "X-Goog-User-Project: search-api-v2-production" \
"https://discoveryengine.googleapis.com/v1/projects/search-api-v2-production/locations/global/collections/default_collection/dataStores/govuk_content/branches/default_branch/documents/YOUR-CONTENT-ID-HERE"
```

This can be useful for example to check whether a document has been synchronised at all.

Consider piping through JQ to extract information from the response:

```ruby
curl … | jq -r ".jsonData | fromjson" (to get the document’s metadata)
curl …  | jq -r ".content.rawBytes" | base64 -d (to get the document’s unstructured body content)
```

### Delete a document from the datastore

The same endpoint as above also supports the DELETE method (as [projects.locations.collections.dataStores.branches.documents.delete][link-4]) for dire emergencies where content isn’t correctly deleted through the normal channels. This can happen when someone deletes a document directly from the Publishing API database without firing the callbacks that trigger a message queue unpublish message.

### Perform a search

You can search the engine as follows (replace the POST data with appropriate parameters):

```ruby
curl -XPOST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
-H "X-Goog-User-Project: search-api-v2-production" \
"https://discoveryengine.googleapis.com/v1alpha/projects/search-api-v2-production/locations/global/collections/default_collection/engines/govuk_global/servingConfigs/default:search" \
-d '{ "query": "hello", "filter": "document_type: ANY(\"html_publication\")" }'
```

This may help you debug misbehaving queries, and allow you to get an attribution token if Google support requests one.
