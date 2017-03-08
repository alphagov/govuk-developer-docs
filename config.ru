# For hosting on Heroku
require 'rack'
require 'rack/contrib/try_static'

# "restrict" access for now
use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == [ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD']]
end

# Serve files from the build directory
use Rack::TryStatic,
  root: 'build',
  urls: %w[/],
  try: ['.html', 'index.html', '/index.html']

run lambda { |_env|
  [404, { 'Content-Type' => 'text/html' }, ["404 Not Found"]]
}
