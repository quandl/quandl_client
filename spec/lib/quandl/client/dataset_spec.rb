# encoding: utf-8
require 'spec_helper'

describe Dataset do
  let(:dataset){ create(:dataset) }
  subject{ dataset }
  
  describe ".touch_existing(:id)" do
    it "should touch the dataset" do
      dataset.updated_at
      sleep(1)
      Dataset.touch_existing(subject.id).should eq true
      Dataset.find(subject.id).updated_at.should_not eq dataset.updated_at
    end
  end
  
  describe ".query" do
    let(:datasets){ Quandl::Client::Dataset.query('water').to_a }
    subject{ datasets }
    its(:first){ should be_a Quandl::Client::Dataset }
    its(:count){ should eq 16 }
  end
  
end