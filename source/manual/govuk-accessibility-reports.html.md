---
owner_slack: "#govuk-data-labs"
title: GOV.UK Accessibility Reports
section: Data Community Documentation
layout: manual_layout
parent: "/manual.html"
---
The [GOV.UK Accessibility Reports project](https://github.com/alphagov/govuk-accessibility-reports) generates accessibility reports.

## How it works

This project generates these reports in the following way.

1. The `ReportRunner` takes all of the content items from the preprocessed content store and splits the items up into batches.
1. The `multiprocessing` package processes each batch in parallel, runs every report generator for a given content item and HTML content of that particular page, and writes the the result  to a multiprocessing `Queue`.
1. The `Queue` for each report generator is consumed by a separate process which writes to the output CSV file for that report.

## Before you start

1. Install the `gds-cli` and AWS CLI. ___LINK TO HOW TO GET THESE FROM GET STARTED CONTENT___

1. Download a copy of the preprocessed content store from the `govuk-data-infrastructure-integration` Amazon S3 bucket using the `gds-cli` and the AWS CLI.

    Run the following in the `gds-cli`:

    ```
    gds aws govuk-integration-poweruser aws s3 cp s3://govuk-data-infrastructure-integration/knowledge-graph/<DATE>/ preprocessed_content_store_140820.csv.gz /Users/<WHICH USERNAME?????>/Downloads/preprocessed_content_store_DATE.csv.gz
    ```
    where:
    - `<DATE>` is the date you want
    - `<WHICH USERNAME>` is your username WHICH ONE???

1. Download the GOV.UK mirror content from the `govuk-production-mirror-replica` Amazon S3 bucket using the `gds-cli` and the AWS CLI.

    Run the following in the `gds-cli`:

    ```
    gds aws govuk-production-poweruser --assume-role-ttl <TIME> aws s3 cp s3://govuk-production-mirror-replica/www.gov.uk/User/<WHICH USERNAME>/Downloads/govuk-production-mirror-replica --recursive
    ```

    where:
    - `<TIME>` is the number of minutes in the `--assume-role-ttl` flag
    - `<WHICH USERNAME>` is your username WHICH ONE???

    As the mirror is a large download, you should set `<TIME>` to `180m` (180 minutes).

1. Install and run Python 3.7. ___Navigate to the project root (where this README is located) and install required packages via pip install -r requirements.txt.___ Does this install python 3.7 or are the requirements something else?

## Generate an existing report

1. Go to your local `govuk-accessibility-reports/config` directory.

1. Set the `skip` property of the report(s) you want to generate to `false`.

1. Run the following to generate the reports:

    ```
    python -m src.scripts.run_accessibility_reports <REPORT CONFIG FILENAME>
    ```

    where `<REPORT CONFIG FILENAME>` is the report config you wish to use from the config directory. ___WHAT?___

The project saves completed reports in two different folders depending on whether the report needs post-processing or not.

If no post-processing is needed, the project saves the report in the `data` directory.

If post-processing is needed, the project saves the report in the `src/report_generators/<report_name>_postprocess/py` directory.

## Create a new report

1. Add a report generator into the `report_generators` directory and inherit from the `BaseReportGenerator`.

    ___Where is the `report_generators` directory? What do you add into the directory. What does "inherit" mean in this context? How do you do that? Is `BaseReportGenerator` a folder?___

1. Include 3 methods into the report generator:
    - `filename()` - the name of the file that you want the report to be saved out as, including the `.csv` extension
    - `headers()` - an array of the names of the headers that your report should contain
    - `preprocess_page(content_item, html)` - the main component of your report generator, which takes a content item from the preprocessed content store and the HTML content of that page, runs some computation and returns an array which corresponds to the output for that page to be included in the report CSV

    You can return an empty array ([]) if the page you're processing should not be recorded in the CSV or needs to be excluded from the final report.

1. Add a new entry to the reports property to the various configs that can be used to run the reports. ___WTF DOES THIS MEAN___ Esch entry ___should / must___ contain:
- `name` - the name of the report to be used in console output
- `filename` - the name of the Python module for your report generator, including the `.py` extension
- `class` - the name of the class for your report generator
- `skip`- whether to run or skip this report, set this to `true`

To test the report generator, you can set the `total_content_items` property in the config file to a low number, for example 1000. The report will complete much faster so you can test if it is working as intended.

## Configure your reports

https://github.com/alphagov/govuk-accessibility-reports#creating-a-new-report

___When do you do this???___


## Set up pre-commit hooks

https://github.com/alphagov/govuk-accessibility-reports#installing-pre-commit-hooks

___When do you do this?___

## Set environment variables

https://github.com/alphagov/govuk-accessibility-reports#setting-environment-variables

___When do you do this?___
