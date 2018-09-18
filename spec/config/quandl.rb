require "quandl/client"
require "quandl/fabricate"

include Quandl::Client

module Spec
  module Config
    class Quandl
      cattr_accessor :token, :remote_url
    end
  end
end

Quandl::Client.token = Spec::Config::Quandl.token = 'test1234'

Spec::Config::Quandl.remote_url = 'https://fake.quandl.com'
Quandl::Client.use('https://fake.quandl.com')
