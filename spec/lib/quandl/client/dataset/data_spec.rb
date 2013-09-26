# encoding: utf-8
require 'spec_helper'

describe Dataset do

  let(:dataset){ 
    create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", data: Quandl::Fabricate::Data::Table.rand( rows: 10, columns: 4 ) )
  }
    
  describe "#data" do
    subject{ Dataset.find( dataset.id ).data }
    its(:count){ should eq 10 }
  end
  
  context "updated" do
    
    subject{
      dataset
      sleep(0.5)
      Dataset.find( dataset.id )
    }
    
    describe "#data" do
      before(:each){ subject.data = Quandl::Fabricate::Data::Table.rand( rows: 12, columns: 4 ); subject.save }
      its(:updated_at){ should_not eq dataset.updated_at }
      its(:data){ should_not eq dataset.data }
      its(:refreshed_at){ should_not eq dataset.refreshed_at }
    end
  
    context "#column_spec" do
      before(:each){ subject.column_spec = "[0,[\"Date \\n\",{}],[\"Column 1 \",{}],[\"New Column Name \",{}]]"; subject.save }
      its(:updated_at){ should_not eq dataset.updated_at }
      its(:column_spec){ should_not eq dataset.column_spec }
    end
  
  end
  

end