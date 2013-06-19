module Quandl
module Client
  
class Dataset

module Searchable

  extend ActiveSupport::Concern

  included do
  
    include ScopeBuilder::Model
    
    scope_builder_for :search, :show
  
    # SEARCH
  
    search_scope :query, :rows
    search_scope :page, ->(p){ where( page: p.to_i )}
    search_scope :source_code, ->(c){ where( code: c.to_s.upcase )}

    search_helper :all, ->{ connection.where(attributes).fetch }
    search_helper :connection, -> { self.class.parent }
    
    search_scope.class_eval{ delegate *Array.forwardable_methods, to: :all }
    
    # SHOW
    
    show_scope :rows, :exclude_data, :exclude_headers, :trim_start, :trim_end, :transform, :collapse
    show_helper :find, ->(id){ connection.where(attributes).find( id ) }
    show_helper :connection, -> { self.class.parent }
    
  end
  
end

end
end
end