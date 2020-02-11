---
owner_slack: "#govuk-dev-tools"
title: Fix bundler errors when running `bowl`
section: Development VM
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2019-11-01
review_in: 6 months
---

Sometimes the `bowl` command is not correctly installed on the VM.  If you
get an error like:

```shell
$ bowl frontend
bash: bowl: command not found
```

In other ruby applications this type of error can be solved by running the
command via `bundle exec` which load the application's `Gemfile` and makes
sure all the commands from the dependencies listed in there are available.
In this case however, `bowl` should be globally available, and running it via
`bundle exec` means we can't change the ruby version it will use to run each
different app.  Leading to errors like:

```
/usr/lib/rbenv/versions/2.4.0/bin/bundle:22:in `load': cannot load such file -- /usr/lib/rbenv/versions/1.9.3-p550/lib/ruby/gems/1.9.1/gems/bundler-1.7.4/lib/gems/bundler-1.7.4/bin/bundle (LoadError)
```

or

```
/usr/lib/rbenv/versions/1.9.3-p550/lib/ruby/gems/1.9.1/gems/bundler-1.7.4/lib/bundler/source/git.rb:188:in `rescue in load_spec_files': https://github.com/alphagov/mongoid_rails_migrations (at avoid-calling-bundler-require-in-library-code-v1.1.0-plus-mongoid-v5-fix) is not yet checked out. Run `bundle install` first. (Bundler::GitError)
```

To make `bowl` globally available reinstall it:

```shell
$ cd /var/govuk/govuk-puppet/development-vm
$ sudo gem install bowler
$ rbenv rehash
```

You should now be able to use `bowl` to run the apps correctly.

However, if you are seeing an error such as
`rbenv: cannot rehash: /usr/lib/rbenv/shims/.rbenv-shim exists` but the
`.rbenv-shim` file doesn't exist, try rebooting the VM. Use `vagrant halt`,
`vagrant up` and then `vagrant ssh` and hopefully `bowl` should be globally
available.
