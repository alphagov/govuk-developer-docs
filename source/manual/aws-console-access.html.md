---
owner_slack: "#govuk-2ndline"
title: Access the AWS console
section: AWS accounts
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-10-10
review_in: 3 months
old_paths:
  - /manual/seeing-things-in-the-aws-console.html
---

💡 Before you can access something in AWS, you [need to set up your AWS account](/manual/set-up-aws-account.html).

---

In our AWS environment, you temporarily "assume a role" for a sub-account. For example, you can assume the role of "administrator on integration" (which gives you all the power), or "power user on production" (which gives you a more limited set of rights). By default, if you try to click on anything in the AWS console you'll likely see "You are not authorized". This is because you're still in your default account without any permissions.

👉 [Sign in to AWS GDS account first](https://gds-users.signin.aws.amazon.com/console)

Remember that you'll have to have been [added to the appropriate group first][access].

## 1. Click "Switch Role" in the top right corner.

![gds-users-switch-role](images/gds-users-switch-role.png)

## 2. Fill in account and role

Options for "Account":

- `govuk-infrastructure-production`
- `govuk-infrastructure-staging`
- `govuk-infrastructure-integration`
- `govuk-infrastructure-test`

Options for "Role":

- `govuk-administrators`
- `govuk-powerusers`
- `govuk-users`

![gds-users-switch-role-form](images/gds-users-switch-role-form.png)

## 3. Switch to other roles

If you've set all of the roles up, they are then easily accessible from the "Switch Role" menu, without having to type in the details every time. (**Roles do not persist across browsers, you have to set them up individually for every browser.**)

![gds-users-switch-role-list](images/gds-users-switch-role-list.png)

If you set the roles up with nicknames and different colours, it's easy to tell
which role you are in. Otherwise, click on your username in the top right corner
and it will tell you which role you have assumed on which account.

![gds-users-show-role](images/gds-users-show-role.png)
![gds-users-show-account](images/gds-users-show-account.png)

[access]: /manual/set-up-aws-account.html#4-get-the-appropriate-access
