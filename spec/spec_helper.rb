$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "rspec"
require 'factory_girl'
require 'pry'

factory_dir = File.join( File.dirname(__FILE__), 'factories/**/*.rb' )
Dir.glob( factory_dir ).each{|f| require(f); puts f }

require "quandl/client"
require "quandl/fabricate"

# Expects two env variables:

# administrator:
# ENV['QUANDL_AUTH_TOKEN'] 

# user:
# ENV['QUANDL_TEST_TOKEN']

include Quandl::Client
Quandl::Client.token = ENV['QUANDL_AUTH_TOKEN']
Quandl::Client.use ENV['QUANDL_TEST_URL']

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

def uuid
  SecureRandom.uuid.to_s
end