class Quandl::Client::Base
module Search
  
  extend ActiveSupport::Concern
  
  module ClassMethods
    def forwardable_scope_methods
      @forwardable_scope_methods ||= Array.forwardable_methods.reject{|m| [:find, :fetch].include?(m) }
    end
  end
  
  included do

    include ScopeComposer::Model

    has_scope_composer

    scope :with_id,      ->(value)   { where( id: value.to_i )}
    scope_helper :all, ->{ connection.where(attributes_with_scopes).fetch }
    scope_helper :connection, -> { self.class.parent }
    
    scope.class_eval do

      delegate *Array.forwardable_methods.reject{|m| [:find, :fetch].include?(m) }, to: :all
      
      def fetch_once
        @fetch_once ||= fetch
      end
    
      def fetch
        find(attributes_with_scopes[:id])
      end
    
      def find(id)
        result = self.class.parent.where( attributes_with_scopes ).find(id)
        result = self.class.parent.new(id: id) if result.nil?
        result
      end
      
      def attributes_with_scopes
        attributes.merge(scope_attributes)
      end
      
    end
  
  end
end

end