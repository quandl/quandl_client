require 'quandl/client/models/dataset/searchable'
require 'quandl/client/models/dataset/properties'

module Quandl
module Client

class Source < Quandl::Client::Base

  search_scope :query
  search_scope :page, ->(p){ where( page: p.to_i )}
  search_scope :code, ->(c){ where( code: c.to_s.upcase )}
  
  use_api Client.her_api

  attributes :code, :name, :host, :description, :datasets_count, :use_proxy, :type, :concurrency

  validates :code, presence: true, length: { minimum: 2 }, format: { with: /^([A-Z][A-Z0-9_]+)$/ }
  validates :host, :name, presence: true
  
  def datasets
    Dataset.source_code(code)
  end
  
end

end
end