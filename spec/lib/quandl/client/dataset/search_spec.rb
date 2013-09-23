# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  let(:source){ create(:source) }
  let(:dataset){ create(:dataset, source_code: source.code ) }
  
  it "should find the dataset by id" do
    Dataset.find(dataset.id).id.should eq dataset.id
  end
  
  it "should find the dataset by full code" do
    Dataset.find(dataset.full_code).id.should eq dataset.id
  end
  
  it "should exclude_data" do
    Dataset.exclude_data(true).find(dataset.id).data.should be_blank
  end
  
end