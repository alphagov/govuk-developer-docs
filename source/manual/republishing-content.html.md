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

If the document is in Whitehall, there is a Rake task you can run:

[`publishing_api:republish_document[slug]`][republish-whitehall-doc-jenkins]

For organisations, run:

[`publishing_api:republish_organisation[slug]`][republish-whitehall-org-jenkins]

for document type, run:

[`publishing_api:bulk_republish:document_type[DocumentClass]`][republish-whitehall-document-type-jenkins]

For example:
`/government/case-studies/alexander-dennis-maximum-capacity`
`publishing_api:bulk_republish:document_type[CaseStudies]`

You may wish to test first on Integration:
[`publishing_api:bulk_republish:document_type[DocumentClass]`][republish-whitehall-document-type-jenkins-integration]

## Content Publisher

If the document is in content publisher, there is a [resync Rake task][resync-rake-task] you can run.

You can resync a single document by passing it a content ID and locale:

[`resync:document[a-content-id:locale]`][resync-single-jenkins]

or you can resync all documents:

[`resync:all`][resync-all-jenkins]

[govspeak-repo]: https://github.com/alphagov/govspeak/
[resync-rake-task]: https://github.com/alphagov/content-publisher/blob/master/lib/tasks/resync.rake
[resync-single-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=resync:document[a-content-id:locale]
[resync-all-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=content-publisher&MACHINE_CLASS=backend&RAKE_TASK=resync:all
[republish-whitehall-doc-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:republish_document[slug]
[republish-whitehall-org-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:republish_organisation[slug]
[republish-whitehall-document-type-jenkins]: https://deploy.blue.production.govuk.digital/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:bulk_republish:document_type[DocumentClass]
[vpn]:https://docs.publishing.service.gov.uk/manual/vpn.html
[republish-whitehall-document-type-jenkins-integration]:https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=publishing_api:bulk_republish:document_type[DocumentClass]
[production-access]:https://docs.publishing.service.gov.uk/manual/rules-for-getting-production-access.html
