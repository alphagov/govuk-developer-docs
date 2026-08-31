---
owner_slack: "#govuk-developers"
title: Create an prototype in Alphagov and set up Heroku review apps
section: Deployment
layout: manual_layout
parent: "/manual.html"
---

This guide explains how to create a new repository in Alphagov for a [GOV.UK Prototype Kit](https://prototype-kit.service.gov.uk/docs/) prototype and configure Heroku review apps for deployments.

**Note**: Other hosting options are available and some are covered in the [GOV.UK Prototype Kit publishing documentation](https://prototype-kit.service.gov.uk/docs/publishing). This guide focuses specifically on creating a repository in Alphagov and using Heroku review apps to deploy your prototype.

## Create a new repository

The following steps assume you are creating a prototype using the GOV.UK Prototype Kit.

### 1. Create and configure the repository

Follow the general steps for creating a new GOV.UK repository in the [Creating and configuring a new repository](https://docs.publishing.service.gov.uk/manual/github-new-repo.html#create-a-new-repository) guide.

See the [example pull request](https://github.com/alphagov/govuk-infrastructure/pull/4489).

### 2. Request a review

Ask for a review in [#govuk-ask-platform-engineering](https://gds.slack.com/archives/C013F737737).

Once your pull request has been approved, merge it.

### 3. Request Terraform to be run

After your pull request has been merged, post again in [#govuk-ask-platform-engineering](https://gds.slack.com/archives/C013F737737) to ask that Terraform is run to create the repository.

### 4. Complete the repository setup

Once the repository has been created:

- Create a well-written README, following the GOV.UK guidance: https://docs.publishing.service.gov.uk/manual/github-new-repo.html#create-a-new-repository
- Add a licence following the [Licensing Guidelines](https://gds-way.digital.cabinet-office.gov.uk/manuals/licensing.html#specifying-the-licence).
- Add a CI workflow.

The process for adding security scans to the CI pipeline is documented here: [Add security scans to the CI pipeline](https://docs.publishing.service.gov.uk/manual/github-new-repo.html#add-security-scans-to-the-ci-pipeline)

See the [example workflow](https://github.com/alphagov/govuk-multiple-h1-headings-on-page-prototype/blob/main/.github/workflows/ci.yml).

### 5. Branch protection rules

You may need to configure branch protection rules to allow non-developer roles, such as interaction designers or content designers, to merge approved pull requests into main.

To add someone:

- Go to **Settings → Branches**.
- Under Restrict who can push to matching branches, search for the person you want to add and select them.
- Click **Save**.

### 6. Manage access

You may need to configure repository access for non-developer roles, such as interaction designers or content designers.

To add someone:

- Go to **Settings → Collaborators and teams**.
- Click **Add people**.
- Search for the person you want to add and select them.
- On the next page, choose the appropriate access level for the person. Write access is recommended for anyone who needs to push changes to the repository.
- Click **Add selection**.

## Set up the Heroku pipeline

- Log in to Heroku: https://docs.publishing.service.gov.uk/manual/heroku.html.
- Select **New → Create new pipeline**.
- Enter:
  - **Pipeline name** (required)
  - **Pipeline owner**: (leave unchanged – Alphagov – heroku@digital.cabinet-office.gov.uk)
- Under **Connect to GitHub**:
  - Change the dropdown to Alphagov.
  - Search for your repository.
- Click **Search**.
- When the correct repository is found, click **Connect**.
- Click **Create pipeline**.

## Enable review apps

After the pipeline has been created:

- Open the **Settings** tab.
- Under **Review Apps**, click **Enable review apps**.

Additional options will appear.

Configure the following settings:

- Enable **Create new review apps for new pull requests automatically**.
- Enable **Wait for GitHub checks to pass**.
- Enable **Destroy stale review apps automaticall** and set the expiry to **5 days**.
- Change the region to **Europe**.

Click **Enable Review Apps** to save the configuration.

## Create a permanent review app (in staging or production)

For pipelines that are used exclusively for review apps, it is recommended to keep a placeholder app in the staging or production environment. This helps prevent the pipeline from being accidentally deleted.

See the Heroku documentation for more details: [Why did my pipeline disappear?](https://help.heroku.com/R8AE3YBV/why-did-my-pipeline-disappear).

To add a placeholder production app:

- Under **Production**, click **Add app**.
- Click **Create new app**.
- Enter an **App name**.
- Set the **Location** to **Europe**.
- Ensure **Add this app to a pipeline** is selected.
- Select the pipeline you created above.
- Set **Choose a stage to add this app to** to **Production**.
- Click **Create app**.

On the next page, configure automatic deploys:

- Click the GitHub icon to connect the app to GitHub.
- Search for the repository you want to connect and click **Connect**.
- Under Automatic deploys, select the branch to deploy (this should usually be main).
- Click **Enable Automatic Deploys**.

**Note**: You may need to manually deploy the main branch the first time you complete this setup.

## Configure review app environment variables

To password-protect your prototype, add the required environment variables to the review app config.

Add the following variables:

- **NODE_ENV**, and the value is **production**
- **PASSWORD**, and the value is whatever password you want to use

For more information, see: [Setting a password](https://prototype-kit.service.gov.uk/docs/publishing#setting-a-password).
