# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  subject{
    build(:dataset, source_code: create(:source).code )
  }
  
  describe "#availability_delay" do
    context "given valid input" do
      it "saves the delay" do
        delay = '02:00:10'
        subject.availability_delay = delay
        subject.save
        Dataset.find(subject.id).availability_delay.should eq delay
      end
      
    end
  end

  describe "#locations" do
    it "should save and return the location data" do
      locations = [
        {
          category:     'js_http',
          url:      "http://test-#{(Time.now.to_f * 1000).to_i}.com/data",
          navigation: [
            {:id => 'id303', :type => 'link'},
            {:name => 'selectionname', :type => 'text', :value => 'cd' },
            {:name => 'auswaehlen', :type => 'button'},
            {:id => "id#cd", :type => 'link'},
            {:name => 'werteabruf', :type => 'button'}
          ]
        }
      ]
      subject.locations = locations
      subject.save
      dataset = Dataset.find(subject.id)
      dataset.locations[0][:category].should eq locations[0][:category]
      dataset.locations[0][:url].should eq locations[0][:url]
      dataset.locations[0][:navigation].should eq locations[0][:navigation]
    end
  end
  
end