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
[link-4]: https://github.com/alphagov/search-admin/blob/main/lib/tasks/document.rake#L8
[link-5]: https://github.com/alphagov/search-admin/blob/main/lib/tasks/document.rake#L15

## Interacting with the Discovery Engine REST API

Sometimes it can be useful to manually interact with the [Discovery Engine REST API][link-1] for debugging purposes. Make sure you have the [Google Cloud CLI installed][link-2] and configured for this.
The following example commands assume the production project, you should change both the header and the URL as appropriate if you want to access a different project’s resources.

__Important__: Remember to revoke any local auth credentials once you’ve finished working with gcloud:

``` ruby
gcloud auth revoke
```

or

```
gcloud auth application-default revoke
```

### Get a document from the datastore

There are two different ways to get a document from the document store: [using the document:get_document rake task](#use-the-get_document-rake-task) or [calling the get document endpoint](#call-the-get-document-endpoint).

#### Use the get_document rake task

A [rake task][link-5] exists to provide a convenient way for a developer to quickly check if a document is present in the data store. The rake task pretty prints the `json_data` of the document.

```
$ kubectl -n apps exec -it deploy/search-admin -- bundle exec rake document:get_document[<content_id>]
```

If you need the full document, rather than just the `json_data`, you should [call the get document endpoint](#call-the-get-document-endpoint) instead of using this rake task.

#### Call the get document endpoint

You can get a document’s JSON representation from the datastore using the [projects.locations.collections.dataStores.branches.documents.get][link-3] endpoint (replace `<content_id>` at the end with the UUID-format GOV.UK content ID):

```ruby
curl -sH "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
-H "X-Goog-User-Project: search-api-v2-production" \
"https://discoveryengine.googleapis.com/v1/projects/search-api-v2-production/locations/global/collections/default_collection/dataStores/govuk_content/branches/default_branch/documents/<content_id>"
```

This can be useful for example to check whether a document has been synchronised at all.

Consider piping through JQ to extract information from the response:

```ruby
curl … | jq -r ".jsonData | fromjson" (to get the document’s metadata)
curl …  | jq -r ".content.rawBytes" | base64 -d (to get the document’s unstructured body content)
```

### Delete a document from the datastore

A [rake task][link-4] exists for dire emergencies where a piece of content has not been correctly deleted from the datastore via the normal channels. This can happen when someone deletes a document directly from the Publishing API database without firing the callbacks that trigger a message queue `unpublish` message.

```
$ kubectl -n apps exec -it deploy/search-admin -- bundle exec rake document:delete_document[<content_id>]
```

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
