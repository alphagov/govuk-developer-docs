---
owner_slack: "#2ndline"
title: Add an Icinga passive check to a Jenkins job
section: Monitoring
layout: manual_layout
parent: "/manual.html"
old_path_in_opsmanual: "../opsmanual/infrastructure/howto/add_a_passive_check_to_jenkins.md"
last_reviewed_on: 2017-03-08
review_in: 6 months
---

> **This page was imported from [the opsmanual on github.gds](https://github.gds/gds/opsmanual)**.
It hasn't been reviewed for accuracy yet.
[View history in old opsmanual](https://github.gds/gds/opsmanual/tree/master/infrastructure/howto/add_a_passive_check_to_jenkins.md)


If you would like Icinga to raise an alert when a Jenkins job has not completed
successfully in a while, you can add an Icinga passive check to the Jenkins
job by configuring Puppet.

1. Add a [parameterized build trigger][] to the Jenkins job you wish to monitor
   in Puppet, so that the success or failure of the job builds will be reported
   to Icinga.

1. Configure an ``icinga::passive_check`` [exported resource][] in the Puppet
   manifest file for the Jenkins job you wish to monitor, making sure that the
   service description matches the one used to configure the build trigger
   above.

   You will need to determine an appropriate 'freshness threshold', which
   determines how much time can pass, in seconds, before Icinga will raise a
   'freshness threshold alert'.  You should allow enough time for the interval
   between scheduled builds, plus the time it usually takes the job to run,
   plus a little extra in case the job takes longer than usual.

1. Deploy Puppet.

[parameterized build trigger]: https://github.com/alphagov/govuk-puppet/blob/ddf7d9f0a921638a0fd3e9b69121e766722ddacf/modules/govuk_jenkins/templates/jobs/production/copy_data_to_staging.yaml.erb#L59-L69
[exported resource]: https://github.com/alphagov/govuk-puppet/blob/bb67dbf6a87e43588a2def759a114b5c142ba293/modules/govuk_jenkins/manifests/job/production/copy_data_to_staging.pp#L20-L29
