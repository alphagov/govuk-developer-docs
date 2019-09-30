require "active_support/all"
require "tilt"
require "middleman-core"
require "yaml"
require "json"

CACHE = ActiveSupport::Cache::FileStore.new(".cache")

Dir[File.dirname(__FILE__) + "/../lib/*.rb"].each { |file| require file }
Dir[File.dirname(__FILE__) + "/**/*.rb"].each { |file| require file }
