---
owner_slack: '#2ndline'
last_reviewed_on: 2017-09-27
review_in: 6 months
title: Upgrade Rails to a new version
section: Packaging
layout: manual_layout
parent: "/manual.html"
---

When upgrading our apps between Rails major and minor versions, follow the [official Rails guides][guide]

## Gotchas for upgrading to Rails 5.0

### Eager loading

By default Rails 5 disables autoloading in production and uses eager load, this
[blog post][rails-5-autoloading] explains further.

The effect this can have is that classes that need the `autoload_paths` altered -
for instance at the root of `lib` - will no longer work in production, but will
still load in development (this has already caused a production issue).

The solution is append to `eager_load_paths` rather than `autoload_paths` which
will ensure the classes are loaded in both production and development. See
[Publishing API Example][publishing-api-autoload-change].

### Don't include ActionCable or Puma configs

We don't use these in production and are likely to cause conflicts.

[guide]: http://guides.rubyonrails.org/upgrading_ruby_on_rails.html
[rails-5-autoloading]: http://blog.bigbinary.com/2016/08/29/rails-5-disables-autoloading-after-booting-the-app-in-production.html
[publishing-api-autoload-change]: https://github.com/alphagov/publishing-api/pull/553/files

## Gotchas for upgrading to Rails 5.1

### Schema dumper changes

The schema dumper has been refactored in Rails 5.1 so the first migration after upgrading
will generate a lot of differences in `db/schema.rb`.
Notably whitespace and `using :btree` index modifiers.
See [this commit](https://github.com/rails/rails/commit/df84e9867219e9311aef6f4efd5dd9ec675bee5c?short_path=1ed2907#diff-e0d63791fb8e00fc467e7c47b74fb6d6)
and also [this commit](https://github.com/rails/rails/commit/6d37cd918dba5b492194afbc1094a6503c88f379) for details of the changes.

As part of the upgrade, regenerating the schema with `rake db:migrate` and including the updated `db/schema.rb` file will mean
the next migration doesn't generate this noise.
