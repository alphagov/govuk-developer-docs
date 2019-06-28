---
owner_slack: "#govuk-2ndline"
title: AWS LB Healthy Hosts
parent: "/manual.html"
layout: manual_layout
section: Icinga alerts
last_reviewed_on: 2019-06-17
review_in: 6 months
---

This alert relates to the number of healthy hosts behind AWS LoadBalancing services. 

Load Balancer Type|Check Status OK|Check Status Warning|Check Status Critical|Check Status Unknown
------------------|---------------|--------------------|---------------------|--------------------
Classic (ELB-Classic)|The number of instances with status "InService" attached to the ELB is greater than the "warning" threshold|The number of instances with status "InService" attached to the ELB is less than or equal to the "warning" threshold, but greater than the "critical" threshold|The number of instances with status "InService" attached to the ELB is less than or equal to the "critical" threshold|The loadbalancer can't be found; the `lb_name` and/or `region` arguments haven't been provided; the warning or critical arguments are not integers; the value of the warning threshold provided in the arguments is less than the critical one; other AWS client exceptions
Application (ELBv2-ALB)|All the Target Groups attached to the ALB are considered "healthy", i.e. the number of targets on each Target Group with status "Healthy" is greater than the "warning" threshold|One or more Target Groups attached to the ALB are "warning", i.e. the number of targets on the affected Target Group(s) with status "Healthy" is less than or equal to the "warning" threshold, but greater than the "critical" threshold|One or more Target Groups attached to the ALB are "critical", i.e. the number of targets on the affected Target Group(s) with status "Healthy" is less than or equal to the "critical" threshold|The loadbalancer can't be found; the `lb_name` and/or `region` arguments haven't been provided; the warning or critical arguments are not integers; the value of the warning threshold provided in the arguments is less than the critical one; other AWS client exceptions


We use AWS ELB (Classic) and ALB services to route traffic from internet facing or internal clients to the application instances:

- A classic load balancer (ELB) periodically sends health checks to test the EC2 instances attached to the Load balancer. The load balancer routes requests only to the healthy instances.

- An Application load balancer (ELBv2/ALB) routes requests to registered target groups based on specific rules. When we configure a load balancer, we create target groups, then register targets with the target groups, and finally define the rules to route traffic for a listener to each target group. Each listener has at least a default action to route traffic to a default target group. The target groups are configured with health checks to monitor the status of the targets, and only send traffic to healthy ones.

The Healthy Hosts alert monitors both types of load balancers. The type is discovered automatically in the check. If the script can't find the load balancer, the check status will be UNKNOWN.

If the load balancer is a classic LB, the script checks the status of the instances attached. If the status in not "InService", then that instance is counted as unhealthy. This is similar to what we see from the AWS web console: EC2 -> Load Balancers -> Select the load balancer in your region: Instances, Status. The icon next to the status can provide more information, if the status is unhealthy.

Alternatively, if the instances are part of an Autoscaling Group, the Autoscaling Group "Activity History" section can also provide information when instances are registered or deregistered from load balancers: EC2 -> Auto Scaling Groups -> Select the ASG in your region: Activity History

If the load balancer is an application LB, the script discovers all the target groups attached to the load balancer. For each target group, it checks the status of the instances registered with the target group. If the status is not "Healthy", then that instance is counted as unhealthy. In the AWS web console: EC2 -> Load Balancers -> Select the load balancer in your region: Listeners -> View/Edit Rules (the Listeners section only shows the default action, condition based rules don't appear here): under the Rules view, you can see all the route conditions and target groups linked to each rule. From this view you can click on the Target group and check the Targets section, or you can also go directly to the EC2 -> Target Groups service and search all the target groups registered with the load balancer, and check the targets from there.

Sometimes we decommission applications but the configuration hasn't been updated in the Terraform/AWS side. If this is the case, some target groups will appear as unhealthy because the app is no longer active. If this happens, it's preferable to update the Terraform configuration to remove DNS entries and rules/target groups linked to the service, but we can also ignore that target group from the checks with the `healthyhosts_ignore` option.


