$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

# load quandl api client
require "quandl/client"

# tools for debugging
require "quandl/fabricate"
require 'securerandom'
require 'pry'

# Make Dataset available in global namespace
include Quandl::Client

# configure quandl client
Quandl::Client.use ENV['QUANDL_API_HOST']
Quandl::Client.token = ENV['QUANDL_USER_TOKEN']

binding.pry