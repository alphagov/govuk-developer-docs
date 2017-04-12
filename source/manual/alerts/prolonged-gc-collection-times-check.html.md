---
title: 'Prolonged GC collection times Check'
parent: /manual.html
layout: manual_layout
section: Icinga alerts
---

# 'Prolonged GC collection times' Check

### What is 'Prolonged GC collection times' check?

This checks when the elasticsearch JVM garbage collection times (in
milliseconds) exceeds critical or warning levels. This is collected by
graphite via collectd from the elasticsearch API.

Currently the check uses graphite function to summarize over a time
period of 5minutes and find the maximum value in that period.

You can find the current value using curl if you SSH into the affected
box:

    curl localhost:9200/_nodes/stats/jvm?pretty

You need to look for the `collection_time_in_millis`. There will be two
values: `old` and `young`. Both are checked by nagios and correspond to
different portions of the JVM heap. The lower these times are, the
better. Another important value is `heap_used_percent`, again this
should be low. If it gets too high it may prevent garbage collection
completing.

### Solutions

Solving this problem largely depends on what the particular box is being
used for.

On boxes where the data in elasticsearch isn't critical (e.g. for
ci-master and ci-agent, where it is only test data) freeing up heap
space can be achieved by deleting indexes:

    curl -XDELETE localhost:9200/<index name>

to delete a specific index, or:

    curl -XDELETE localhost:9200/_all

to delete all indexes. Obviously run these with extreme care!

### Places to investigate?

-   Make sure this is not affecting the gov.uk site search if coming
    from elasticsearch search boxes.
-   Make sure not leading to loss of log lines if coming from
    elasticsearch logging boxes.

### Further reading

If you are still struggling these links might help but they are very
in-depth.

-   [<http://www.oracle.com/technetwork/java/javase/memorymanagement-whitepaper-150215.pdf>](http://www.oracle.com/technetwork/java/javase/memorymanagement-whitepaper-150215.pdf)
-   [<http://pubs.vmware.com/vfabric52/index.jsp?topic=/com.vmware.vfabric.em4j.1.2/em4j/conf-heap-management.html>](http://pubs.vmware.com/vfabric52/index.jsp?topic=/com.vmware.vfabric.em4j.1.2/em4j/conf-heap-management.html)

