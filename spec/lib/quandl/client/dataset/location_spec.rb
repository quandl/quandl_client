# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  subject{
    build(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE" )
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
    context "with navigation" do      
      it "should return the data in the right order" do
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
    context "datasets sharing location" do
      
      let(:location){ [{ category: "http", url: "http://www.bankofcanada.ca/rates/price-indexes/cpi/"}] }
      let(:dataset1){ create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", locations: location ) }
      let(:dataset2){ create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", locations: location ) }
      
      it "should share the location" do
        Dataset.find(dataset1.id).locations.should eq Dataset.find(dataset2.id).locations
      end
      
      it "should update the dataset" do
        d = Dataset.find(dataset1.id)
        d.data = [[ Date.today, 42, 68 ]]
        d.save
        d.status.should eq 200
      end
      
    end
  end
  
end