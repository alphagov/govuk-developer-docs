---
owner_slack: "#re-govuk"
title: Migrate Terraform resources between state files
section: Infrastructure 
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-08-01
review_in: 6 months
---
## Questions
 - How can you move existing AWS resources from one state file to another state file without destructive actions? 
 - How can you change a resource creation to use a module without destructive actions?

## Case study
The case that prompted this was a need to update code used for s3 bucket creation. The bucket was initially created from a deprecated terraform repository. In addition to this the terraform project creating the bucket could use a module instead of a resource block. Specifically this was moving an AWS resource created using code in `govuk-terraform-provisioning` to the active repo, `govuk-aws`.

### Moving the code:
1. Get the new terraform project setup - this includes creating the remote state file
2. Run a `terraform plan` - this should show no issues, if there are any correct them before proceeding.
3. Run a `terraform apply` - this should complain that some resources already exist
4. Taking the list of existing resources run some `terraform import` commands
5. e.g. if there’s an existing user named “existing-user” and your code creates this under the terraform reference “aws_iam_user.iami_user” then the following command will add that user into the state file under that reference, `terraform import aws_iam_user.iam_user existing-user`
6. Further instructions can be found in HashiCorp docs, https://www.terraform.io/docs/import/usage.html.
Another useful resource is the Import section at the bottom of the docs page for the resource you're importing, which tells you the syntax.
For example, if you want to import aws_iam_user_policy_attachment, see https://www.terraform.io/docs/providers/aws/r/iam_user_policy_attachment.html#import for the exact syntax.
7. Repeat previous two steps until the apply runs through cleanly - the goal is to avoid any destructive actions.
8. Once complete, the new state file will have the existing resources and can be managed by the new code.

### Updating the code:
1. Make changes to the code to replace resource blocks with modules.
2. Run a `terraform plan` to confirm the actions, there will be a destroy and create that we can avoid.
3. Run `terraform state mv` commands for each of the resources
1. e.g. if there’s an s3 bucket, `aws_s3_bucket.example`, that can now be created in a module, module.example then run `terraform state aws_s3_bucket.example module.example` and this will change the state file reference
2. Repeat for all the resources
4. Following the `terraform state mv` commands run a `terraform plan` again - this should no longer have any destructive actions.
5. Once happy with the `terraform plan` run a `terraform apply`
