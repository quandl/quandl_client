# encoding: utf-8
require 'spec_helper'

describe Dataset do
  context "when built" do
    subject{ build(:dataset) }
    its(:saved?){ should be_false }
    its(:valid?){ should be_true }
  end

  its(:request_started_at){ should be_nil }
  its(:request_finished_at){ should be_nil }
  its(:elapsed_request_time){ should be_nil }
  
  context "when created" do
    context "without token" do
      before(:all){ Quandl::Client.token = '' }
      
      let(:dataset){ create(:dataset) }
      subject{ dataset }
  
      its(:saved?){ should be_false }
      its(:status){ should eq 401 }
  
      its(:request_started_at){ should be_a Time }
      
      after(:all){ Quandl::Client.token = Spec::Config::Quandl.token}
    end
    context "with token" do
      
      let(:dataset){ create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE" ) }
      subject{ dataset }
  
      its(:saved?){ should be_true }
      its(:status){ should eq 201 }
  
    end
    context "with data" do
      
      let(:dataset){ create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", data: Quandl::Fabricate::Data.rand(rows: 20, columns: 2, nils: false) ) }
      subject{ dataset }
      
      its(:saved?){ should be_true }
      its(:status){ should eq 201 }
  
    end
  end
  
  context "when updated" do
  
    let(:dataset){ create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", data: Quandl::Fabricate::Data.rand(rows: 20, columns: 2, nils: false).to_csv ) }
    subject{ Dataset.find(dataset.id) }
    
    it "should include new row" do
      new_data = 10.times.collect{|i| [Date.parse(subject.to_date) + i + 1, rand(12), rand(12) ] }
      new_data = Quandl::Data.new(new_data).sort_descending
      subject.data = new_data
      subject.save
      updated_dataset = Dataset.find(subject.id)
      updated_dataset.data.to_date[0].should eq new_data.to_date[0]
    end
      
    it "should include old rows" do
      new_data = 10.times.collect{|i| [Date.parse(subject.to_date) + i + 2, rand(12), rand(12) ] }
      new_data = Quandl::Data.new(new_data).sort_descending
      subject.data = new_data
      subject.save
      updated_dataset = Dataset.find(subject.id)
      updated_dataset.data.count.should eq 30
    end
    
  end
  
  context "#destroy" do
    
    let(:dataset){ create(:dataset, private: false ) }
    before(:each){ dataset.destroy }
    subject{ dataset }
    
    its(:status){ should eq 200 }

    its(:request_started_at){ should be_a Time }
    its(:request_finished_at){ should be_a Time }
    its(:elapsed_request_time){ should be > 0 }
    
  end
  
  context "#destroy when user" do
    
    let(:dataset){ create(:dataset, private: false ) }
    
    it "should not delete the dataset with a user token" do
      id = dataset.id
      # behave as a user
      Quandl::Client.token = Spec::Config::Quandl.user_token
      user_dataset = Dataset.find(id)
      user_dataset.destroy
      user_dataset.status.should eq 403
    end
  
    after(:all){ Quandl::Client.token = Spec::Config::Quandl.token}
  
  end
  
end