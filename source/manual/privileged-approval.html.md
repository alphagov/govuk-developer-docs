---
owner_slack: "#govuk-platform-engineering"
title: Obtain approval before using the fulladmin role on AWS
section: Infrastructure
layout: manual_layout
parent: "/manual.html"
---

> ⚠️ To keep GOV.UK secure, use the least privileged role possible.
>

Privileged roles such as fulladmin are very powerful. In general, we use [infrastructure as code](https://www.github.com/alphagov/govuk-infrastructure) to configure our systems, and should use privileged roles only when there is no alternative.

When it is required, get a second person to confirm that the access is appropriate.

## Privileged access approval process (AKA cyber thumb)

1. Find a person who is happy to approve that your access is required.

1. Find the ID of the AWS account you'll be accessing. One way of doing this is by running `gds aws govuk-<environment>-developer -d` from a terminal.

1. Go to the [#cyber-security-notifications Slack channel](https://app.slack.com/client/T8GT9416G/C01V4PPNNUF) and click on the green "Action Notification" button to start the workflow.

1. Write a brief summary of your expected activity, add [the account ID](https://docs.google.com/spreadsheets/d/1c3SoA94floYAwxcf8T_zC2i7z82qk28UgbEhr7FLRx4/edit?usp=sharing) and select the person to approve the action.

1. Submit the form.

1. Once the approver has confirmed that it is expected (you should see an update to the Slack channel) you are free to use your privileged role.

### I made a mistake/put the wrong ID in/accessed using the wrong role

As soon as you realise, let your tech lead or a lead from your area know. Fill in the form as above.

You/they will get a follow-up from someone in senior tech if the monitoring has already been triggered. We understand that mistakes happen. This process is to help reduce the scope for these to be dangerous.

Make sure your habitual access is with a lesser privileged role such as the `developer` role.

### I'm on call and there's no one around

If it is not urgent, wait until people are around. Privileged account use can be risky, so it's best to have a second pair of eyes anyway.

If you need access and it cannot wait, use Pagerduty to call the other on-call engineer. If they are not available, escalate to the GOV.UK Programme Escalations rota.

If you cannot contact anyone useful and you still need to access the system urgently after attempting these actions, then do what you need to. The monitoring/alerting should ensure that someone arrives to help.
