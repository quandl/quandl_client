$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'pry'
require "quandl/client"
require "quandl/fabricate"
require 'securerandom'

include Quandl::Client

Quandl::Client.use 'http://quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_USER_TOKEN']

# create dataset
d = Dataset.new
d.code = "TEST_#{SecureRandom.hex[0..10]}".upcase
d.name = 'Blake Test Dataset'
d.save

# update dataset's data
new_data = Quandl::Fabricate::Data.rand( rows: 10, columns: 2, nils: false ).to_date.to_csv
d.data = new_data
d.save

binding.pry