---
owner_slack: "#govuk-developers"
title: Communicate when Slack is unavailable
parent: "/manual.html"
layout: manual_layout
section: Incident response
type: learn
---

If Slack has an outage, we use Google Spaces as a fallback.

A "space" is roughly equivalent to a Slack channel, allowing async adding/removing of members, and the ability to create threads for conversation.

For the equivalent of Slack's direct messages, use Google Chat.

## How to use Google Spaces

Visit [gmail.com](https://gmail.com) and click on "Spaces" on the left.
Any spaces you are a member of will appear in a list on the left.

You can click on "Browse spaces" to see all of the joinable spaces in the organisation, which you can "Preview" or "Join".
You can also [create a new space](#how-to-configure-a-google-space).

## How to configure a Google Space

From the [Google Spaces page](#how-to-use-google-spaces), click "New space".

- Give your space a useful name and description.
- Consider what the "Space access" should be.
  - By default, it is "Restricted". This is roughly the equivalent of a private Slack channel.
  - Alternatively, you can set the access to "All of digital.cabinet-office.gov.uk", which allows anyone with that email address to be able to find and join it. This is roughly the equivalent of a public Slack channel.
- From this screen, you can invite people to join the space. You can also do so after you've created the space.

If your space is "Restricted", you'll need to invite every relevant person, as they will be unable to find the space through "Browse spaces". Rather than adding people individually, consider if there is a Google Group email address you can invite instead (e.g. a team email address if you are setting up a team space).

- Google will treat the group email address as "Invited", rather than "Added" to the space.
- Members of the Google group will be able to discover your space using "Browse spaces".
- This means you won't have to worry about keeping your list of team members in sync with your 'space'.

## On-Call Google Space

There is a persistent [GOV.UK Technical On-Call - Google Space](https://mail.google.com/mail/u/0/#chat/space/AAAAuQLSk78), to which the [GOV.UK Technical On-Call Comms Google Group](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/gov-uk-technical-oncall-comms) is invited as a member. Everyone on call should therefore be able to use the Google space in the event of a Slack outage.
