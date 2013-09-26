# encoding: utf-8
require 'spec_helper'

describe Dataset do

  let(:dataset){ 
    d = create(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", data: Quandl::Fabricate::Data::Table.rand( rows: 10, columns: 4 ) ) 
    Dataset.find( d.id )
  }
  let(:previous_attributes){ dataset.attributes.clone }

  before(:each){ previous_attributes }
  
  describe "#data" do
    subject{ dataset.data }
    its(:count){ should eq 10 }
  end
  
  context "updated" do
    
    subject{ dataset.save; Dataset.find(dataset.id) }
    
    describe "#data" do
      before(:each){ dataset.data = Quandl::Fabricate::Data::Table.rand( rows: 12, columns: 4 ) }
      its(:updated_at){ should_not eq previous_attributes['updated_at'] }
      its(:data){ should_not eq previous_attributes['data'] }
    end
  
    context "#column_spec" do
      before(:each){ dataset.column_spec = "[0,[\"Date \\n\",{}],[\"Column 1 \",{}],[\"New Column Name \",{}]]" }
      its(:column_spec){ should_not eq previous_attributes['column_spec'] }
    end
  
  end
  

end