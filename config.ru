# For hosting on Heroku
require 'rack'
require 'rack/contrib/try_static'

# Serve files from the build directory
use Rack::TryStatic,
  root: 'build',
  urls: %w[/],
  try: ['.html', 'index.html', '/index.html']

run lambda { |env|
  [ 404, { 'Content-Type'  => 'text/html'}, [ "404 Not Found" ]]
}
