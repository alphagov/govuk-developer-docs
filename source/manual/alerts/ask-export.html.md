---
owner_slack: "#govuk-2ndline-tech"
title: Ask Export has failed
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

# Ask Export has failed

The Ask Export job takes the responses to the [Ask survey][] and puts them into different google drives depending on the intended recipient. This alert means that the nightly export has failed. Please [re-run the job][]. If this doesn't work check the Jenkins output.

The export relies on integrations with Smart Survey, Google and AWS. It could be that an access key has been deleted, a full list of the keys required for this job can be found [in Puppet][].

[Ask survey]: https://www.gov.uk/guidance/ask-the-government-a-question
[re-run the job]: https://deploy.blue.production.govuk.digital/job/govuk-ask-export/
[in Puppet]: https://github.com/alphagov/govuk-puppet/blob/main/modules/govuk_jenkins/manifests/jobs/ask_export.pp
