require 'active_support/all'
require 'tilt'
require 'middleman-core'

Dir[File.dirname(__FILE__) + '/**/*.rb'].each { |file| require file }
