---
owner_slack: "#govuk-corona-forms-tech"
title: COVID-19 Services
section: Services
layout: manual_layout
parent: "/manual.html"
---

Between March and October 2020 the GOV.UK operated three standalone
services for the COVID-19 pandemic response:

- [Business volunteer service](#business-volunteer-service)
- [Vulnerable people service](#vulnerable-people-service)
- [Find support service](#find-support-service)

These services are no longer deployed, live or in active development.

## Business volunteer service

This service allowed businesses to tell us how they might be able to
help with the response to coronavirus.  That included goods or
services such as medical equipment, hotel rooms or childcare.

**The service has been replaced with a guidance page.**

A backup of the production database was taken prior to the service
being removed. GDS has transferred this backup to Government
Commercial Function within the Cabinet Office and no longer retains
a copy.

- [Original GitHub Repository](https://github.com/alphagov/govuk-coronavirus-business-volunteer-form)
- [Information on how to bring this service back to life](https://github.com/alphagov/govuk-coronavirus-business-volunteer-form/blob/master/docs/how-to-bring-back-this-service.md)
- [PaaS deployment YAML file](https://github.com/alphagov/govuk-coronavirus-business-volunteer-form/blob/76ba8ce4e6b08bc2a7c3cc6acb9cdaea35530933/concourse/tasks/deploy-to-govuk-paas.yml) for [restoring the PaaS infrastructure](#restoring-the-paas-infrastructure)
- [Concourse pipeline YAML definition file](https://github.com/alphagov/govuk-coronavirus-business-volunteer-form/blob/master/concourse/pipeline.yml) for restoring the Concourse pipeline
- Here are screenshots of the [required settings](https://drive.google.com/file/d/1kNoWpiF494Yng6HNc_wz2R_WyRpFs6y8/view?usp=sharing) and [optional settings](https://drive.google.com/file/d/12gs79eNyy7CUb3fmOTcpaSNojdX0LME8/view?usp=sharing) to recreate the Pingdom check
- [Restoring the Sentry error monitor](https://drive.google.com/file/d/1olTHkQwwq0mlMWsg3BOyjwFy2xhuzcf9/view?usp=sharing)
- [Restoring the AWS infrastructure](https://github.com/alphagov/covid-engineering/pull/948)

## Vulnerable people service

This service allowed people identified as vulnerable by the NHS to
tell us if they need help accessing essential supplies and support.
Users will have received a link to the service in a letter or a text
message from the NHS, or been advised by their GP to fill in the form.

**The service has been rebuilt by the #vulnerable-people-services team.**

- [Original GitHub Repository](https://github.com/alphagov/govuk-coronavirus-vulnerable-people-form)
- [Rebuilt Service GitHub Repository](https://github.com/alphagov/govuk-shielded-vulnerable-people-service)

## Find support service

This service allowed the public - who may not have been eligible for
the extremely vulnerable service - to find information about what help
is available if they're struggling with unemployment, an inability to
get food, having somewhere to live, or their general wellbeing as a
result of coronavirus.

**The service has now been migrated and is now a smart answer.**

A backup of the production database was taken prior to the service
being removed. It is available at:

- AWS S3 bucket: `govuk-production-database-backups`
- Key: `coronavirus-find-support/production.sql.gzip`
- Retention period: 365 days (as per our privacy policy)
- Expiry date: Fri, 08 Oct 2021 00:00:00 GMT

The file information can be retrieved with the following command...

```shell
gds aws govuk-production-poweruser aws s3api head-object --bucket govuk-production-database-backups --key coronavirus-find-support/production.sql.gzip
```

- [Smart Answers GitHub Repository](https://github.com/alphagov/smart-answers/blob/main/lib/smart_answer_flows/find-coronavirus-support.rb)
- [Original GitHub Repository](https://github.com/alphagov/govuk-coronavirus-find-support)
- [Restoring the AWS infrastructure](https://github.com/alphagov/covid-engineering/pull/890)

## Restoring the PaaS infrastructure

Details on how to restore or recreate the PaaS infrastructure can be
found [here](https://docs.cloud.service.gov.uk/#gov-uk-platform-as-a-service).

Here are a series of screenshots that may assist with the recreation process:

- [Organisations](https://drive.google.com/file/d/1K_2GYVEMFkhSIbMeH1vnh2kooawih-RK/view?usp=sharing)
- [govuk-development-overview](https://drive.google.com/file/d/12HnBN-LYlXZXQS_voLkBfjUOXhMSy7fc/view?usp=sharing)
- [Applications](https://drive.google.com/file/d/1lapanTMiEpDtJcOtcQrSX0fTp6CsdbjA/view?usp=sharing)
- [Backing services](https://drive.google.com/file/d/1vd6JtUJxPqTz6kC4ShjkxL4SPa11Pqu4/view?usp=sharing)
- [Business volunteer service](https://drive.google.com/file/d/1chsWl-MyAZKH00mrxFhkMCC0W35i7EMW/view?usp=sharing)
- [Vulnerable people service](https://drive.google.com/file/d/17s-uCd1lvrzIkRqOebOgigM7jp0Vm07R/view?usp=sharing)

## Restoring the PagerDuty alert

Here are a series of screenshots that may assist with the recreation process:

- [Activity tab](https://drive.google.com/file/d/1ez9MzT3ODiG54m0nyutl2efbQgQH0Fuu/view?usp=sharing)
- [Integrations tab](https://drive.google.com/file/d/1Lm0-B4mEhpJjnrjHM4FNuthnoZF34J-0/view?usp=sharing)
- [Response tab](https://drive.google.com/file/d/1GdNqhXiQBjQAvq5oBBicUDnHsxAjj2vp/view?usp=sharing)
- [Incoming event source](https://drive.google.com/file/d/1n1Q4Jv51-gk3OAyjrzWWr4bJVlJxCyYA/view?usp=sharing)
- [Edit rule - when events match these conditions](https://drive.google.com/file/d/1_nRUkSZIIAD35o_Wb5Sp4b4kais0wU-M/view?usp=sharing)
- [Edit rule - do these things](https://drive.google.com/file/d/1vdeODTseE1CF-XSt_lYF6pIvwyPId_HX/view?usp=sharing)
- [Edit rule - at these times](https://drive.google.com/file/d/1OxTU3so5_aJWAKgDDvq0s_W8swAqm0mT/view?usp=sharing)

## Restoring the Prometheus AlertManager monitor

To restore or recreate the Prometheus monitor [revert this PR](https://github.com/alphagov/prometheus-aws-configuration-beta/pull/433)
