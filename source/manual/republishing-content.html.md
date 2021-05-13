---
owner_slack: "#govuk-2ndline"
title: Republish content
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

Sometimes it may be necessary to republish content to make it show up on the website. For example if we make an update to [govspeak][govspeak-repo] that would require us to re-render and save new HTML for content.

This process varies per app and requires

- Connection to the [VPN][vpn] and
- [Production access][production-access]

## Whitehall

If the documents are in Whitehall, there are Rake tasks you can run as outlined below. Try to pick the one most focused to the scope of what you need to republish to avoid unnecessary load. You can monitor the effect on the publishing queue via these Grafana dashboards:

- [integration](https://grafana.integration.publishing.service.gov.uk/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=whitehall&var-Interval=$__auto_interval)
- [staging](https://grafana.blue.staging.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=whitehall&var-Interval=$__auto_interval)
- [production](https://grafana.blue.production.govuk.digital/dashboard/file/sidekiq.json?refresh=1m&orgId=1&var-Application=whitehall&var-Interval=$__auto_interval)

[`publishing_api:republish_document[slug]`][republish-whitehall-doc-jenkins]

For organisations, run:

[`publishing_api:republish_organisation[slug]`][republish-whitehall-org-jenkins]

For all of a single document type, run:

[`publishing_api:bulk_republish:document_type[DocumentClass]`][republish-whitehall-document-type-jenkins]

For example:
`/government/case-studies/alexander-dennis-maximum-capacity`
`publishing_api:bulk_republish:document_type[CaseStudies]`

You may wish to test first on Integration:
[`publishing_api:bulk_republish:document_type[DocumentClass]`][republish-whitehall-document-type-jenkins-integration]

For a short list of Content IDs, run:
[`publishing_api:bulk_republish:republish_documents_by_content_ids[content_id_1 content_id_2]`][republish-whitehall-content-ids-jenkins]

For a significant number of Content IDs:
Some preparation is needed for this as a CSV file needs to be in place. The CSV should have a column called content_id that contains all the relevant IDS. This should be added to the whitehall repository at:
lib/tasks/{FILENAME}.csv
[`publishing_api:bulk_republish:republish_documents_by_content_ids_from_csv[csv_file_name]`][republish-whitehall-csv-jenkins]
Ensure that the CSV is removed again after the job completes.

To republish all documents:
Caution: this is a lot of content and will take hours to complete. If it is possible to scope the republish do so and use a different task, but if you have made a change such as something in govspeak that will affect the majority of content, this is available. Before running this job confirm with 2nd line that they are happy for you to proceed as it could cause backed up publishing queues and alerts.

[`publishing_api:bulk_republish:all`][republish-whitehall-all-jenkins]

## Content Publisher

If the document is in content publisher, there is a [resync Rake task][resync-rake-task] you can run.

You can resync a single document by passing it a content ID and locale:

[`resync:document[a-content-id:locale]`][resync-single-jenkins]

or you can resync all documents:

[`resync:all`][resync-all-jenkins]

[govspeak-repo]: https://github.com/alphagov/govspeak/
[resync-rake-task]: https://github.com/alphagov/content-publisher/blob/main/lib/tasks/resync.rake
[resync-single-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=resync:document[a-content-id:locale]
[resync-all-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=resync:all
[republish-whitehall-doc-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:republish_document[slug]
[republish-whitehall-org-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:republish_organisation[slug]
[republish-whitehall-document-type-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:bulk_republish:document_type[DocumentClass]
[republish-whitehall-content-ids-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:bulk_republish:republish_documents_by_content_ids[content_id_1%20content_id_2]
[republish-whitehall-csv-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:bulk_republish:publishing_api:bulk_republish:republish_documents_by_content_ids_from_csv[csv_file_name]
[republish-whitehall-all-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:bulk_republish:all
[vpn]:https://docs.publishing.service.gov.uk/manual/vpn.html
[republish-whitehall-document-type-jenkins-integration]:https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:bulk_republish:document_type[DocumentClass]
[production-access]:https://docs.publishing.service.gov.uk/manual/rules-for-getting-production-access.html
