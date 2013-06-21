require 'quandl/client/models/dataset/searchable'
require 'quandl/client/models/dataset/properties'

module Quandl
module Client

class Source
  
  include Concerns::Search
  include Concerns::Properties
  
  ##########  
  # SCOPES #
  ##########
  
  search_scope :query
  search_scope :page, ->(p){ where( page: p.to_i )}
  search_scope :code, ->(c){ where( code: c.to_s.upcase )}
  
  
  ###############
  # ASSOCIATIONS #
  ###############
  
  def datasets
    Dataset.source_code(code)
  end
  
  
  ###############
  # VALIDATIONS #
  ###############
   
  validates :code, presence: true, length: { minimum: 2 }, format: { with: /^([A-Z][A-Z0-9_]+)$/ }
  validates :host, :name, presence: true
  

  ##############
  # PROPERTIES #
  ##############
   
  attributes :code, :name, :host, :description, :datasets_count, :use_proxy, :type, :concurrency
  
end

end
end