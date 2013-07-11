module Quandl
module Client

class Dataset
  
  include Concerns::Search
  include Concerns::Properties
  
  
  ##########  
  # SCOPES #
  ##########
  
  # SEARCH
  search_scope :query, :rows
  search_scope :page, ->(p){ where( page: p.to_i )}
  search_scope :source_code, ->(c){ where( code: c.to_s.upcase )}
  
  # SHOW
  scope_builder_for :show
  show_scope :rows, :exclude_data, :exclude_headers, :trim_start, :trim_end, :transform, :collapse
  show_helper :find, ->(id){ connection.where(attributes).find( id ) }
  show_helper :connection, -> { self.class.parent }
  
  
  ###############
  # ASSOCIATIONS #
  ###############
   
  def source
    @source ||= Source.find(self.source_code)
  end
  
  
  ###############
  # VALIDATIONS #
  ###############
   
  validates :source_code, presence: true, length: { minimum: 2 }, format: { with: /([A-Z0-9_]+)/ }
  validates :code, presence: true, length: { minimum: 2 }, format: { with: /([A-Z0-9_]+)/ }
  validates :name, presence: true
  
  
  ##############
  # PROPERTIES #
  ##############
    
  attributes :data, :source_code, :code, :name, :urlize_name, 
    :description, :updated_at, :frequency, :from_date, 
    :to_date, :column_names, :private, :type, :display_url
    
  attributes :locations_attributes
  
  alias_method :locations, :locations_attributes
  alias_method :locations=, :locations_attributes=
  
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