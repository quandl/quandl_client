$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'pry'
require "quandl/client"
require "quandl/fabricate"
require 'securerandom'

include Quandl::Client

Quandl::Client.use ENV['QUANDL_API_HOST']
Quandl::Client.token = ENV['QUANDL_USER_TOKEN']
# Quandl::Client.use 'http://quandl.com/api/'

binding.pry