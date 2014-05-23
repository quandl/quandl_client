# encoding: utf-8
require 'spec_helper'

describe Source do
  
  let(:source){ build(:source) }
  
  context "without token" do
        
    before(:all){ Quandl::Client.token = '' }
    
    subject{ source }

    its(:valid?){ should be_true }
    
    describe "#save" do
      
      it "should not be authorized to create a source" do
        source.save
        source.status.should eq 401
      end
      
    end
    
  end
  
  context "with token" do

    before(:all){ Quandl::Client.token = Spec::Config::Quandl.token }
    
    describe "#save" do
      
      it "should save the source" do
        source.save
        source.status.should eq 201
      end
      
      it "should update the source" do
        source.save
        retrieved_source = Source.find(source.id)
        retrieved_source.description = "something new #{Time.now}"
        retrieved_source.save
        Source.find(source.id).description.should eq retrieved_source.description
      end
      
    end
    
  end
  
  
end
