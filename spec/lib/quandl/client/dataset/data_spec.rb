# encoding: utf-8
require 'spec_helper'

describe Quandl::Client::Dataset::Data do

  let(:dataset){ 
    create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", data: Quandl::Fabricate::Data.rand( rows: 10, columns: 4 ), column_names: ["Date", "C1", 'c2', 'c3', 'c4'] )
  }
  subject{ dataset }
  
  its(:valid?){ should be_true }
  
  describe ".with_id('NSE/OIL')" do
    let(:id){ Dataset.find("NSE/OIL").id }
    subject{ Quandl::Client::Dataset::Data.with_id(id) }
    let(:data){ Quandl::Client::Dataset::Data.with_id(id).to_table }
    
    let(:beginning_of_last_week){ Date.today.jd - Date.today.beginning_of_week.jd }
    
    it("data"){ data.count.should > 100 }
    it(".rows(5)"){ subject.rows(5).to_table.count.should eq 5 }
    it(".limit(2)"){ subject.limit(2).to_table.count.should eq 2 }
    it(".column(2)"){ subject.column(2).to_table.first.count.should eq 2 }
    it(".order('asc')"){ subject.order('asc').to_table.first.first.should eq data.sort_ascending!.first.first }
    it(".order('desc')"){ subject.order('desc').to_table.first.first.should eq data.sort_descending!.first.first }
    it(".trim_start().trim_end()"){ subject.trim_start( data[11].first ).trim_end(data[10].first).to_table.first.first.should eq data[10].first }
    it(".collapse('monthly')"){ subject.collapse('monthly').to_table.frequency.should eq :monthly }
    it(".transform('rdiff')"){ subject.transform('rdiff').to_table[0][1].should_not eq data[0][1] }
  end
  
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
      before(:each){ subject.column_spec = "[0,[\"Date\",{}],[\"c1 \",{}],[\"c2 \",{}],[\"c3 \",{}],[\"c234 \",{}]]"; sleep(1); subject.save }
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
    
    let(:dates_slice){ dataset.data.to_date.to_h.keys[5..8] }
    
    it "should have the dates" do
      dates = Dataset.find( dataset.id ).data.to_date.to_h.keys
      dates_slice.each{|date| dates.include?(date).should be_true }
    end
    
    context "after deleting rows" do
    
      before(:each){ subject.delete_rows(dates_slice) }
      
      it "data count should be 6" do
        Dataset.find( dataset.id ).data.count.should eq 6
      end
    
      it "data should have dates" do
        dates = Dataset.find( dataset.id ).data.to_h
        dates.each{|date| dates_slice.include?(date).should be_false }
      end
    
    end
  end
  
end