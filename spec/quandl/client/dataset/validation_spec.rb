# encoding: utf-8
require 'spec_helper'

describe Dataset do
  
  describe "#code" do

    before(:all){ Quandl::Client.token = ENV['QUANDL_AUTH_TOKEN'] }
    
    let(:source){ create(:source) }
    let(:dataset){ create(:dataset, source_code: source.code ) }
    let(:invalid_dataset){ create(:dataset, source_code: source.code, code: dataset.code ) }
    subject{ invalid_dataset }

    its(:saved?){ should be_false }
    its(:status){ should eq 422 }
    
  end
  

end