module Her
  module Model
    module Attributes
      def initialize(attributes={})
        if attributes.is_a?(Integer)
          attributes = { id: attributes }
        end
        attributes ||= {}
        @metadata = attributes.delete(:_metadata) || {}
        @response_errors = attributes.delete(:_errors) || {}
        @destroyed = attributes.delete(:_destroyed) || false

        attributes = self.class.default_scope.apply_to(attributes)
        assign_attributes(attributes)
        run_callbacks :initialize
      end
      
      def self.initialize_collection(klass, parsed_data={})
        arr = klass.extract_array(parsed_data)
        arr = [] unless arr.is_a?(Array)
        collection_data = arr.map do |item_data|
          resource = klass.new(klass.parse(item_data))
          resource.run_callbacks :find
          resource
        end
        Her::Collection.new(collection_data, parsed_data[:metadata], parsed_data[:errors])
      end
      
    end
    
  end
end