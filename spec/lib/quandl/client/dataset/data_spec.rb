# encoding: utf-8
require 'spec_helper'

describe Dataset do

  let(:dataset){ 
    create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", data: Quandl::Fabricate::Data.rand( rows: 10, columns: 4 ) )
  }

  describe "#data" do
    subject{ Dataset.find( dataset.id ).data }
    its(:count){ should eq 10 }
    its(:to_h){ should be_a Hash }
  end
  
  context "updated" do
    
    subject{
      dataset.updated_at
      sleep(0.75)
      Dataset.find( dataset.id )
    }
    
    describe "#data" do
      before(:each){ subject.data = Quandl::Fabricate::Data.rand( rows: 12, columns: 4 ); sleep(1); subject.save }
      its(:updated_at){ should_not eq dataset.updated_at }
      its(:data){ should_not eq dataset.data }
      its(:refreshed_at){ should_not eq dataset.refreshed_at }
    end
  
    context "#column_spec" do
      before(:each){ subject.column_spec = "[0,[\"Date \\n\",{}],[\"Column 1 \",{}],[\"New Column Name \",{}]]"; sleep(1); subject.save }
      its(:updated_at){ should_not eq dataset.updated_at }
      its(:column_spec){ should_not eq dataset.column_spec }
    end
  
  end
  
  describe "#delete_data" do
    subject{ Dataset.find( dataset.id ) }
    before(:each){ subject.delete_data }
    its(:data){ should be_blank }
  end
  
  describe "#delete_rows" do
    subject{ Dataset.find( dataset.id ) }
    
    let(:dates_slice){ dataset.data.to_h.keys[5..8] }
    
    it "should have the dates" do
      dates = Dataset.find( dataset.id ).data.to_h.keys
      dates_slice.each{|date| dates.include?(date).should be_true }
    end
    
    context "after deleting rows" do
    
      before(:each){ subject.delete_rows(dates_slice) }
      
      it "data count should be 16" do
        Dataset.find( dataset.id ).data.count.should eq 6
      end
    
      it "data should have dates" do
        dates = Dataset.find( dataset.id ).data.to_h
        dates.each{|date| dates_slice.include?(date).should be_false }
      end
    
    end
  end
  
end