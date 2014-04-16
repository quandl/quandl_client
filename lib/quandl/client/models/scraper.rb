module Quandl
module Client

class Scraper < Quandl::Client::Base
  
  attributes :id, :name, :scraper, :scraper_url, :git_url, :git_reference, :created_at, :updated_at, :type, :schedule_at
  
  validates :name, presence: true
  
  def scraper=(value)
    write_attribute(:scraper, Faraday::UploadIO.new(value, 'text/plain') )
  end
  
end

end
end