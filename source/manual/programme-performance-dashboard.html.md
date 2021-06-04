---
owner_slack: "#govuk-data-labs"
title: Programme Performance Dashboard
section: Data Community Documentation
layout: manual_layout
parent: "/manual.html"
---

The [Programme Performance Dashboard](https://datastudio.google.com/u/0/reporting/b0c83735-3d53-4392-88b0-f86f56afc313/page/qhQYB) is a snapshot of different key performance indicators for the GOV.UK Senior Management Team (SMT). The SMT looks at the dashboard every week on Wednesday morning.

The following content is for a GOV.UK performance or data analyst who needs to make the dashboard ready for the SMT.

## Dashboard structure and data sources

The dashboard has the following sections:

- Site performance and health
- Operational performance
- Roadmap confidence (high level)
- Roadmap confidence (detail)
- Glossary of metrics
- Useful dashboards and reports

Multiple users and data sources feed into each section. The main data source is the [OFFICIAL-SENSITIVE Data for GOV.UK SMT programme performance dashboard spreadsheet](https://docs.google.com/spreadsheets/d/1VJG5lF4zXm4Ygbz8roA0QNv6_Awsx_MeVW8psnQzWZE/edit#gid=973550233).

## Prepare the Site performance and health section

The Site performance and health section has 2 data sources:

- Google Analytics
- the dashboard spreadsheet

Google Analytics data automatically populates all the following fields in the first 2 rows of the Site performance and health section:

- users
- visits
- page views
- returning users
- mobile device use

The data source for the following fields in the bottom 2 rows is the __Performance metrics__ tab in the dashboard spreadsheet.

- availability
- incidents
- email incidents
- email subscriptions - this is currently on pause until it is more automated
- emails sent
- clickthrough rate from emails

Multiple GOV.UK teams enter data into the metrics tab on Monday or Tuesday of each week.

If data is missing on Tuesday afternoon, contact the appropriate team:

- the [GOV.UK Platform Health team](mailto:govuk-platform-health@digital.cabinet-office.gov.uk) for __Site health__ data, including email incidents
- the [GOV.UK Insights team](mailto:govuk-insights@digital.cabinet-office.gov.uk) for __Notifications__ data

## Prepare the Operational performance section

The __Performance metrics__ tab in the dashboard spreadsheet is the Operational performance section’s data source.

The GOV.UK Operations team enters the data on Monday or Tuesday of each week.

If data is missing on Tuesday afternoon, [contact the Operations team](mailto:gov.uk-ops@digital.cabinet-office.gov.uk).

## Prepare the Roadmap confidence (detail) section

The __Confidence by work stream__ tab in the dashboard spreadsheet is this section’s data source.

Every GOV.UK team except the SMT and the Operations team completes the objective red / amber / green (RAG) statuses on Monday or Tuesday of each week.

If data is missing on Tuesday afternoon, the Head of Product, Head of Delivery or Head of Data and User Insights will contact the appropriate team’s product manager (PM) or delivery manager (DM). Each team’s PM or DM should have a nominated deputy in case they are not available (for example, because of annual leave). See the [GOV.UK people plan spreadsheet](https://docs.google.com/spreadsheets/d/1OQ53e1BryIZPQSOJPh0_6w_owerd8YjWrRua-F5czcg/edit#gid=463955321) for information on the current teams.

On Thursday or Friday of each week, the Insights team [adds new RAG columns](https://www.google.com/url?q=https://trello.com/c/zPjMJWYC/445-add-weekly-rag-columns-to-spreadsheet-for-programme-performance-dashboard-thu-fri&sa=D&source=editors&ust=1621866923746000&usg=AOvVaw0hK2ugNNWQQbhfBagFZ_yi) dated for the week ending on Sunday, and hides the older columns from the previous week. This means that the latest 2 weeks are visible at any time.

## Prepare the Roadmap confidence (high level) section

This section aggregates the same data as the Roadmap confidence (detail) section.

No action needed on this section.

## Prepare the Glossary of metrics section

The __Glossary__ tab in the dashboard spreadsheet is this section’s data source.

No action is needed on this section for routine weekly updates. If we add or change any metrics in other sections, we update the glossary.

## Prepare the Useful dashboards and reports section

The __Other dashboards or reports__ tab in the dashboard spreadsheet is this section’s data source.

No action needed on this section.
