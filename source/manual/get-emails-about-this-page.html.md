---
title: "Handle exemptions to the ‘Get emails about this page’ feature"
section: Emails
layout: manual_layout
owner_slack: "#find-and-view-govuk"
parent: "/manual.html"
---

The [‘get emails about this page’ button][get-emails-about-this-page] was rolled out to most Whitehall publications, consultations and detailed guides on 1 March 2022.

## Existing exemptions

Before rolling out the feature, the GOV.UK account team contacted 14 departments who had content that offered users a work-around for subscribing to page-level updates.

Departments asked for these 4 pages to be excluded from the roll-out:

- <https://www.gov.uk/guidance/dvsa-email-alerts>
- <https://www.gov.uk/guidance/hmcts-reform-programme-monthly-bulletin>
- <https://www.gov.uk/guidance/coronavirus-guidance-for-the-sellafield-ltd-supply-chain>
- <https://www.gov.uk/government/collections/ip-connect-newsletter>

If content teams in departments ever ask us to add the button to these pages, it’s OK to do that.

## Future exemptions

If departments ask for any more pages to be excluded, we should try to refuse them on the grounds that:

1. We want to have as few exclusions as possible because it’s important for users to have a consistent experience of GOV.UK.

2. Whether we add the button to a page or not, the act of publishing or updating a page will continue to trigger a notification to users who have subscribed to the organisation or topics the page is tagged to.

## How to add or remove an exemption

If you must add or remove an exemption, update the [exemption list][exemption-list] by adding or removing the `content_id` of the publication which needs to be added or removed from the list.

[get-emails-about-this-page]: https://components.publishing.service.gov.uk/component-guide/single_page_notification_button
[exemption-list]: https://github.com/alphagov/government-frontend/blob/6ecd50c198565dc9bafdb72cb42b15411e795ad2/app/presenters/content_item/single_page_notification_button.rb#L4
