$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "rspec"
require 'factory_girl'
require 'pry'

factory_dir = File.join( File.dirname(__FILE__), 'factories/**/*.rb' )
Dir.glob( factory_dir ).each{|f| require(f); puts f }

require_relative 'config/quandl'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

def uuid
  SecureRandom.uuid.to_s
end