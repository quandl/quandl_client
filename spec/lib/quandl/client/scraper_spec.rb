# encoding: utf-8
require 'spec_helper'

describe Scraper do
  
  let(:scraper){ Scraper.new }
  subject{ scraper }
  
  its(:valid?){ should be_false }
  
  context "name='file'" do
    before(:each){ scraper.name = "file-#{Time.now.to_i}.rb" }
    
    its(:save){ should be_false }
    
    context "save" do
      before(:each){ scraper.save }
      its(:error_messages){ should eq( {:response_errors => {"location" => ["You must provide one of: [ scraper_url, git_url ]"]}}) }
    end
    
    context "scraper_url='https://github.com/tammer/scrapers/blob/master/shibor.rb'" do
      before(:each){ 
        scraper.scraper_url = "https://github.com/tammer/scrapers/blob/master/shibor.rb" 
        scraper.save
      }
      its(:valid?){ should be_true }
      its(:saved?){ should be_true }
      its(:id){ should be_present }
      its(:scraper_url){ should match /s3/}
      its(:git_url){ should be_blank }
      its(:type){ should eq 'Scraper::Script' }
    end
    
    context "git_url='git@github.com:tammer/scrapers.git'" do
      before(:each){ 
        scraper.git_url = "git@github.com:tammer/scrapers.git" 
        scraper.save
      }
      its(:error_messages){ should eq({:response_errors=>{"location.reference"=>["can't be blank"]}}) }
    end
    
    context "git_url='git@github.com:tammer/scrapers.git' & git_reference='master'" do
      let(:git_url){ "git@github.com:tammer/scrapers-#{Time.now.to_i}.git"  }
      before(:each){
        scraper.git_url = git_url
        scraper.git_reference = "master" 
        scraper.save
      }
      its(:valid?){ should be_true }
      its(:saved?){ should be_true }
      its(:id){ should be_present }
      its(:scraper_url){ should be_blank }
      its(:git_url){ should eq git_url }
      its(:type){ should eq 'Scraper::Git' }
    end
    
  end
  
end