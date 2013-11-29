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
  
  it "should change url" do
    Quandl::Client.use('http://url.com/')
    Quandl::Client::Dataset.url.should eq 'http://url.com/v2'
    Quandl::Client.use('http://url.com/2/')
    Quandl::Client::Dataset.url.should eq 'http://url.com/2/v2'
    Quandl::Client.use ENV['QUANDL_API_HOST']
  end
  
  describe ".query" do
    let(:datasets){ Quandl::Client::Dataset.query('oil').all }
    subject{ datasets }

    its(:first){ should be_a Quandl::Client::Dataset }
    
    describe "#metadata" do
      subject{ OpenStruct.new(datasets.metadata) }
      its(:total_count){ should > 1 }
      its(:per_page){ should eq 20 }
      its(:sources){ should be_present }
      its(:status){ should eq 200 }
      its(:current_page){ should eq 1 }
    end
  end
  
end