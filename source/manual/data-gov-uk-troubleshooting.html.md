---
owner_slack: "#govuk-platform-health"
title: Troubleshooting data.gov.uk
section: data.gov.uk
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-16
review_in: 6 weeks
---
[find]: apps/datagovuk_find
[publish]: apps/datagovuk_publish
[ckan]: apps/ckanext-datagovuk

## Different number of datasets in [CKAN] to [Find]

Determine the number of datasets in CKAN using the API.

```
https://data.gov.uk/api/3/search/dataset
```

Determine the number of datsets in the Publish Postgres database using the Rails console.

```
cf ssh publish-data-beta-production
/tmp/lifecycle/launcher /home/vcap/app 'rails console' ''
>>> Dataset.count
```

If these numbers match, but the number of datasets served on Find is still different, identify the number of published in the Publish Postgres database.

```
cf ssh publish-data-beta-production
/tmp/lifecycle/launcher /home/vcap/app 'rails console' ''
>>> Dataset.published.count
```

With the current set up, all datasets that are available through the CKAN API will be marked as public in the Publish Postgres database.  Therefore, if you get a different number of datasets, you should mark them all as published in the Publish Postgres database.

```
cf ssh publish-data-beta-production
/tmp/lifecycle/launcher /home/vcap/app 'rails console' ''
>>> Dataset.update(status: 'published')
```

A [reindex](/manual/data-gov-uk-operations.html#reindexing-find) must then be done to update the status with the Elastic instance that serves Find.

## Datasets published in CKAN are not appearing on Find

Check the Sidekiq queue (see [monitoring section](/manual/data-gov-uk-monitoring.html#sidekiq-publish)) length to ensure the queue length is not too long.  You should not be seeing more jobs than the number of datasets in CKAN.

If the queue is too long, you should clear the queue.  The next sync process will repopulate the queue with any relevant datasets that require updating.

## Celery not processing background tasks

There are a few tasks run by Celery on the Bytemark machine. This includes
adding preview links to data files with a `WMS` format.

You can first check to see if Celery is working properly by looking in the log
files:

```
(ckan)co@prod3 /vagrant/src/ckan (release-v2.2-dgu) $ tail /var/log/ckan/celeryd.log
    from ckanext.harvest.harvesters.ckanharvester import CKANHarvester
  File "/vagrant/src/ckanext-harvest/ckanext/harvest/harvesters/ckanharvester.py", line 4, in <module>
    from urllib3.contrib import pyopenssl
  File "/home/co/ckan/local/lib/python2.7/site-packages/urllib3/contrib/pyopenssl.py", line 48, in <module>
    from cryptography.hazmat.backends.openssl import backend as openssl_backend
  File "/home/co/ckan/local/lib/python2.7/site-packages/cryptography/hazmat/backends/openssl/__init__.py", line 7, in <module>
    from cryptography.hazmat.backends.openssl.backend import backend
  File "/home/co/ckan/local/lib/python2.7/site-packages/cryptography/hazmat/backends/openssl/backend.py", line 23, in <module>
    from cryptography.hazmat.backends.openssl import aead
ImportError: cannot import name aead
```

If you see a lot of tracebacks, it might be necessary to restart Celery. You
can do this by killing each Celery process one by one and they will get
restarted automatically.

```
(ckan)co@prod3 /vagrant/src/ckanext-harvest (2.0) $ ps aux | grep celery
co       14857  0.0  0.0  11472   964 pts/2    S+   13:51   0:00 grep --color=auto celery
www-data 14898  0.0  0.6 846200 222476 ?       S    Oct12   0:04 /home/co/ckan/bin/python /home/co/ckan/bin/paster --plugin=ckan celeryd run concurrency=4 --queue bulk --config=/var/ckan/ckan.ini
www-data 14917  0.0  0.3 715128 129060 ?       S    Oct12   0:01 /home/co/ckan/bin/python /home/co/ckan/bin/paster --plugin=ckan celeryd run concurrency=4 --queue bulk --config=/var/ckan/ckan.ini
www-data 32359  3.6  0.2 704456 82932 ?        Sl   Apr26 9094:41 /home/co/ckan/bin/python /home/co/ckan/bin/paster --plugin=ckan celeryd run concurrency=4 --queue bulk --config=/var/ckan/ckan.ini
www-data 32360  0.3  0.2 704260 82684 ?        Sl   Apr26 757:43 /home/co/ckan/bin/python /home/co/ckan/bin/paster --plugin=ckan celeryd run concurrency=1 --queue priority --config=/var/ckan/ckan.ini
(ckan)co@prod3 /vagrant/src/ckanext-harvest (2.0) $ sudo kill 32360
(ckan)co@prod3 /vagrant/src/ckanext-harvest (2.0) $ sudo kill 32359
(ckan)co@prod3 /vagrant/src/ckanext-harvest (2.0) $ sudo kill 14917
(ckan)co@prod3 /vagrant/src/ckanext-harvest (2.0) $ sudo kill 14898
```

You would then expect to see something like this in the log file:

```
(ckan)co@prod3 /vagrant/src/ckanext-harvest (2.0) $ tail /var/log/ckan/celeryd.log
[2018-10-16 13:52:18,569: INFO/PoolWorker-1] child process calling self.run()
[2018-10-16 13:52:18,570: INFO/PoolWorker-2] child process calling self.run()
[2018-10-16 13:52:18,571: INFO/PoolWorker-3] child process calling self.run()
[2018-10-16 13:52:18,573: INFO/PoolWorker-4] child process calling self.run()
[2018-10-16 13:52:18,574: WARNING/MainProcess] celery@bulk has started.
```
