$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'pry'
require "quandl/client"

include Quandl::Client

Quandl::Client.use 'http://quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_USER_TOKEN']

# create dataset
d = Dataset.find('NSE/OIL')

data = d.data.trim_start( 3.weeks.ago ).limit(10)

binding.pry