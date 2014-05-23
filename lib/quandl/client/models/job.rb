class Quandl::Client::Job < Quandl::Client::Base
  
  collection_path "scrapers/:scraper_id/jobs"
  scope :for_scraper, ->(id){ where(scraper_id: id) }
  
end