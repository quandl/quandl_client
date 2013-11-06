# encoding: utf-8
require 'spec_helper'

describe Dataset do
  let(:dataset){ create(:dataset) }
  subject{ dataset }
  
  describe ".touch_existing(:id)" do
    it "should touch the dataset" do
      dataset.updated_at
      sleep(0.75)
      Dataset.touch_existing(subject.id).should eq true
      Dataset.find(subject.id).updated_at.should_not eq dataset.updated_at
    end
  end
  
end