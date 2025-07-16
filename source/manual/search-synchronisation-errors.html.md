---
owner_slack: "#govuk-search"
title: "Search synchronisation errors"
parent: "/manual.html"
layout: manual_layout
section: Search
---

## A document doesn't appear in site search after it is published

When a document is published, publishing API places a message on Rabbit MQ's  `search_api_published_documents` queue.

Search API v2's `document_sync_worker` listens to this queue, and co-ordinates the creation of a PublishingAPIDocument that is then synchronised to the VAIS datastore.

If a document has been successfully published, is live on gov.uk, but is not being returned in search results, the first step is to confirm if this is the expected behaviour.

1. Check the locale of the missing content_item. The document_sync_worker only sends documents with an `en` locale to the datastore.
2. Check the document_type of the missing ContentItem. If it's is on the [document_type_ignorelist] the content has been intentionally ignored by the worker.
3. Check the state of the missing ContentItem. Withdrawn content is desynchronised i.e. removed from the datastore.

If you are sure that the document should be visible in results, you can try the following debugging steps:

1. Check #govuk-search-alerts for any helpful synchronisation errors coming from search-api-v2
2. Inspect the application logs for the search-api-v2-worker in kibana. A quick hacky way to find
  the logs is to set the appropriate time window, and just search for ' "DiscoveryEngine" AND "<content-id>" '. A more systematic approach would be to [filter by] kubernetes.labels.app_kubernetes_io/name: search-api-v2 worker and search for the [content_id].
3. Look for a message that explains why the worker has failed to synchronise the document. One
  possible cause is that the payload version of the message received from the queue is lower than the previous time the document was synced. If this is the cause, [clear the redis cache] and then [resynchronise] the document.

## An unpublished/withdrawn document is still present in search results

When a document is withdrawn or unpublished via the UI in Whitehall, a message is placed on Rabbit MQ's `search_api_published_documents` queue.
Search API v2's document_sync_worker listens to this queue, and co-ordinates the desynchronisation of the document from the VAIS datastore if the document type is on the [UNPUBLISH_DOCUMENT_TYPES list].

If an unpublished document is still visible in search results, you can take the following debugging steps

1. Confirm if the document_sync_worker received a request to update the document. Do this by checking in Kibana by searching for the [content_id].
2. Check for a message which explains why the desynchronisation failed.
3. If there is no log for this request, it could be that the document was manually deleted from the   whitehall database and so no message was placed on the search_api_published_documents queue. If this is the case, you can manually [delete the document from the datastore].

## Wider synchronisation issues

When documents are published or unpublished via a publishing app a message is placed on Rabbit MQ's `search_api_published_documents` queue.

Search API v2's document_sync_worker listens to this queue and should co-ordinate the creation of a PublishingAPIDocument that is then synchronised to or desynchronised from the VAIS datastore.

If all documents that have been successfully published or unpublished on gov.uk, but are not being returned as expected in search results it could be a sign that synchronisation process is failing in general for all documents. You can take the following debugging steps.

1. Check #govuk-search-alerts for any helpful synchronisation errors coming from search-api-v2
1. Confirm if the document_sync_worker received a request to update the document. Do this by checking in Kibana by searching by [content_id] for a few example documents.
2. Check for messages which explains why the desynchronisation failed.
4. One cause is that the payload version of the message received from the queue is lower than the previous time the document was synced. If this is the cause, [clear the redis cache] and then [resynchronise] all documents.
5. If you are see a lot of `Google::Cloud` errors in the logs the likely cause is that VAIS is having issues. [Check the error rates for site search] and follow the steps for what to do [if site search is unavailable].

[document_type_ignorelist]: https://github.com/alphagov/search-api-v2/blob/1c3e8115b15703a44691311a2971ce2dbee10c59/config/document_type_ignorelist.yml
[filter by]: https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/data-explorer/discover#?_a=(discover:(columns:!(_source),isDirty:!f,sort:!()),metadata:(indexPattern:'filebeat-*',view:discover))&_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_q=(filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'filebeat-*',key:kubernetes.labels.app_kubernetes_io%2Fname,negate:!f,params:(query:search-api-v2-worker),type:phrase),query:(match_phrase:(kubernetes.labels.app_kubernetes_io%2Fname:search-api-v2-worker)))),query:(language:kuery,query:''))
[content_id]: https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/data-explorer/discover#?_a=(discover:(columns:!(_source),isDirty:!f,sort:!()),metadata:(indexPattern:'filebeat-*',view:discover))&_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-7d,to:now))&_q=(filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'filebeat-*',key:kubernetes.labels.app_kubernetes_io%2Fname,negate:!f,params:(query:search-api-v2-worker),type:phrase),query:(match_phrase:(kubernetes.labels.app_kubernetes_io%2Fname:search-api-v2-worker)))),query:(language:kuery,query:%22225d80c5-01bb-47d0-b57c-6862efbed7b3%22))
[ignore list]: https://github.com/alphagov/search-api-v2/blob/main/config/document_type_ignorelist.yml
[clear the redis cache]: /manual/how-to-clear-the-redis-cache
[resynchronise]: /manual/how-to-resync-content-in-vertex
[document_sync_worker]: https://github.com/alphagov/search-api-v2/blob/1c3e8115b15703a44691311a2971ce2dbee10c59/lib/tasks/document_sync_worker.rake
[UNPUBLISH_DOCUMENT_TYPES list]: https://github.com/alphagov/search-api-v2/blob/1c3e8115b15703a44691311a2971ce2dbee10c59/app/models/concerns/publishing_api/action.rb#L6
[delete the document from the datastore]: /manual/get-or-delete-a-document-from-VAIS#delete-a-document-from-the-datastore
[Check the error rates for site search]: /manual/what-to-do-if-search-is-down#check-the-error-rates-for-site-search
[if site search is unavailable]: /manual/what-to-do-if-search-is-down#if-site-search-is-unavailable
