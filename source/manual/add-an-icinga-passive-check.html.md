---
owner_slack: "#govuk-developers"
title: Add an Icinga passive check to a Jenkins job
section: Monitoring
layout: manual_layout
parent: "/manual.html"
---

If you would like Icinga to raise an alert when a Jenkins job has not completed
successfully in a while, you can add an Icinga passive check to the Jenkins job
by configuring Puppet.

1. Add a [parameterized build trigger][] to the Jenkins job you wish to monitor
   in Puppet, so that the success or failure of the job builds will be reported
   to Icinga.

1. If the alert should be a warning rather than a critical alert, configure the
   alert level by setting the status code parameter in the build trigger
   configured in the previous step ([example][warning level example]):

     ```
     NSCA_CODE=1
     ```

     Valid values are 0 = OK, 1 = warning, 2 = critical, 3 = unknown. The
     default is 2.

1. Configure an `icinga::passive_check` [exported resource][] in the Puppet
   manifest file for the Jenkins job you wish to monitor, making sure that the
   service description matches the one used to configure the build trigger
   above.

     You will need to determine an appropriate 'freshness threshold', which
     determines how much time can pass, in seconds, before Icinga will raise a
     'freshness threshold alert'.  You should allow enough time for the interval
     between scheduled builds, plus the time it usually takes the job to run,
     plus a little extra in case the job takes longer than usual.

1. Strongly consider creating a page in this manual which explains the alert and
   suggests how to resolve it.

    In the page metadata, configure the section to be `Icinga alerts`.

    Update the `icinga::passive_check` puppet settings added in the previous
    step: configure the `notes_url` so that it links to your new page.

1. Deploy Puppet.

[parameterized build trigger]: https://github.com/alphagov/govuk-puppet/blob/ddf7d9f0a921638a0fd3e9b69121e766722ddacf/modules/govuk_jenkins/templates/jobs/production/copy_data_to_staging.yaml.erb#L59-L69
[warning level example]:https://github.com/alphagov/govuk-puppet/pull/6118/commits/f162bbd0e7ff9497b4e0b2963121593cda83f3aa#diff-f1cd3cc148bc84dc0ded35ef53cb0dd9R42
[exported resource]: https://github.com/alphagov/govuk-puppet/blob/984ddd98fd81a529cb2ed3215be3c7f0a2a08acd/modules/govuk_jenkins/manifests/job/copy_data_to_integration.pp#L29-L35
