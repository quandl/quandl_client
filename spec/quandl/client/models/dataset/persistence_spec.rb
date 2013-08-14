# encoding: utf-8
require 'spec_helper'

describe Dataset do
  context "when built" do
    subject{ build(:dataset) }
    its(:valid?){ should be_true }
  end
  
  context "when created" do
    context "without token" do
  
      before(:all){ Quandl::Client.token = '' }
      
      let(:dataset){ create(:dataset) }
      subject{ dataset }
  
      its(:saved?){ should be_false }
      its(:status){ should eq 401 }
    
    end
    context "with token" do

      before(:all){ Quandl::Client.token = ENV['QUANDL_AUTH_TOKEN'] }
      
      let(:source){ create(:source) }
      let(:dataset){ create(:dataset, source_code: source.code ) }
      subject{ dataset }
  
      its(:saved?){ should be_true }
      its(:status){ should eq 201 }
  
    end
  end
  
  context "when updated" do

    let(:source){ create(:source) }
    let(:dataset){ create(:dataset, source_code: source.code, data: Quandl::Data::Random.table(rows: 20, columns: 2).to_csv ) }
        
    it "should change data" do
      # update the dataset
      subject = Dataset.find(dataset.id)
      new_row = [ subject.data_table[0][0], 1.0, 2.0]
      subject.data = [ new_row ]
      subject.save
      # check the data
      Dataset.find(dataset.id).data_table.sort_descending[0].should eq new_row
    end
    
    it "should change column_spec" do
      subject = Dataset.find(dataset.id)
      subject.column_spec = "[0,[\"Date \\n\",{}],[\"Column 1 \",{}],[\"New Column Name \",{}]]"
      subject.save
      Dataset.find(dataset.id).column_spec.should eq subject.column_spec
    end
    
  end
  
end