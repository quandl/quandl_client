# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  subject{ build(:dataset, source_code: "QUANDL_CLIENT_TEST_SOURCE", data: Quandl::Fabricate::Data.rand(rows: 20, columns: 2) ) }
  
  describe "#from_date" do
    context "before_save" do
      it "should be nil" do
        subject.from_date.should be_nil
      end
    end
    context "after_save" do
      before(:each){ subject.save }
      it "should equal the last date" do
        subject.from_date.should eq subject.data.to_date[-1][0].to_s
      end
    end
  end
  
  describe "#to_date" do
    context "before_save" do
      it "should be nil" do
        subject.to_date.should be_nil
      end
    end
    context "after_save" do
      before(:each){ subject.save }
      it "should equal the first date" do
        subject.to_date.should eq subject.data.to_date[0][0].to_s
      end
    end
  end
  
end