---
owner_slack: "#govuk-developers"
title: Set up your GitHub account
layout: manual_layout
section: Learning GOV.UK
last_reviewed_on: 2019-10-21
review_in: 6 months
---

1. Set up a [GitHub][] account. Existing personal accounts are fine to use.
1. Ask your tech lead to add you to the [alphagov organisation][alphagov]. You will have to be added to the [GOV.UK team][govuk-team] to get access to repos & CI. Remember to click accept in the GitHub email invitation.
1. Ask somebody with access to add your GitHub username to the [user monitoring system][user-reviewer].
1. [Generate and register an SSH key pair][register-ssh-key] for your laptop for your GitHub account. You should use a `4096` bit key.
1. Import the SSH key into your keychain. Once you’ve done this, you'll be able to clone repos over SSH.

    ```
    $ /usr/bin/ssh-add -K your-private-key
    ```

1. Add the above line into your `~/.bash_profile` or equivalent so that it is persistent between restarts.
    
1. Test that it all works by running `ssh -T git@github.com`.

1. While you're here, associate your name and email to your git commits:

    ```
    $ git config --global user.email "friendly.giraffe@digital.cabinet-office.gov.uk"
    $ git config --global user.name "Friendly Giraffe"
    ```

[GitHub]: https://www.github.com/
[user-reviewer]: https://github.com/alphagov/govuk-user-reviewer
[alphagov]: https://github.com/alphagov
[govuk-team]: https://github.com/orgs/alphagov/teams/gov-uk/members
[register-ssh-key]: https://help.github.com/articles/connecting-to-github-with-ssh/
