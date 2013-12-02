# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  let(:source){
    s = Source.find("QUANDL_CLIENT_TEST_SOURCE")
    s = create(:source, code: "QUANDL_CLIENT_TEST_SOURCE") unless s.exists?
    s
  }
  subject{ create(:dataset, source_code: source.code, private: true ) }
  
  describe "#reference_url" do
    let(:url){ "http://website.com/path/to/reference" }
    let(:dataset){ Dataset.new( reference_url: url, code: "VALID" ) }
    subject{ dataset }
    
    its(:reference_url){ should eq url }
    its(:valid?){ should be_true }
    
    context "partial url" do
      let(:partial_url){ "website.com/path/to/reference" }
      let(:dataset){ Dataset.new( reference_url: partial_url, code: "VALID" ) }
      its(:reference_url){ should eq url }
      its(:valid?){ should be_true }
    end
    
    context "invalid url" do
      let(:partial_url){ "website" }
      let(:dataset){ Dataset.new( reference_url: partial_url, code: "VALID" ) }
      its(:valid?){ should be_false }
    end
    
  end
  
  describe "#private" do
    
    it "should update to false" do
      subject.private = false
      subject.save
      Dataset.find(subject.id).private.should be_false
    end
    
    it "should update to true" do
      subject.private = false
      subject.save
      subject.private = true
      subject.save
      Dataset.find(subject.id).private.should be_true
    end
    
  end
  
end