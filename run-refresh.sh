# Run the build
bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment
bundle exec middleman build
git add docs
git commit -m "Refresh data from GitHub"
git push origin master:master
