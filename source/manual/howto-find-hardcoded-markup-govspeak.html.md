---
owner_slack: '#govuk-2ndline'
title: Find hardcoded markup in GovSpeak
section: Publishing
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2018-05-30
review_in: 6 months
---

Usually to find usage of markup we can look in our source code.

For example if we wanted to see which templates use a class called 'button' you could search in Github.

However [GovSpeak (our variant of Markdown)](https://govuk-static.herokuapp.com/component-guide/govspeak) includes markup such as buttons that will be in published content.

So, with this in mind you'll need to search all published content.

## Searching the Publishing API

First make sure you can SSH into our integration environment, you can [follow the Getting Started guide](/manual/get-started.html#6-access-remote-environments)

Now if everything is setup you can ssh onto the machine with the publishing api using:

```shell
$ ssh publishing-api-1.staging
```

Then to get access to the console for the [publishing-api](https://github.com/alphagov/publishing-api) so you can execute commands do the following:

```shell
$ govuk_app_console publishing-api
```

## Example commands

Here's some example commands you can run, feel free to modify the regex for your specific usecase (and add more here if you fancy :))

This will take a few minutes to execute since it's iterating over a lot of editions!

### Find 'call to action'

```ruby
Edition.where.not(content_store: nil).find_each { |e| puts "https://gov.uk#{e.base_path}" if e.details.to_s =~ /class=\\"call-to-action/ }
```

### Find YouTube links

```ruby
Edition.where.not(content_store: nil).find_each { |e| puts "https://gov.uk#{e.base_path}" if e.details.to_s =~ /href=\\"https:\/\/www.youtube.com\/watch?v=/ }
```

### Find hardcoded buttons

```ruby
Edition.where.not(content_store: nil).find_each { |e| puts "https://gov.uk#{e.base_path}" if e.details.to_s =~ /class=\\"button/ }
```
