module Quandl
module Client

class Dataset

module Properties

  extend ActiveSupport::Concern
  
  included do
    
    include Her::Model
    use_api Client.her_api
    
    attributes :data, :source_code, :code, :name, :urlize_name, 
      :description, :updated_at, :frequency, :from_date, 
      :to_date, :column_names, :private, :type
      
    attributes :locations_attributes
    
    alias_method :locations, :locations_attributes
    alias_method :locations=, :locations_attributes=
    
    validates :source_code, presence: true, length: { minimum: 2 }, format: { with: /^([A-Z][A-Z0-9_]+)$/ }
    validates :code, presence: true, length: { minimum: 2 }, format: { with: /^([A-Z][A-Z0-9_]+)$/ }
    validates :name, presence: true
    
    def errors
      self.attributes[:errors]
    end
    
    def full_code
      @full_code ||= File.join(self.source_code, self.code)
    end
  
    def data_table
      Data::Table.new( raw_data )
    end
    
    def raw_data
      @raw_data ||= (self.data || Dataset.find(full_code).data || [])
    end
    
  end
  
end

end
end
end
