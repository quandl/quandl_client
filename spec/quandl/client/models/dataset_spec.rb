# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  describe "#update" do
    
    before(:all){ Quandl::Client.token = AUTH_TOKEN }
  
    let(:source){ create(:source) }
    let(:dataset){ create(:dataset, source_code: source.code ) }
    
    it "should update with data" do
      rdataset = Dataset.find(dataset.id)
      data = Quandl::Data::Random.table(rows: 100, columns: 4)
      rdataset.data = data.to_csv
      rdataset.save
      Dataset.find(dataset.id).data_table.to_date.count.should eq data.to_date.count
    end
    
  end
  
  describe "#find" do
    
    before(:all){ Quandl::Client.token = AUTH_TOKEN }
  
    let(:source){ create(:source) }
    let(:dataset){ create(:dataset, source_code: source.code ) }
    
    it "should find the dataset by id" do
      Dataset.find(dataset.id).id.should eq dataset.id
    end
    
    it "should find the dataset by full code" do
      Dataset.find(dataset.full_code).id.should eq dataset.id
    end
    
  end
  
  describe "#new" do
    
    subject{ build(:dataset) }
    
    its(:valid?){ should be_true }
    
  end
  
  describe "#save" do
    
    context "without token" do
  
      before(:all){ Quandl::Client.token = '' }
      
      let(:dataset){ create(:dataset) }
      subject{ dataset }
    
      its(:saved?){ should be_false }
      its(:status){ should eq 401 }
      
    end
  
    context "with token" do
      
      before(:all){ Quandl::Client.token = AUTH_TOKEN }
    
      let(:source){ create(:source) }
      let(:dataset){ create(:dataset, source_code: source.code ) }
      subject{ dataset }

      its(:saved?){ should be_true }
      its(:status){ should eq 201 }

    end
    
  end
  
end