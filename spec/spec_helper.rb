$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "rspec"
require 'factory_girl'
require 'pry'

factory_dir = File.join( File.dirname(__FILE__), 'factories/**/*.rb' )
Dir.glob( factory_dir ).each{|f| require(f); puts f }

require "quandl/client"
require "quandl/fabricate"

include Quandl::Client
Quandl::Client.token = ENV['QUANDL_AUTH_TOKEN']
Quandl::Client.use ENV['QUANDL_API_HOST']
# Quandl::Client.use 'http://staging.quandl.com/api/'
# Quandl::Client.use 'http://67.202.27.116:8080/api/'
# Quandl::Client.use 'http://quandl.com/api/'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end