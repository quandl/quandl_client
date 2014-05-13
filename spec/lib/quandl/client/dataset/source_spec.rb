# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  let(:dataset){ create(:dataset, source_code: nil ) }
  subject{ dataset }
  
  context "admin user" do
    
    its(:saved?){ should be_true }
    its(:source_code){ should be_present }
    
    describe "#source_code=" do
      before(:each){
        subject.source_code = 'WHO'
        subject.save
      }
      its(:status){ should be 200 }
      its(:source_code){ should eq 'WHO' }
    end
    
  end
  
  context "normal user" do
    # behave as a user
    before(:all){ Quandl::Client.token = Spec::Config::Quandl.user_token }
  
    its(:saved?){ should be_true }
    its(:source_code){ should be_present }
  
    it "should find the source" do
      Source.find(dataset.source_code).exists?.should be_true
    end
  
    describe "#source_code=" do
      before(:each){
        subject.source_code = 'WHO'
        subject.save
      }
      its(:status){ should be 422 }
    end
    
    after(:all){ Quandl::Client.token = Spec::Config::Quandl.token}
  end
  
end
