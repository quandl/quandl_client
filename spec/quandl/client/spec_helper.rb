$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "rspec"
require 'factory_girl'
require 'pry'

factory_dir = File.join( File.dirname(__FILE__), 'factories/**/*.rb' )
Dir.glob( factory_dir ).each{|f| require(f); puts f }

require "quandl/client"

include Quandl::Client
Quandl::Client.use 'http://localhost:3000/api/'
# Quandl::Client.use 'http://staging.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_AUTH_TOKEN']

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end