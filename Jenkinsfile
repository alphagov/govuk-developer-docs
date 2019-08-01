#!/usr/bin/env groovy

library("govuk")

REPOSITORY = 'govuk-developer-docs'

node {

  properties([
    buildDiscarder(
      logRotator(
        numToKeepStr: '50')
      ),
    [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
  ])

  try {
    stage("Checkout") {
      govuk.checkoutFromGitHubWithSSH(REPOSITORY)
    }

    stage("Clean up workspace") {
      govuk.cleanupGit()
    }

    stage("Merge master") {
      govuk.mergeMasterBranch()
    }

    stage("Set up content schema dependency") {
      govuk.contentSchemaDependency()
    }

    stage("bundle install") {
      govuk.bundleApp()
    }

    stage("Lint Ruby") {
      govuk.rubyLinter("app lib helpers spec bin")
    }

    stage("Lint documentation") {
      sh '''
        curl https://pre-commit.com/install-local.py | python -
        git diff-tree --no-commit-id --name-only -r $(git rev-parse HEAD) | xargs pre-commit run --files
      '''
    }

    stage("Tests") {
      govuk.runTests()
    }
  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    throw e
  }
}
