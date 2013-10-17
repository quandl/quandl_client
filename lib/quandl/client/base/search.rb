class Quandl::Client::Base
module Search
  
  extend ActiveSupport::Concern

  included do

    include ScopeComposer::Model

    has_scope_composer

    scope :with_id,      ->(value)   { where( id: value.to_i )}
    scope_helper :all, ->{ connection.where(attributes).fetch }
    scope_helper :connection, -> { self.class.parent }
    
    scope.class_eval do
    
      delegate *Array.forwardable_methods, to: :all
      
      def fetch_once
        @fetch_once ||= fetch
      end
    
      def fetch
        find(attributes[:id])
      end
    
      def find(id)
        result = self.class.parent.where(attributes).find(id)
        result = self.class.parent.new(id: id) if result.nil?
        result
      end
    
    end
  
  end
end

end