---
owner_slack: "#govuk-2ndline-tech"
title: How to check and commit code to AWS CodeCommit
section: AWS
layout: manual_layout
parent: "/manual.html"
---

CodeCommit is used as a backup/mirror for our repositories in GitHub. It is regularly populated by a [GitHub Action in govuk-infrastructure](https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/mirror-repos.yml).

Should we need to commit code manually to CodeCommit (if GitHub is down, for example), we can leverage the access granted to us via [gds-cli](https://github.com/alphagov/gds-cli) in order to authenticate our local user and commit code.

## Quick reference guide

The following example shows how to clone the whitehall-prototype-2023 repository, create a local branch, make a local change then push the change to a remote branch in aws codecommit. *You must* first [install dependencies and set up your local environment](#install-dependencies-and-set-up-local-environment).

```
gds aws govuk-tools-poweruser git clone codecommit::eu-west-2://whitehall-prototype-2023
cd whitehall-prototype-2023
git checkout -b mybranch
touch mychange
git add mychange
git commit -m "my change"
gds aws govuk-tools-poweruser git push origin mychange
```

## Install dependencies and set up local environment

- For this to work you need to have [set up the GDS command line tools](https://docs.publishing.service.gov.uk/manual/get-started.html#3-install-gds-command-line-tools)

- You will also need to install git-remote-codecommit

```
brew install git-remote-codecommit
```

- You will also need to add the below lines to your git config as per [AWS documentation](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-https-unixes.html#setting-up-https-unixes-credential-helper)

```
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
```

- You should see the following entry in the gitconfig file (`cat ~/.gitconfig`)

```
[credential]
    helper = !aws codecommit credential-helper $@
    UseHttpPath = true
```

## Cloning repositories

- login to the AWS console to see the available repositories using [the GDS command line tool](https://docs.publishing.service.gov.uk/manual/get-started.html#3-install-gds-command-line-tools)

```
gds aws govuk-tools-poweruser --login
```

- search "codecommit" in the aws search bar and ensure that "London" is selected as the region

- find the repository you are wanting to clone using the repository search bar then select the "HTTPS (GRC)" __repository url__

- open a terminal and navigate to the directory you want to clone the repository to then clone the repository using

```
gds aws govuk-tools-poweruser git clone <repository url>
```

- an example of cloning the whitehall prototype 2023 repository looks like this

```
gds aws govuk-tools-poweruser git clone codecommit::eu-west-2://whitehall-prototype-2023
```

## Pushing to a branch

- After cloning the repository you can create local branches and make local changes as you would with a normal git repository

- When it comes to pushing to a remote branch prefix the git command with the GDS command line tool so the correct credentials are used to authenticate with AWS

```
gds aws govuk-tools-poweruser git push origin mybranch
```
