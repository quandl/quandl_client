# encoding: utf-8
require 'spec_helper'

describe Scraper do
  
  let(:scraper){ Scraper.new }
  subject{ scraper }
  
  its(:valid?){ should be_false }
  
  context "name='file'" do
    before(:each){ scraper.name = "file-#{uuid}.rb" }
    
    its(:save){ should be_false }
    
    context "save" do
      before(:each){ scraper.save }
      its("error_messages.to_s"){ should match "You must provide one of" }
      its("error_messages.to_s"){ should match "scraper_url, git_url" }
    end
    
    context "scraper= File" do
      before(:each){ 
        scraper.scraper = "spec/fixtures/scraper.rb"
        scraper.save
      }
      its(:valid?){ should be_true }
      its(:saved?){ should be_true }
      its(:id){ should be_present }
      its(:scraper_url){ should match /s3/}
      its(:git_url){ should be_blank }
      its(:type){ should eq 'Scraper::Script' }
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
      its("error_messages.to_s"){ should match %Q{can't be blank} }
    end
    
    context "git_url='git@github.com:tammer/scrapers.git' & git_reference='master'" do
      before(:each){
        subject.git_url = "git@github.com:tammer/scrapers-#{uuid}.git" 
        subject.git_reference = "master" 
        subject.save
      }
      its(:valid?){ should be_true }
      its(:saved?){ should be_true }
      its(:id){ should be_present }
      its(:git_url){ should match /git@github.com:tammer\/scrapers/ }
      its(:type){ should eq 'Scraper::Git' }
    end
    
  end
  
end