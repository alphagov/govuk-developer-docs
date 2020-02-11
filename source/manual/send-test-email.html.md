---
owner_slack: "#govuk-dev-tools"
title: Send a test email via Notify
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-09-02
review_in: 6 months
---

To send a test email using the dev VM or govuk-docker you will need to follow these steps:

1. Sign in/create a Notify account via [Notify](https://www.notifications.service.gov.uk)
2. Add a new service
3. Click on 'Templates' and create a new template with subject `((subject))` and message `((body))`
4. Add the test email address to the whitelist by clicking on 'API integration' then 'Whitelist' if the test email is different from your Notify account email
5. Then click on 'API keys' and create an API key
6. Select the Key 'Team and whitelist'
7. Run the rake task in email-alert-api using the generated key, template ID and test email

```shell
$ bundle exec rake deliver:to_test_email[$TEST_EMAIL] GOVUK_NOTIFY_API_KEY=$KEY GOVUK_NOTIFY_TEMPLATE_ID=$ID
```

Prefix the command with `govuk-docker run` if you are using govuk-docker.

Your mail box should now have received the email.
