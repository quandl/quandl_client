$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "rspec"
require 'factory_girl'

factory_dir = File.join( File.dirname(__FILE__), 'factories/**/*.rb' )
Dir.glob( factory_dir ).each{|f| require(f); puts f }

require "quandl/client"

include Quandl::Client
Quandl::Client.use 'http://staging.quandl.com/api/'
AUTH_TOKEN = '93yzptKyhdkrqLhmezdi'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end