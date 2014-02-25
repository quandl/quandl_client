module Quandl
module Client

class Scraper < Quandl::Client::Base
  
  attributes :id, :name, :scraper_url, :git_url, :git_reference, :created_at, :updated_at, :type
  
  validates :name, presence: true
  
end

end
end