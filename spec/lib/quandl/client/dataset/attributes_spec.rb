# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  let(:source){
    s = Source.find("QUANDL_CLIENT_TEST_SOURCE")
    s = create(:source, code: "QUANDL_CLIENT_TEST_SOURCE") unless s.exists?
    s
  }
  subject{ create(:dataset, source_code: source.code, private: true ) }
  
  describe "#code" do
    subject{ build(:dataset, source_code: source.code.downcase ) }
    before(:each){ 
      subject.code = subject.code.downcase 
      subject.save
    }
    its('errors.messages'){ should eq({}) }
    its(:saved?){ should be_true }
    
  end
  
  describe "#name" do
    subject{ create(:dataset, source_code: source.code, private: true, name: '' ) }
    
    its(:name){ should match /Untitled Dataset #{Date.today}/ }
  end
  
  describe "#reference_url" do
    let(:url){ "http://website.com/path/to/reference" }
    let(:dataset){ Dataset.new( reference_url: url, code: "VALID" ) }
    subject{ dataset }
    
    its(:reference_url){ should eq url }
    its(:valid?){ should be_true }
    
    context "partial url" do
      let(:url){ "website.com/path/to/reference" }
      its(:reference_url){ should eq "http://website.com/path/to/reference" }
      its(:valid?){ should be_true }
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