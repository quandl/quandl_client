class Quandl::Client::Dataset < Quandl::Client::Base
  
  require 'quandl/client/models/dataset/data'
  
  ##########  
  # SCOPES #
  ##########
  
  # SEARCH
  scope :query, :rows
  scope :page, ->(p){ where( page: p.to_i )}
  scope :source_code, ->(c){ where( code: c.to_s.upcase )}
  
  ###############
  # ASSOCIATIONS #
  ###############
   
  def source
    @source ||= Source.find(self.source_code)
  end
  
  delegate :data, :data=, to: :dataset_data
  
  def dataset_data
    @dataset_data ||= Dataset::Data.find(self.id) || Dataset::Data.new( id: self )
  end
  
  ###############
  # VALIDATIONS #
  ###############
  
  validates :code, presence: true, format: { with: /[A-Z0-9_]+/ }
  validates :name, presence: true, :length => { :maximum => 1000 }
  
  
  ##############
  # PROPERTIES #
  ##############
  
  attributes :source_code, :code, :name, :urlize_name, 
    :description, :updated_at, :frequency,
    :from_date, :to_date, :column_names, :private, :type,
    :display_url, :column_spec, :import_spec, :import_url,
    :locations_attributes, :availability_delay, :refreshed_at
    
  before_save :enforce_required_formats
  
  alias_method :locations, :locations_attributes
  alias_method :locations=, :locations_attributes=
  
  def full_code
    @full_code ||= File.join(self.source_code, self.code)
  end
  
  protected
  
  def enforce_required_formats
    # self.data = Quandl::Data::Table.new(data).to_csv
    self.locations_attributes = locations_attributes.to_json if locations_attributes.respond_to?(:to_json) && !locations_attributes.kind_of?(String)
  end
  
end