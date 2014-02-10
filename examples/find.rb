$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

# DEBUGGING
require 'pry'
require "quandl/fabricate"

# LOAD
require "quandl/client"
include Quandl::Client

# CONFIGURE
Quandl::Client.use ENV['QUANDL_URL']
Quandl::Client.token = ENV['QUANDL_TOKEN']

# FIND
d = Dataset.find('MCX.ALMG2014')

binding.pry