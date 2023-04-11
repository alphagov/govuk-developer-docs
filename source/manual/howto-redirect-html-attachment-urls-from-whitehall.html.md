---
owner_slack: "#govuk-developers"
title: Redirect an HTML attachment's URL in Whitehall
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

HtmlAttachments belong to an Edition of a Document. When an Edition is unpublished or withdrawn,
there is an option to add a redirect to the URL. This redirect should also be applied to the Edition's
HtmlAttachments, and the new URL sent to the PublishingAPI.

This process does not always work successfully, and HtmlAttachments for unpublished Editions remain
accessible via their original URL.

### Redirect an Edition's HtmlAttachments

#### Whitehall

A Rake Task exists in Whitehall to quickly redirect all HtmlAttachments for an unpublished Edition.
The task takes the Edition's Document's content id, and the desired redirection URL.

There are two interfaces for dry and real runs, to ensure the correct HtmlAttachments are being targeted before redirecting.

**Note**
> The Rake task will search for most recent Edition belonging to the Document.
> The task will throw an `EditionNotUnpublished` error if the Edition is not `unpublished` or `withdrawn`.
> The task will throw a `HTMLAttachmentsNotFound` error if the Edition has no HtmlAttachments.

##### Dry run

```bash
$ bundle exec rake 'publishing_api:redirect_html_attachments:by_content_id_dry_run[document_content_id,redirection_url]'
```

> You need to find the `content_id` of the Document the attachment belongs to via Rails console if the Document has already been unpublished and redirected.
> Remember to use the relative path for an internal URL. Example:

```
publishing_api:redirect_html_attachments:by_content_id_dry_run[f8781a75-9fb7-409a-a37d-3a5877ad28fb,/government/collections/trading-with-the-eu-if-the-uk-leaves-without-a-deal]
```

> Note: Please make sure the REDIRECTION_URL starts with a `/`, otherwise the redirection will not work.

This attempts to locate the HtmlAttachments for the latest unpublished Edition of the Document, and if found, report to the user the HtmlAttachment's slugs and where they would have been redirected to.

##### Real run

```bash
$ bundle exec rake 'publishing_api:redirect_html_attachments:by_content_id[document_content_id,redirection_url]'
```

This will actually request that the PublishingApi redirects the selected HtmlAttachments.

**Note**
> Republishing the Edition will cause all redirects to be removed, and the HtmlAttachments will again be accessible via their
> original URL's, as linked to in the Edition.
