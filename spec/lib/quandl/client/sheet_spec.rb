# encoding: utf-8
require 'spec_helper'

describe Sheet do
  before(:all){ Quandl::Client.token = Spec::Config::Quandl.token}
  
  let(:sheet){ build(:sheet) }
  
  subject{ sheet }
  
  its(:valid?){ should be_true }
  
  context "when saved" do
    before(:each){ subject.save }
    
    its(:saved?){ should be_true }
    
    describe "#description" do
      its(:description){ should eq "Test sheet description." }

      it "should find the description" do
        Sheet.find( subject.id ).description.should eq "Test sheet description."
      end
    end
  end

  it "should update the description" do
    subject.description = "New description."
    subject.save
    Sheet.find( subject.id ).description.should eq "New description."
  end

  it "should update the redirect_path" do
    subject.redirect_path = "test_redirect_path"
    subject.save
    Sheet.find( subject.id ).redirect_path.should eq "test_redirect_path"
  end
end

