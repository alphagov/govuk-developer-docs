---
owner_slack: "#re-govuk"
title: "Upgrade Terraform"
section: Infrastructure
type: learn
layout: manual_layout
parent: "/manual.html"
---

Terraform should be regularly upgraded. New releases happen very often, with bug fixes and improvements.
Also, being too far behind the latest versions can make future upgrades and support for new provider services much harder to perform.

In our platform we need to update the version of Terraform and AWS provider enforced in the [govuk-aws](https://github.com/alphagov/govuk-aws) code repo,
and update the Terraform package that runs the [Deploy_Terraform_GOVUK_AWS](https://deploy.integration.publishing.service.gov.uk/job/Deploy_Terraform_GOVUK_AWS)
Jenkins job in the CI machines.

The Terraform version of a client that updated a state file is represented in the state. Once a client with a new
version of Terraform updates a remote state file, the rest of clients will be forced to use that same version of Terraform. It is
important to update both the package in CI and the version required in the code more or less at the same time to avoid errors in the clients/jobs.

Currently we are also enforcing the version of the [Terraform AWS provider](https://github.com/terraform-providers/terraform-provider-aws) in our code.
We should also keep an eye on new versions and update regularly in a similar way.

Before/during the upgrade:

- Read the Terraform [CHANGELOG](https://github.com/terraform-providers/terraform-provider-aws/blob/master/CHANGELOG.md) carefully, make sure there aren't backwards incompatible changes, or the code is updated if required.
- If you are planning a Terraform AWS provider upgrade, also read the CHANGELOG carefully. This provider is updated very often.
- Test the new versions in a local branch first. Probably a `terraform plan` of the `infra-*` and a few `app-*` projects can provide enough test coverage.
- Check for DEPRECATION messages and try to fix them.
- Inform people of the upgrade so they can install the new binary in their laptops for code development.

### Build a new Terraform package

The Terraform package is built with a recipe in the [packager](https://github.com/alphagov/packager) repository.
Follow the general instructions in [Debian packaging](https://docs.publishing.service.gov.uk/manual/debian-packaging.html)
to create a new package and upload it to our Apt repository.

For instance, this pull request creates a recipe for [Terraform 0.11.14](https://github.com/alphagov/packager/pull/172)
After merging to master, execute the [build_fpm_package](https://ci.integration.publishing.service.gov.uk/job/build_fpm_package/)
job to build a new Terraform package. The new package will appear in the job artefacts section. Download it to your machine
and upload it to `apt-1.management` in Production.

Run the following commands to add it to the Terraform repo:

```
sudo -i aptly repo add terraform /home/your_user_name/terraform_0.11.14_amd64.deb
sudo aptly snapshot create terraform-$(date +%Y%m%d) from repo terraform
sudo -i aptly publish switch trusty terraform terraform-$(date +%Y%m%d)
```

The `aptly publish` command requires the apt passphrase that can be found in the [password store](https://github.com/alphagov/govuk-secrets/tree/master/pass)

### Update the Terraform package in the CI machines

The version of the Terraform package that is installed in CI is managed in Puppet. Update the [govuk_jenkins::packages::terraform::version](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk_jenkins/manifests/packages/terraform.pp) parameter with the new version, after the package is available in Aptly.

### Update the Terraform version in govuk-aws

In [govuk-aws](https://github.com/alphagov/govuk-aws):

- Replace the version requirement in the `.tf` files to match the new version:

```
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}
```

For instance, to upgrade from 0.11.7 to 0.11.14 you can run:

```
find . -name *.tf | xargs sed -i '' -e "s/0.11.7/0.11.14/g"
```

- Update the version managed by tfenv in the `.terraform-version` file
- Update any other reference in the docs

### Upgrade the Terraform AWS provider

Currently we set the version of the [Terraform AWS provider](https://github.com/terraform-providers/terraform-provider-aws) in our code, for instance:

```
provider "aws" {
  region  = "${var.aws_region}"
  version = "1.60.0"
}

```

Upgrading the provider only requires a change of this version parameter in the `.tf` files. This version is downloaded to the client
when the `terraform init` command runs, which happens automatically when we deploy Terraform with the Jenkins job or the `tools/build-terraform-project.sh` script.
