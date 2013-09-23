# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  describe "#code" do

    before(:all){ Quandl::Client.token = ENV['QUANDL_AUTH_TOKEN'] }
    
    let(:dataset){ create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE" ) }
    let(:invalid_dataset){ create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", code: dataset.code ) }
    subject{ invalid_dataset }
    
    it "should create the dataset" do
      dataset.status.should eq 201
    end
    
    its(:saved?){ should be_false }
    its(:status){ should eq 422 }
    
  end
  

end