require 'quandl/client/models/source'
require 'quandl/client/models/dataset'
require 'quandl/client/models/sheet'

module Quandl
  module Client
    class Base
      
      include ScopeBuilder::Model
      include Her::Model

      scope_builder_for :search
      
      search_helper :all, ->{ connection.where(attributes).fetch }
      search_helper :connection, -> { self.class.parent }
  
      search_scope.class_eval do
        delegate *Array.forwardable_methods, to: :all
      end
  
      before_save :halt_unless_valid!
  
      protected
  
      def halt_unless_valid!
        return false unless valid?
      end
  
    end
  end
end