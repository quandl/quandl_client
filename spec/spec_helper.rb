$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "rspec"
require 'factory_girl'
require 'pry'

factory_dir = File.join( File.dirname(__FILE__), 'factories/**/*.rb' )
Dir.glob( factory_dir ).each{|f| require(f); puts f }

require "quandl/client"
require "quandl/fabricate"

include Quandl::Client
Quandl::Client.use ENV['QUANDL_API_HOST']
Quandl::Client.use 'http://staging.quandl.com/api/'

Quandl::Client.token = ENV['QUANDL_AUTH_TOKEN']

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

# binding.pry
