---
owner_slack: "#govuk-2ndline-tech"
title: How to check and commit code to AWS CodeCommit
section: AWS
layout: manual_layout
parent: "/manual.html"
---

We use [AWS CodeCommit](https://docs.aws.amazon.com/codecommit/latest/userguide/) as a backup for our GitHub repositories.

The [`mirror-repos.yml` GitHub Actions workflow](https://github.com/alphagov/govuk-infrastructure/blob/main/.github/workflows/mirror-repos.yml) copies GitHub repositories tagged with `govuk` to CodeCommit 4 times daily Mon-Fri.

Accessing CodeCommit requires AWS credentials, which you can obtain in the usual ways via [gds-cli](https://github.com/alphagov/gds-cli).

## Quick reference guide

This example demonstrates a simple workflow using the `whitehall` repository in CodeCommit.

> Follow [the installation steps](#install-dependencies-and-set-up-local-environment) first.

```
# Clone the repo.
gds aws govuk-tools-poweruser git clone codecommit::eu-west-2://whitehall

# Create a local branch.
cd whitehall
git checkout -b mybranch

# Commit a change locally.
touch mychange
git commit -m "DO NOT MERGE: testing push to CodeCommit" -- mychange

# Push the branch to CodeCommit.
gds aws govuk-tools-poweruser git push origin mybranch

# Clean up by deleting the example branch we just created.
gds aws govuk-tools-poweruser git push -d origin mybranch
```

## Install dependencies and set up local environment

You need to have first [set up the GDS command line tools](/manual/get-started.html#3-install-gds-command-line-tools).

1. Install `git-remote-codecommit`:

    ```
    brew install git-remote-codecommit
    ```

    On a Linux machine, you may find it easier to install `git-remote-codecommit` via `pip`:

    ```
    pip3 install git-remote-codecommit
    ```

1. Configure your git client to use `git-remote-codecommit` to authenticate to AWS. (See [AWS CodeCommit docs](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-https-unixes.html#setting-up-https-unixes-credential-helper) for further info.)

    ```
    git config --global credential.helper '!aws codecommit credential-helper $@'
    git config --global credential.UseHttpPath true
    ```

    This should automatically add the following entry to your `~/.gitconfig` file.

    ```
    [credential]
        helper = !aws codecommit credential-helper $@
        UseHttpPath = true
    ```

## Clone a repository from CodeCommit

1. In your shell, obtain AWS credentials and run `git clone` to clone the repository.

    ```
    gds aws govuk-tools-poweruser git clone <repository url>
    ```

    For example:

    ```
    gds aws govuk-tools-poweruser git clone codecommit::eu-west-2://whitehall
    ```

> `git clone` on CodeCommit can sometimes be very slow initially. If `git
> clone` appears to hang at `remote:` or `remote: Enumerating objects`, it's
> worth waiting several minutes as it may start working.

## Find a repository in CodeCommit

Repository names should exactly match those in GitHub. If you are unsure whether a given repository exists in CodeCommit, you can browse the available repositories.

1. Log into the AWS console to see the available repositories using [the GDS command line tool](/manual/get-started.html#3-install-gds-command-line-tools)

    ```
    gds aws govuk-tools-poweruser --login
    ```

1. Select the London (`eu-west-2`) region.

1. Go to the CodeCommit page. You can find it via the search bar or the navigation menu.

1. Find the repository you want to clone using the repository search bar.

1. Select the "HTTPS (GRC)" repository URL.

## Pushing to a branch

Once you have cloned a repository from CodeCommit, you can create local branches and push changes as normal, provided you have valid AWS credentials in your shell.

For example:

```
gds aws govuk-tools-poweruser git push origin mybranch
```
