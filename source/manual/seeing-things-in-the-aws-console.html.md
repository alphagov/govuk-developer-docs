---
owner_slack: "#govuk-2ndline"
title: Seeing things in the AWS Console
section: AWS
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-06-01
review_in: 3 months
---

To follow this guide, you'll need a `gds-users` AWS account. Follow
[the User Management in AWS guide](source/manual/user-management-in-aws.html.md)
to get one and set it up.

## Seeing things in the AWS Console

The AWS Console can seem impenetrable, with lots of options, some of
them restricted by your role access level.

### Logging in to the central `gds-users` account

To log into the central `gds-users` account, [go to the AWS Console](https://gds-users.signin.aws.amazon.com/console).

Enter your email address and password. After clicking "Sign in",
you'll be prompted for your MFA token.

Once you're logged in, you'll see a page that looks like a normal AWS
console.

![gds-users-aws-console](images/gds-users-aws-console.png)

If you try to click on anything here, for example EC2, you'll get "You
are not authorized". This is because you're still in the `gds-users`
account which is locked down. To get to the GOV.UK accounts, where you
have permissions, you'll need to "Switch Role".

### Switching role to one of the GOV.UK accounts

1. Click "Switch Role" in the top right corner.

  ![gds-users-switch-role](images/gds-users-switch-role.png)

2. Fill in the account alias (this can be found
  [in the govuk-aws-data repo](https://github.com/alphagov/govuk-aws-data/blob/master/docs/govuk-aws-accounts.md) – it's the "account"),
  the role you're assuming (`govuk-users`, `govuk-powerusers`, or
  `govuk-administrators`), and a name for that role
  (`govuk-<environment>`).

  ![gds-users-switch-role-form](images/gds-users-switch-role-form.png)

3. Submit the form, and you'll now be in one of the GOV.UK accounts
   and able to see running instances. If you can't, make sure you're
   in the right region. GOV.UK's infrastructure is in the "EU
   (Ireland)" region (eu-west-1).

  ![govuk-role-select-region](images/govuk-role-select-region.png)
  
4. If you've set all of the roles up, they are then easily accessible
   from the "Switch Role" menu, without having to type in the details
   every time. (**Roles do not persist across browsers, you have to
   set them up individually for every browser.**)

   ![gds-users-switch-role-list](images/gds-users-switch-role-list.png)

5. If you set the roles up with nicknames and different colours, it's
   easy to tell which role you are in. Otherwise, click on your
   username in the top right corner and it will tell you which role
   you have assumed on which account.

   ![gds-users-show-role](images/gds-users-show-role.png)
   ![gds-users-show-account](images/gds-users-show-account.png)
