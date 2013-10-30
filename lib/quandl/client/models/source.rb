module Quandl
module Client

class Source < Quandl::Client::Base
  
  ##########  
  # SCOPES #
  ##########
  
  scope :query
  scope :page, ->(p){ where( page: p.to_i )}
  scope :code, ->(c){ where( code: c.to_s.upcase )}
  
  
  ###############
  # ASSOCIATIONS #
  ###############
  
  def datasets
    Dataset.source_code(code)
  end
  
  
  ###############
  # VALIDATIONS #
  ###############
   
  validates :code, presence: true, length: { minimum: 2 }, format: { with: /([A-Z0-9_]+)/ }
  validates :host, :name, presence: true
  

  ##############
  # PROPERTIES #
  ##############
   
  attributes :code, :name, :host, :description, :datasets_count, :use_proxy, :type, :concurrency
  
end

end
end