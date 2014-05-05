module Her
  module Model
    module Attributes
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