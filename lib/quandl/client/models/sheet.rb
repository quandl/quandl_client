require 'quandl/client/models/dataset/searchable'
require 'quandl/client/models/dataset/properties'

module Quandl
module Client

class Sheet

  include ScopeBuilder::Model
  
  scope_builder_for :search
  
  search_scope :query, :page, :url_title
  search_helper :all, ->{ connection.where(attributes).fetch.to_a }
  search_helper :connection, -> { self.class.parent }

  search_scope.class_eval do
    delegate *Array.forwardable_methods, to: :all
  end
  
  class << self
    
    def find_by_url_title(title)
      where( url_title: title ).find('show')
    end
    
  end
  
  # ORM
  include Her::Model
  use_api Client.her_api
  attributes :title, :url_title, :content
  
  def html
    @html ||= @attributes['html'] || Sheet.find(self.url_title).instance_variable_get('@attributes')['data']
  end
    
  def id
    'show'
  end
  
end

end
end