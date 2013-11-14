$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'pry'
require "quandl/client"
require "quandl/fabricate"

include Quandl::Client

Quandl::Client.use 'http://quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_AUTH_TOKEN']

binding.pry