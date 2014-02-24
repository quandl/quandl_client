$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'pry'
require "quandl/client"

include Quandl::Client

Quandl::Client.use ENV['QUANDL_TEST_URL']
Quandl::Client.token = ENV['QUANDL_TEST_TOKEN']

u = User.login( login: 'blakehil', password: 'example' )

binding.pry