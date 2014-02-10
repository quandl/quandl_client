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
Quandl::Client.use ENV['QUANDL_TEST_URL']
Quandl::Client.token = ENV['QUANDL_TEST_TOKEN']

# set some attributes
d = Dataset.new(
  code:           "MY_DATASET_#{Time.now.to_i.to_s(16)}", 
  name:           "My dataset has a name.",
  description:    "This is the description.",
  data:           [[ 2014, 1, 2 ]]
)
# POST to server
d.save

if d.saved?
  puts "View your new dataset at: #{d.full_url}"
else
  puts "Something went wrong:\n#{d.human_status}\n#{d.human_error_messages}"
end
