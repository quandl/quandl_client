# encoding: utf-8
require 'spec_helper'

describe Dataset do
  let(:source){ create(:source) }
  subject{ create(:dataset, source_code: source.code, private: true ) }
  
  describe "#private" do
    
    it "should update to false" do
      subject.private = false
      subject.save
      Dataset.find(subject.id).private.should be_false
    end
    
    it "should update to true" do
      subject.private = false
      subject.save
      subject.private = true
      subject.save
      Dataset.find(subject.id).private.should be_true
    end
    
  end
  
end