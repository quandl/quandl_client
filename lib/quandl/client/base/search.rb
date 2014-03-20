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
      
      def each_in_page(&block)
        # fetch records
        records = all
        # pass each record upstream
        records.each{|r| block.call( r ) }
        # blank array indidcates last page
        return if records.blank? || records.count < records.try(:metadata).try(:[], :per_page).to_i
        # next page
        scope_attributes[:page] = 1 if scope_attributes[:page].blank?
        scope_attributes[:page] = scope_attributes[:page].to_i + 1
        # call recursively until we reach the end
        each_in_page(&block)
      end
      
    end
  
  end
end

end