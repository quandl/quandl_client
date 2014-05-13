# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  let(:dataset){ build(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE" ) }
  subject{ dataset }
  
  context "data='1980,10,20\nASDF,10,30'" do
    before(:each){ 
      dataset.data = '1980,10,20\nASDF,10,30'
      dataset.valid?
    }
    its(:valid?){ should be_false }
    its('errors.messages'){ should eq({ data: ["Invalid date 'ASDF'"] }) }
  end
  
  context "given ambiguous code" do
    before(:each){ 
      dataset.source_code = nil
      dataset.code = '12345'
      dataset.valid?
    }
    its(:valid?){ should be_false }
    its('errors.messages'){ should eq({ data: ["Pure numerical codes like \"12345\" are not allowed unless you include a source code. Do this:\nsource_code: <USERNAME>\ncode: 12345"]}) }
  end
  
  context "mismatch row count" do
    before(:each){
      dataset.data = [[2012, 1,2],[2011, 1,2,3]]
      dataset.valid?
    }
    its(:valid?){ should be_false }
    its('errors.messages'){ should eq({ data: 
      ["Unexpected number of points in this row:\n2011-12-31,1.0,2.0,3.0\nFound 3 but expected 2 based on precedent from the first row (2012-12-31,1.0,2.0)"]
    })}
  end
  
  context "mismatch column_names count" do
    before(:each){
      dataset.column_names = ['Date','Value']
      dataset.data = [[2012, 18,21],[2011, 1,2]]
      dataset.valid?
    }
    its(:valid?){ should be_false }
    its('errors.messages'){ should eq({ data: 
      ["Unexpected number of points in this row:\n2012-12-31,18.0,21.0\nFound 2 but expected 1 based on precedent from the header row (Date,Value)"]
    })}
  end
  
  describe "#code" do

    before(:all){ Quandl::Client.token = Spec::Config::Quandl.token}
    
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