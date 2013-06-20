require 'quandl/client/models/dataset/searchable'
require 'quandl/client/models/dataset/properties'

module Quandl
module Client

class Sheet

  include ScopeBuilder::Model
  
  scope_builder_for :search
  
  search_scope :query, :page, :parent_url_title
  search_helper :all, ->{ connection.where(attributes).fetch.to_a }
  search_helper :connection, -> { self.class.parent }

  search_scope.class_eval do
    delegate *Array.forwardable_methods, to: :all
  end
  
  # ORM
  include Her::Model
  use_api Client.her_api
  attributes :title, :content, :url_title, :full_url_title
  
  def html
    @html ||= self.attributes[:html] || Sheet.find(full_url_title).attributes[:html]
  end
  
  def parent
    @parent ||= Sheet.find(parent_url_title)
  end
  
  def children
    Sheet.parent_url_title(self.full_url_title)
  end
  
  def parent_url_title
    @parent_url_title ||= self.full_url_title.split('/')[0..-2].join()
  end
  
end

end
end