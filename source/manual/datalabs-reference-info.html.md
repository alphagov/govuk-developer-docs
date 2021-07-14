---
owner_slack: "#govuk-data-labs"
title: Reference information
section: Data Labs Team Manual
layout: manual_layout
parent: "/manual.html"
---

As a new starter in the GOV.UK Data Labs team, you should use the following reference information:

- the GDS wiki
- Cabinet Office Intranet (CabWeb)
- Single Operating Platform (SOP)
- the GDS Way
- GOV.UK Confluence
- the Aqua book for maintaining analytical quality assurance (AQA)
- the GOV.UK developer documentation
- pre-existing code to reuse
- learning and development resources
- example code

## GDS wiki

The [GDS Wiki](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds) contains GDS-specific information. Some useful pages include:

- specific [guidance for new starters](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/operations/people-team/people-line-manager-support-page/new-starters-leavers-internal-moves-and-recruitment/new-starters)
- guidance on [performance management](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/operations/people-team/people-line-manager-support-page/performance-management)
- [learning and development](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/operations/people-team/training-and-development-available-at-gds), including mandatory training, and [using the learning and development budget](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/operations/people-team/learning-and-development)

The GDS Wiki is being phased out in Summer 2021, and will be replaced with an updated version.

## Cabinet Office Intranet (CabWeb)

You must sign into the GDS Virtual Private Network (VPN) before you can access CabWeb. See the [guidance on signing into the GDS VPN using your Google credentials](https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To) for more information.

Once you’re signed into the VPN, you can access [CabWeb](http://intranet.cabinetoffice.gov.uk). Some useful pages include:

- the [Cabinet Office Analysis hub](https://intranet.cabinetoffice.gov.uk/analysis-hub/)
- [human resources (HR) guidance](https://intranet.cabinetoffice.gov.uk/how-do-i/hr-policy-hub/) on the HR hub
- [SOP guidance](https://co.myhub.sscl.com/) on MyHub

## Single Operating Platform (SOP)

SOP is a Cabinet Office-wide platform for most human resource functions, including editing your personal information, accessing your payslip, logging expenses, and requesting special leave. For more information on how to use SOP, see the [SOP guidance on CabWeb](https://docs.google.com/document/d/1MPFvIkAc_0HhujOl-hXSfUimP2EWBWNq1IddWFhKN9k/edit?pli=1#heading=h.cfm3uejborh5).

To access SOP:

- sign into the [GDS Virtual Private Network (VPN) using your Google account](https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To)
- [sign into SOP](https://sop.govsharedservices.gov.uk:4450/OA_HTML/AppsLogin)

## The GDS Way

[The GDS Way](https://gds-way.cloudapps.digital/) is a public-facing website that documents the specific technology, tools, and processes used at GDS and CDDO.

Although software developer-focused, some useful pages include:

- [style guides for different programming languages](https://gds-way.cloudapps.digital/manuals/programming-languages.html), including the [GDS Python style guide](https://gds-way.cloudapps.digital/manuals/programming-languages/python/python.html)
- tracking, and [managing third-party software dependencies](https://gds-way.cloudapps.digital/standards/tracking-dependencies.html)
- [building accessible services, and understanding WCAG 2.1](https://gds-way.cloudapps.digital/manuals/accessibility.html), which is a legal responsibility of public sector websites
- best practice on using [version control](https://gds-way.cloudapps.digital/#version-control-and-deployments)

## GOV.UK Confluence

[Contact the GOV.UK Data Labs delivery manager](https://gds.slack.com/archives/CHR4UQKU4) and ask for access to the [GOV.UK Confluence workspace](https://gov-uk.atlassian.net/wiki/spaces/GOVUK/).

Once you have access to GOV.UK Confluence, go to the [Analytics on GOV.UK Confluence page](https://gov-uk.atlassian.net/wiki/spaces/GOVUK/pages/23855552/Analytics+on+GOV.UK). This page has [definitions on the custom dimensions](https://gov-uk.atlassian.net/wiki/spaces/GOVUK/pages/23855552/Analytics+on+GOV.UK#AnalyticsonGOV.UK-customDimensionsCustomdimensions) used in [Google BigQuery analytics tables](https://docs.google.com/document/d/1MPFvIkAc_0HhujOl-hXSfUimP2EWBWNq1IddWFhKN9k/edit?pli=1#heading=h.xxvwzmxv8f62).

## The Aqua book for maintaining analytical quality assurance (AQA)

Our analytical work can have far-reaching implications, including impacting individuals and their livelihoods. [The Aqua book provides high-level guidance on producing quality analysis for government](https://www.gov.uk/government/publications/the-aqua-book-guidance-on-producing-quality-analysis-for-government). This is termed analytical quality assurance (AQA). This book sets out how departments should ensure their work is fit-for-purpose through verification and validation.

These checks apply to anything that can be loosely defined as a “model”. If your work takes an input, processes it, and produces an output, this comes under the scope of AQA. This includes but is not limited to visualisations, spreadsheets, machine learning models, and even back-of-napkin-type calculations.

The Aqua book establishes four principles:

### Proportionality of response

The extent of the analytical quality assurance effort should be proportionate in response to the risks associated with the intended use of the analysis. These risks include financial, legal, operational and reputational impacts. In addition, analysis that is frequently used to support a decision-making process may require a more comprehensive analytical quality assurance response.

### Assurance throughout development

Quality assurance considerations should be taken into account throughout the life cycle of the analysis and not just at the end. Effective communication is crucial when understanding the problem, designing the analytical approach, conducting the analysis and relaying the outputs.

### Verification and validation

Analytical quality assurance is more than checking that the analysis is error-free and satisfies its specification (verification). It must also include checks that the analysis is appropriate, i.e. fit for the purpose for which it is being used (validation).

### Analysis with RIGOUR

Quality analysis needs to be the following:

- repeatable (R)
- independent (I)
- grounded in reality (G)
- objective (O)
- have understood and managed uncertainty (U)
- the results should address the initial question robustly (R)

In particular, it is important to accept that uncertainty is inherent within the inputs and outputs of any piece of analysis. It is important to establish how much we can rely upon the analysis for a given problem.

These principles must be considered when undertaking any work involving data/models. When setting up a project, use `govcookiecutter` to help concurrently set up all AQA documentation. Note this only sets up the documentation. You still need to perform the AQA itself.

Note that AQA is not just about software quality assurance. It can also include dealing with ethical considerations, reasons for choosing the method/technique, and validating analytical assumptions and caveats.

### Further information

[Additional Aqua book resources are available](https://www.gov.uk/government/collections/aqua-book-resources), and the Government Analytical Function, Government Data Quality Hub, and other departments have also produced:

- guides to ensure your [work is fit for purpose when working to very tight deadlines](https://www.gov.uk/government/publications/urgent-data-quality-assurance-guidance)
- guides to ensure your [data is fit for purpose](https://www.gov.uk/government/publications/the-government-data-quality-framework)
- a [curriculum around quality assurance, validation, and data linkage](https://www.gov.uk/guidance/af-learning-curriculum-technical#QualityAssuranceAF)

## GOV.UK developer documentation

See the [documentation on document types on GOV.UK](https://docs.publishing.service.gov.uk/document-types.html) for information on the various document types present on GOV.UK. This list may be incomplete.

See the [documentation on content schemas](https://docs.publishing.service.gov.uk/content-schemas.html) for more information on schema used for different content items on the Content Store.

This page is useful if you are working with the Content Store as it tells you what fields are available for different content document types again. This list may be incomplete.

## Pre-existing code to reuse

GOV.UK Data Labs has worked on many projects, and has developed code and features you can reuse.

The following table has links to code that you can reuse.

| Location | Notes |
| :--- | :--- |
| [2020-01-08 Possible Data Engineering problems to solve](https://docs.google.com/document/d/1fVdq3bfXZRAyL4f_6AiUyQ9gC0yO8mhsKOvy9TRewiY/) | Google Doc listing useful features, and data engineering-related thoughts. Mostly for Google BigQuery. |
| [alphagov/modular_sql/src/tools](https://github.com/alphagov/modular_sql/tree/master/src/tools) <br> [alphagov/modular_sql/tests](https://github.com/alphagov/modular_sql/tree/master/tests)| Scripts and associated tests for logging, setting up Google BigQuery clients, parsing SQL scripts into Python, and loading YAML configuration files |

## Code examples

The following content has code examples for different data sources.

### Google BigQuery code examples

Google BigQuery code examples are available in the [`govuk-data-labs-onboarding` GitHub repo](https://github.com/alphagov/govuk-data-labs-onboarding/tree/main/src).

### Content Store code examples

Downloading the Content Store may take some time.

If you need to use the Content Store in a project, you can instead use the:

- [JavaScript files in the `govuk-intent-detector` GitHub repo](https://github.com/alphagov/govuk-intent-detector/tree/main/src/make_data)
- [PyMongo Jupyter notebook in the define-content-schemas branch](https://github.com/alphagov/govuk-intent-detector/blob/define-content-schemas/notebooks/writing_aggregation_queries_for_content_store_with_pymongo.ipynb) of the `govuk-intent-detector` GitHub repo

### GOV.UK mirror code examples

Downloading the GOV.UK mirror may take some time.

If you need to use the GOV.UK mirror in a project, you can instead use the [page term TF-IDF matrix notebooks in the `govuk-intent-detector` GitHub repo](https://github.com/alphagov/govuk-intent-detector/tree/main/notebooks/page_term_tfidf_matrix).

## Learning and development resources

<table>
<tbody>
<tr>
<td><strong>Free?</strong></td>
<td><strong>Materials</strong></td>
<td><strong>Notes</strong></td>
</tr>
<tr>
<td>No</td>
<td><a href="https://www.acm.org/membership/membership-benefits" target="_blank" rel="noopener">O&rsquo;Reilly ebooks through ACM membership</a></td>
<td>O&rsquo;Reilly Media publishes technology-oriented books with an associated app for reading their books on the go. Useful books and videos include:
<ul>
<li><a href="https://learning.oreilly.com/library/view/statistics-in-a/9781449361129/" target="_blank" rel="noopener">Statistics in a Nutshell</a></li>
<li><a href="https://learning.oreilly.com/library/view/data-science-from/9781492041122/" target="_blank" rel="noopener">Data Science from Scratch</a></li>
<li><a href="https://learning.oreilly.com/library/view/hands-on-machine-learning/9781492032632/" target="_blank" rel="noopener">Hands-On Machine Learning with Scikit-Learn, Keras, and Tensorflow</a></li>
<li><a href="https://learning.oreilly.com/library/view/agile-data-science/9781491960103/" target="_blank" rel="noopener">Agile Data Science 2.0</a></li>
<li><a href="https://learning.oreilly.com/library/view/deep-learning-for/9781492045519/" target="_blank" rel="noopener">Deep Learning for Coders with fastai and PyTorch</a></li>
<li><a href="https://learning.oreilly.com/library/view/bayesian-statistics-the/9781098122492/" target="_blank" rel="noopener">Bayesian Statistics the Fun Way</a></li>
<li><a href="https://learning.oreilly.com/videos/ab-testing-a/9781491934777/" target="_blank" rel="noopener">A/B Testing, A Data Science Perspective</a></li>
</ul>
</td>
</tr>
<tr>
<td>No</td>
<td><a href="https://www.pluralsight.com/" target="_blank" rel="noopener">Standard individual licence for Pluralsight</a></td>
<td>Pluralsight provides online courses that lean towards software development and engineering. Some useful courses include:
<ul>
<li><a href="https://app.pluralsight.com/library/courses/using-unit-testing-python/table-of-contents" target="_blank" rel="noopener">Unit Testing with Python</a></li>
<li><a href="https://app.pluralsight.com/paths/skills/data-analytics-on-google-cloud-platform" target="_blank" rel="noopener">From Data to Insights with Google Cloud</a></li>
</ul>
</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://course.spacy.io/en/" target="_blank" rel="noopener">Advanced NLP with spaCy</a></td>
<td>Free online course by the creators of spaCy on natural language processing, including exercises, slides, videos, multiple choice questions, and interactive, browser-based coding practice.</td>
</tr>
<tr>
<td>Depends</td>
<td><a href="https://www.coursera.org/" target="_blank" rel="noopener">Coursera</a></td>
<td>Coursera hosts a number of courses on data science.&nbsp;<a href="https://learner.coursera.help/hc/en-us/articles/209818613-Enrollment-options#heading-4" target="_blank" rel="noopener">You can &ldquo;audit&rdquo; courses for free</a>; but you cannot complete certain assignments or obtain a completion certificate. It&rsquo;s generally not worth paying for the courses. Good courses include:
<ul>
<li><a href="https://www.coursera.org/learn/machine-learning" target="_blank" rel="noopener">Stanford - Machine Learning</a>&nbsp;(Andrew Ng)</li>
<li><a href="https://www.coursera.org/specializations/jhu-data-science" target="_blank" rel="noopener">John Hopkins University - Data Science Specialization</a></li>
</ul>
</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://www.fast.ai/" target="_blank" rel="noopener">fast.ai</a></td>
<td>Online courses on deep learning using fast.ai, practical data ethics, computational linear algebra, and natural language processing</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://christophm.github.io/interpretable-ml-book/" target="_blank" rel="noopener">Interpretable Machine Learning</a></td>
<td>Accessible book on interpretable machine learning, including interpretable machine learning models, as well as model-agnostic methods for interpretability.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="http://jalammar.github.io/illustrated-word2vec/" target="_blank" rel="noopener">The Illustrated Word2vec</a><a href="http://jalammar.github.io/" target="_blank" rel="noopener">Jay Alammar's GitHub Pages</a></td>
<td>An illustrated guide to word2vec. The author, Jay Alammar, also has a whole host of other illustrated guides.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://matheusfacure.github.io/python-causality-handbook/landing-page.html" target="_blank" rel="noopener">Causal Inference for The Brave and True</a></td>
<td>A light-hearted yet rigorous approach to learning impact estimation and sensitivity analysis.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://arxiv.org/abs/1803.09010" target="_blank" rel="noopener">Datasheets for Datasets</a></td>
<td>A paper proposing how to document datasets.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://www.pluralsight.com/tech-blog/managing-python-environments/" target="_blank" rel="noopener">Managing Python Environments</a></td>
<td>Short blog post by Pluralsight summarising Python.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://cjolowicz.github.io/posts/hypermodern-python-01-setup/" target="_blank" rel="noopener">Hypermodern Python</a></td>
<td>A recent review on Python best practice for projects.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://mml-book.github.io/" target="_blank" rel="noopener">Mathematics for Machine Learning</a></td>
<td>Mathematical skills book to be able to interpret other advanced machine learning books.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/huggingface/datasets" target="_blank" rel="noopener">huggingface/datasets</a></td>
<td>The largest hub of ready-to-use natural language processing datasets for machine learning models with fast, easy-to-use and efficient data manipulation tools.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://best-practice-and-impact.github.io/qa-of-code-guidance/intro.html" target="_blank" rel="noopener">ONS Best Practice and Impact - Quality Assurance of Code for Analysis and Research</a></td>
<td>Cross Governmental guidance on best practice for analysis and research.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/ethen8181/machine-learning" target="_blank" rel="noopener">ethen8181/machine-learning</a></td>
<td>Machine learning tutorials</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/ageron/handson-ml2" target="_blank" rel="noopener">ageron/handson-ml2</a></td>
<td>Complementary code for the Hands-On Machine Learning with Scikit-Learn, Keras, and Tensorflow O&rsquo;Reilly book.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/awesomedata/awesome-public-datasets" target="_blank" rel="noopener">awesomedata/awesome-public-datasets</a></td>
<td>A topic-centric list of high quality open datasets.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://madewithml.com/" target="_blank" rel="noopener">Made with ML</a></td>
<td>Machine learning operations and engineering courses.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/ikatsov/tensor-house" target="_blank" rel="noopener">ikatsov/tensor-house</a></td>
<td>A collection of reference machine learning and optimization models for enterprise operations, including marketing, pricing, and supply chain.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/jghoman/awesome-apache-airflow" target="_blank" rel="noopener">jghoman/awesome-apache-airflow</a></td>
<td>Resources for Apache Airflow.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/aws/amazon-sagemaker-examples" target="_blank" rel="noopener">aws/amazon-sagemaker-examples</a></td>
<td>AWS Sagemaker examples - these are automatically loaded into Sagemaker instances.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/Chris-Engelhardt/data_sci_guide" target="_blank" rel="noopener">Chris-Engelhardt/data_sci_guide</a></td>
<td>A community-curated list of data science courses, including direct, free replacement courses for paid options.</td>
</tr>
<tr>
<td>No</td>
<td><a href="https://www.statlearning.com/" target="_blank" rel="noopener">Introduction to Statistical Learning: With Applications in R</a></td>
<td>An accessible primer into machine learning - recommended read for newcomers to data science, and as a refresher.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/datastacktv/data-engineer-roadmap" target="_blank" rel="noopener">datastacktv/data-engineer-roadmap</a></td>
<td>Roadmap for those wishing to study data engineering.</td>
</tr>
<tr>
<td>Yes</td>
<td><a href="https://github.com/alastairrushworth/free-data-science" target="_blank" rel="noopener">alastairrushworth/free-data-science</a></td>
<td>Resources and learning materials across a broad range of popular data science topics and arranged thematically.</td>
</tr>
</tbody>
</table>
