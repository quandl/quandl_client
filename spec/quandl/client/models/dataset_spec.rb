# encoding: utf-8
require 'spec_helper'

describe Quandl::Client::Dataset do
  
  let(:data){ Quandl::Data::Random.table( rows: 100, columns: 4 ).to_csv }
  
  it "should create the dataset" do
    d = Dataset.new( data: data, source_code: 'GENERATED_SOURCE', code: "GEN" )
    d.save
    d.valid?.should_not be_true  
  end
end