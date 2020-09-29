---
owner_slack: '#govuk-developers'
title: Find hardcoded markup in GovSpeak
section: Publishing
layout: manual_layout
parent: "/manual.html"
---

Usually to find usage of markup we can look in our source code.

For example if we wanted to see which templates use a class called 'button' you could search in GitHub.

However [GovSpeak] (our variant of Markdown) includes markup such as buttons that will be in published content.

So, with this in mind you'll need to search all published content.

## Searching the Content Store via Jenkins

See the Content Team's instruction on the wiki: [Find instances of a keyword on GOV.UK]

## Searching the Publishing API

First make sure you can SSH into our integration environment, you can follow the [Getting Started] guide.

Now if everything is setup you can ssh onto the machine with the publishing api using:

```shell
$ ssh publishing-api-1.staging
```

Then to get access to the console for the [publishing-api] so you can execute commands do the following:

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

[Govspeak]: http://govspeak-preview.herokuapp.com/
[Getting Started]: /manual/get-started.html
[publishing-api]: https://github.com/alphagov/publishing-api
[Find instances of a keyword on GOV.UK]: https://gov-uk.atlassian.net/wiki/spaces/CC/pages/1314488405/Find+instances+of+a+keyword+on+GOV.UK
