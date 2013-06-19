require 'quandl/client/models/dataset/searchable'
require 'quandl/client/models/dataset/properties'

module Quandl
module Client

class Source

  include ScopeBuilder::Model
  
  scope_builder_for :search
  
  search_scope :query
  search_scope :page, ->(p){ where( page: p.to_i )}
  search_scope :code, ->(c){ where( code: c.to_s.upcase )}
  
  search_helper :all, ->{ connection.where(attributes).fetch }
  search_helper :connection, -> { self.class.parent }

  search_scope.class_eval do
    delegate *Array.forwardable_methods, to: :all
  end
  
  # ORM
  include Her::Model
  use_api Client.her_api
  attributes :code, :datasets_count, :description, :name, :host
  
  def datasets
    Dataset.source_code(code)
  end
  
  def id
    'show'
  end
  
end

end
end