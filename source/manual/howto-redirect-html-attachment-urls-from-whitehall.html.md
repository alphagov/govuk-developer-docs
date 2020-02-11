---
owner_slack: "#govuk-developers"
title: Redirect an HTML attachment's URL in Whitehall
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-11
review_in: 6 months
---

HtmlAttachments belong to an Edition of a Document. When an Edition is unpublished or withdrawn,
there is an option to add a redirect to the URL. This redirect should also be applied to the Edition's
HtmlAttachments, and the new URL sent to the PublishingAPI.

This process does not always work successfully, and HtmlAttachments for unpublished Editions remain
accessible via their original URL.

### Redirect an Edition's HtmlAttachments

##### Whitehall

A Rake Task exists in Whitehall to quickly redirect all HtmlAttachments for an unpublished Edition.
The task takes the Edition's Document's content id, and the desired redirection URL.

There are two interfaces for dry and real runs, to ensure the correct HtmlAttachments are being targeted before redirecting.

**Note**
> The Rake task will search for most recent Edition belonging to the Document.
> The task will throw an `EditionNotUnpublished` error if the Edition is not `unpublished` or `withdrawn`.
> The task will throw a `HTMLAttachmentsNotFound` error if the Edition has no HtmlAttachments.


###### Dry run

```bash
$ bundle exec 'publishing_api:redirect_html_attachments:dry[document_content_id,redirection_url]'
```

[Jenkins - integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=%27publishing_api:redirect_html_attachments:dry[DOCUMENT_CONTENT_ID,REDIRECTION_URL]%27)

> You need to find the `content_id` of the Document the attachment belongs to via Rails console if the Document has already been unpublished and redirected.
> Remember to use the relative path for an internal URL. Example:
```
publishing_api:redirect_html_attachments:dry[f8781a75-9fb7-409a-a37d-3a5877ad28fb,/government/collections/trading-with-the-eu-if-the-uk-leaves-without-a-deal]
```
> Note: Please make sure the REDIRECTION_URL starts with a `/`, otherwise the redirection will not work.

This attempts to locate the HtmlAttachments for the latest unpublished Edition of the Document, and if found, report to the user the HtmlAttachment's slugs and where they would have been redirected to.

###### Real run

```bash
$ bundle exec 'publishing_api:redirect_html_attachments:real[document_content_id,redirection_url]'
```

[Jenkins - integration](https://deploy.integration.publishing.service.gov.uk/job/run-rake-task/parambuild/?delay=0sec&TARGET_APPLICATION=whitehall&MACHINE_CLASS=whitehall_backend&RAKE_TASK=%27publishing_api:redirect_html_attachments:real[DOCUMENT_CONTENT_ID,REDIRECTION_URL]%27)

This will actually request that the PublishingApi redirects the selected HtmlAttachments.

**Note**
> Republishing the Edition will cause all redirects to be removed, and the HtmlAttachments will again be accessible via their
> original URL's, as linked to in the Edition.
