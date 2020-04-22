---
owner_slack: "#govuk-developers"
title: GitHub Trello Poster
section: Team tools
layout: manual_layout
type: learn
parent: "/manual.html"
---

This app uses GitHub webhooks to be notified when a pull request is opened or changed on GitHub. When it finds a link to a Trello card in the pull request, it posts a link to that pull request to a checklist on the given card. When a pull request is merged or closed the app checks the pull request off the checklist.

## Background

This app was created by Emma Beynon as a [20% time project](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds-technology/junior-technologist/previous-20-projects/github-trello-poster).  It was built using Ruby and Sinatra and makes use of the Trello and GitHub APIs and GitHub webhooks.  It is hosted on Government PaaS.  You can find the GitHub repo [here](https://github.com/emmabeynon/github-trello-poster).

## Credentials

The credentials for the Trello account that posts to Trello cards and for PaaS can be found in [govuk-secrets](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/github-trello-poster).

The app uses the `govuk-ci` user's GitHub Personal Access Token.

## Using GitHub Trello Poster

It's a simple process:

1. Add user `@pullrequestposter` to your team's Trello board.  It will need **read and write** access.
2. Set up a webhook for your chosen repo, if it hasn't already been done.  For instructions, see the app's [GitHub repo](https://github.com/emmabeynon/github-trello-poster).  You can find the payload URL in [govuk-secrets](https://github.com/alphagov/govuk-secrets/tree/master/pass/2ndline/github-trello-poster).  Alternatively, copy how it's set up in a repo such as [Publishing API](https://github.com/alphagov/publishing-api/settings/hooks).
3. That's it!  You should start seeing GitHub Trello Poster posting to your Trello cards once you start opening, modifying and closing pull requests.
