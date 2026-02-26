---
owner_slack: "#govuk-publishing-platform"
title: Current Content API architecture
parent: "/manual.html"
layout: manual_layout
type: learn
section: Publishing
---

> This documentation somewhat duplicates the information in the [links and link expansion documentation](/repos/publishing-api/link-expansion.html).

## Links

GOV.UK has a concept named links. This is where links are defined between document, so that frontend applications can render links to related content on GOV.UK.

These links contain only a reference to the related content item - they don't contain any information about the related content item until they are "expanded". This means the linked document can be updated without the document where the link comes from needing to be updated.

## Link Expansion

Link expansion is the process of converting the stored links of an edition into a JSON representation containing more information about the linked content items.

This occurs in two ways:

- Legacy Link Expansion: this occurs at the time of putting content, patching links and publishing a document. The links for an edition are pre-computed and presented to Content Store. Content Store caches a copy of these links in its database and renders this cached version when requested.
- GraphQL Link Expansion: this occurs at the time of requesting content by the public. The links for an edition are only computed when the document is rendered to a client.

The diagram below demonstrates how requests from publishing applications are handled, with regards to link expansion:

<iframe frameborder="0" style="width:100%;height:515px;" src="https://app.diagrams.net/?tags=%7B%7D&title=Link%20Expansion%20Diagram.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1Dl5oLNv6JulfnRIILu29rDCRn0OqcLDP%26export%3Ddownload"></iframe>

To edit the diagram, visit <https://app.diagrams.net/#G1Dl5oLNv6JulfnRIILu29rDCRn0OqcLDP>.
