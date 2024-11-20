---
owner_slack: '#govuk-developers'
title: Find usage of Govspeak in content
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

[Govspeak](https://govspeak-preview.publishing.service.gov.uk) is an extension for Markdown used in GOV.UK's publishing applications.

After making a change to the Govspeak gem, you may need to republish content that uses that markdown.

In nearly all cases, Govspeak is converted to HTML within the publishing application before being sent to Publishing API. This means there are two options for finding affected content: searching for raw Govspeak within the publishing application or converted HTML in Publishing API.

## Searching for raw Govspeak in Whitehall

There is a Rake task to find published content that matches a regular expression:

```sh
rake 'reporting:matching_docs[regex]'
```

Replace `regex` with an escaped version of the regular expression. Ruby's `Regexp.escape` method might escape too much; in general you'll need to escape things like backslashes and square brackets. For example, to find all uses of inline attachments contained within steps, you would use the following regex:

```regexp
^s[0-9]+\..*?\[AttachmentLink:.*?\].*$
```

This would be escaped and used in the rake task as follows:

```sh
rake 'reporting:matching_docs[s\[0-9\]+\\..*?\\\[AttachmentLink:.*?\\\].*$]'
```

You could try running the Rake task on a `whitehall-admin` pod using the instructions in [Run a rake task on EKS](https://docs.publishing.service.gov.uk/manual/running-rake-tasks.html#run-a-rake-task-on-eks). However, you might find that the task quickly times out with errors like those below.

```text
ActiveRecord::StatementInvalid: Mysql2::Error: Timeout exceeded in regular expression match. (ActiveRecord::StatementInvalid)

Mysql2::Error: Timeout exceeded in regular expression match. (Mysql2::Error)
```

In this case, you can:

1. [Replicate the data locally](https://github.com/alphagov/govuk-docker/blob/main/docs/how-tos.md#how-to-replicate-data-locally).
1. Adjust your MySQL regex timeout by running the following in your `govuk-docker` directory:
    1. `docker exec -it govuk-docker-mysql-8-1 mysql --user=root --password=root`. If you get a `No such container` error, try starting up Whitehall in GOV.UK Docker and then stopping it.
    1. `SET GLOBAL regexp_time_limit=20000;`. You could try a shorter limit to start. [This variable is explained in the MySQL docs](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_regexp_time_limit).
1. Run the Rake task locally with GOV.UK Docker.

## Searching for converted HTML in Publishing API

Follow the instructions to [open a Rails console](https://docs.publishing.service.gov.uk/kubernetes/cheatsheet.html#common-tasks) for Publishing API.

### Example commands

Here's some example commands you can run, feel free to modify the regex for your specific usecase (and add more here if you fancy :))

This will take a few minutes to execute since it's iterating over a lot of editions!

#### Find 'call to action'

```ruby
Edition.where.not(content_store: nil).find_each { |e| puts "https://gov.uk#{e.base_path}" if e.details.to_s =~ /class=\\"call-to-action/ }
```

#### Find YouTube links

```ruby
Edition.where.not(content_store: nil).find_each { |e| puts "https://gov.uk#{e.base_path}" if e.details.to_s =~ /href=\\"https:\/\/www.youtube.com\/watch?v=/ }
```

#### Find hardcoded buttons

```ruby
Edition.where.not(content_store: nil).find_each { |e| puts "https://gov.uk#{e.base_path}" if e.details.to_s =~ /class=\\"button/ }
```
