---
owner_slack: "#govuk-2ndline"
title: Pingdom search check
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
---

If Pingdom can't retrieve the search results page, it means that while GOV.UK
may be available, it is not possible to retrieve dynamic content. Assuming that
the homepage check has not failed, the CDN is probably OK. It is possible for
our main provider (Carrenza/AWS) to be down and for us to serve static content
from a secondary mirror at a second supplier (AWS/GCP).

This is not as critical a problem as you might assume, because a large amount
of traffic from external searches goes directly to static content and can be
served from the mirror. Debug as normal by walking through the stack backwards
from the user's perspective to find out where the failure is.
