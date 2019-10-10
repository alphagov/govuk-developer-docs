---
owner_slack: "#re-govuk"
title: Access to staging is limited to GDS office IPs 
section: Security 
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-10-10
review_in: 6 months
---
During a recent security incident responders would have liked to be able to test 
access limitations to certain paths on GOV.UK in the staging environment without 
running the risk to re-expose sensitive data.  
In order to ensure this, the decision to limit access to our staging environment 
to GDS office IPs was made in the incident review.  
We have documented the changes made to the firewall rules in the 6DG/Carrenza 
vDirector environment in the (private) [govuk-provisioning repository](https://github.com/alphagov/govuk-provisioning/pull/96).  
Access to the staging frontends hosted in AWS is protected by the [security group (SG) 
associated with the external cache load balancer](https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1#SecurityGroups:search=cache;sort=groupId)
(Link requires AWS Console access).
