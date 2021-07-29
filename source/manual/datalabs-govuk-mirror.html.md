---
owner_slack: "#govuk-data-labs"
title: Use GOV.UK Mirror
section: Data Labs Team Manual
layout: manual_layout
parent: "/manual.html"
---

The GOV.UK mirror is a static version of the entire GOV.UK website. A crawler generates the mirror every hour by navigating through most of the site and saving each HTML page it visits. See the [Developer docs on updating the GOV.UK mirror](https://docs.publishing.service.gov.uk/manual/fall-back-to-mirror.html#updates-to-the-mirror) for more information.

The GOV.UK mirror provides a static backup of GOV.UK as a fallback, and is not designed for analytics. As such, the GOV.UK mirror:

- only stores pages that can be accessed by the crawler
- skips search pages, and [pages that mandate a user input](https://www.gov.uk/child-benefit-tax-calculator/y?response=&next=1)
- stores [pages with default or blank answers if user input is optional](https://www.gov.uk/transition-check/questions?page=6)
- does not cache mirror versions, but instead replaces those versions once it completes each crawl

The following example pages show what page types are cached by the crawler.

Smart answer start pages and their first pages, such as the [Child Benefit Tax calculator]((https://www.gov.uk/child-benefit-tax-calculator/y)), are included in the mirror. However, all other pages are missing as they require user input.

Internal search result pages requiring user input and pre-populated internal search pages, such as the [“Services” internal search page](https://www.gov.uk/search/services), are not stored.

Local transaction result pages, such as the [“Request a repair to a council property” page](https://www.gov.uk/repair-council-property/tower-hamlets), are not cached as they require user input.

For special checkers like the [Brexit checker](https://www.gov.uk/brexit), only the start, first question and results pages are stored as the intermediate question pages are query strings. The results page has no useful content, as there is no user input.

## Get access to the GOV.UK mirror

Before you start, you must have:

- access to AWS
- installed the GDS command line tools

See the [Get started on GOV.UK developer documentation](https://docs.publishing.service.gov.uk/manual/get-started.html) for more information on how to do this.

### Copy GOV.UK mirror from AWS S3 bucket

The GOV.UK mirror is stored in the AWS `govuk-production-mirror-replica` S3 bucket.

To work with the GOV.UK mirror remotely, you should copy the GOV.UK mirror from the `govuk-production-mirror-replica` bucket to another bucket.

The following content assumes that you want to copy the GOV.UK mirror to the `govuk-data-infrastructure-integration` S3 bucket.

1. [Sign into AWS](https://s3.console.aws.amazon.com/).
1. Select your name in the top right of the screen and select __Switch roles__.
1. Under __Account__, you can select select __govuk-infrastructure-integration__ or __210287912431__.
1. Under __Role__, select __govuk-datascienceusers__.
1. You can enter any text into __Display name__ or leave this field empty.
1. You can select any colour in __Colour__. Best practice is to select green for integration, amber for staging and red for production.
1. Select __Switch Role__.
1. Run the following in your command line:

    ```
    gds aws govuk-integration-datascience --assume-role-ttl 480m aws s3 sync s3://govuk-production-mirror-replica/www.gov.uk s3://govuk-data-infrastructure-integration/{YYYYMMDD}-govuk-production-mirror-replica
    ```
    
    where `{YYYYMMDD}` is today’s date in year-month-day format.

    The `--assume-role-ttl 480m` allows 8 hours (480 minutes) to transfer the data between the two S3 buckets. Using `aws s3 sync` also allows you to restart the transfer from where you left off if there are any errors.

### Download the GOV.UK mirror to your local machine

You can download the GOV.UK mirror to your local machine.

You must first copy the GOV.UK mirror from the `govuk-production-mirror-replica` AWS S3 bucket to another bucket, and then download from that second bucket to your local machine.

The following content assumes that you want to download the GOV.UK mirror from the `govuk-data-infrastructure-integration` S3 bucket.

1. [Sign into AWS](https://s3.console.aws.amazon.com/).
1. Select the `govuk-datascienceusers` role.
1. Run the following code in your terminal to download the mirror locally:

    ```
    gds aws govuk-integration-datascience --assume-role-ttl 480m aws s3 sync s3://govuk-data-infrastructure-integration/{YYYYMMDD}-govuk-production-mirror-replica YOUR_LOCAL_FOLDER
    ```

    where `{YYYYMMDD}` is today’s date in year-month-day format, and `YOUR_LOCAL_FOLDER` is a folder on your machine.

Downloading the mirror locally is time and resource-intensive. To save time and resources, you can instead run your code on [AWS Sagemaker](/manual/datalabs-start-new-project.html#manage-your-machine39s-resources-with-aws-sagemaker) and stream the data from S3.
