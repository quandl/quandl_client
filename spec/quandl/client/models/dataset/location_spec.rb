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
  
end