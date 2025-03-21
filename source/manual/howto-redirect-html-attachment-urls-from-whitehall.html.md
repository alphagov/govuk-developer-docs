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

This process is mainly designed for unpublished Editions, ensuring that their HtmlAttachments are redirected as well.
However, in some cases, HtmlAttachments from older Editions, which still have an active document, may persist and remain
accessible through their original URL. In such situations, the Rake Task outlined below can still be used to redirect
these attachments, ensuring outdated links are no longer publicly accessible.

### Redirect an Edition's HtmlAttachments

#### Whitehall

The Rake Task in Whitehall allows you to quickly redirect all HtmlAttachments for an Edition. The task takes the Edition's
Document's content id, and the desired redirection URL.

There are two interfaces for dry and real runs, to ensure the correct HtmlAttachments are being targeted before redirecting.

**Note**
> The task will raise an EditionNotUnpublished error if the Edition is neither unpublished nor withdrawn. Note that this does not necessarily conflict with cases
> where old HTML attachments persist while the parent document remains live, as the edition associated with the attachment may be unpublished.
> The task will raise a HtmlAttachmentsNotFound error if the Edition contains no HtmlAttachments.

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
