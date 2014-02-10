# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  let(:dataset){ build(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE" ) }
  subject{ dataset }
  
  context "given ambiguous code" do
    before(:each){ 
      dataset.source_code = nil
      dataset.code = '12345'
      dataset.valid?
    }
    its(:valid?){ should be_false }
    its('errors.messages'){ should eq({ data: ["Pure numerical codes like \"12345\" are not allowed unless you prefix them with a source code. Do this:\ncode: <your-username>/12345"]}) }
  end
  
  context "mismatch row count" do
    before(:each){ dataset.data = [[2012, 1,2],[2011, 1,2,3]] }
    its(:valid?){ should be_false }
  end
  
  context "mismatch column_names count" do
    before(:each){
      dataset.column_names = ['Date','Value']
      dataset.data = [[2012, 1,2],[2011, 1,2]]
    }
    its(:valid?){ should be_false }
  end
  
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