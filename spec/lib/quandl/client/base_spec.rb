# encoding: utf-8
require 'spec_helper'

describe Base do
  it "should have https in base url by default" do
    Quandl::Client::Base.url.should include 'https://www.'
  end
end
