require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, "fake.quandl.com")
  end
end
