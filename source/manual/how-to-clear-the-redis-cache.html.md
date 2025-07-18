---
owner_slack: "#govuk-search"
title: "How to clear the Redis cache"
parent: "/manual.html"
layout: manual_layout
section: Search on GOV.UK
---

Search API V2 uses [Redis] to track the latest synced payload version for a document. It compares the payload version of the document being synced with the `latest_synced_version` number for that version in the cache.
If the new `payload_version` is less or equal to the `latest_synced_version` the document will fail to sync. The Kibana logs should show an error for the document:

```
[DiscoveryEngine::Sync::Put] Ignored as newer version already synced
```

If this error is occurring for a lot of documents then the best option may be to clear the Redis cache.
The [comparison logic] only executes if publishing-api sends a payload ID and the content_id has been seen before. If the content item isn't present in the cache, then `latest_synced_version` is nil and `sync?` [returns true], so it doesn't reach the comparison logic. Clearing the cache would make it seem as though the content_id hasn't been seen before. So the next time the content item is requeued by publishing-api it will trigger a sync regardless of payload version.

The side effect of doing this is that if you represent every document from publishing-api, every document will be resynced, whereas if it existed in the cache, the sync would have been skipped as it would be known that Vertex already has the latest version of the document.

Using [kubectl]:

1. Find the search-api-v2 redis pod:

    ```
    k get pods | grep search-api-v2

    search-api-v2-65b7d9f8bc-6zttp                               2/2     Running     0             26m
    search-api-v2-65b7d9f8bc-c6tj6                               2/2     Running     0             32m
    search-api-v2-redis-78c497d984-xgc97                         1/1     Running     0             29m
    search-api-v2-worker-5cc69854b4-4x7bk                        1/1     Running     0             32m
    search-api-v2-worker-5cc69854b4-tlgxc                        1/1     Running     0             26m
    search-api-v2-worker-5cc69854b4-w87ql                        1/1     Running     0             29m
    ```

2. Make a note of the name of the Redis pod. e.g. `search-api-v2-redis-78c497d984-xgc97`

3. Run the Redis command-line interface (CLI) directly within the pod

    ```
    k exec -it <pod-name> -- redis-cli
    ```

4. See how many keys there are

    ```
    > info keyspace
    # Keyspace
    db0:keys=1000260,expires=0,avg_ttl=0,subexpiry=0
    ```

5. Clear the cache

    ```
    > flushall
    ```

6. Check that there aren't any keys left

    ```
    > info keyspace
    ```

[Redis]: https://github.com/alphagov/search-api-v2/blob/main/app/services/coordination/document_version_cache.rb#L42
[comparison logic]: https://github.com/alphagov/search-api-v2/blob/main/app/services/coordination/document_version_cache.rb#L24
[returns true]: https://github.com/alphagov/search-api-v2/blob/main/app/services/coordination/document_version_cache.rb#L22C22-L22C43
[kubectl]: /kubernetes/cheatsheet.html#kuberneteseks-cheatsheet-for-gov-uk-developers
