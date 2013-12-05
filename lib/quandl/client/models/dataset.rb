class Quandl::Client::Dataset < Quandl::Client::Base
  
  require 'quandl/client/models/dataset/data'

  # parse_root_in_json true
  # root_element :docs
  
  ##########  
  # SCOPES #
  ##########
  
  def self.touch_existing(id)
    put(File.join(Quandl::Client::Base.url_with_version, "datasets/#{id}/touch")).exists?
  end
  
  # SEARCH
  scope :query, :rows
  scope :page, ->(p){ where( page: p.to_i )}
  scope :source_code, ->(c){ where( code: c.to_s.upcase )}
  
  ###############
  # ASSOCIATIONS #
  ###############
   
  def source
    @source ||= Quandl::Client::Source.find(self.source_code)
  end
  
  ###############
  # VALIDATIONS #
  ###############
  
  validates :code, presence: true, format: { with: /[A-Z0-9_]+/ }
  validates :display_url, allow_blank: true, url: true
  
  
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
  
  def reference_url
    self.display_url
  end
  def reference_url=(value)
    self.display_url = value
  end
  
  def full_url
    File.join(Quandl::Client::Base.url.gsub('api/', ''), full_code)
  end
  
  def full_code
    File.join(self.source_code.to_s, self.code.to_s)
  end
  
  # DATA
  
  def data
    dataset_data.data? ? dataset_data.data : data_scope
  end
  
  def data=(value)
    dataset_data.data = value
  end

  def delete_data
    # cant delete unsaved records
    return false if new_record?
    # delete and return success / failure
    self.class.destroy_existing("#{id}/data").saved?
  end

  def delete_rows(*dates)
    # cant delete unsaved records
    return false if new_record?
    # collect dates
    query = { dates: Array(dates).flatten }.to_query
    # delete and return success / failure
    self.class.destroy_existing("#{id}/data/rows?#{query}").saved?
  end
  
  def data_scope
    @data_scope ||= Quandl::Client::Dataset::Data.with_id(id)
  end
  
  def dataset_data
    @dataset_data ||= Quandl::Client::Dataset::Data.new( id: id )
  end
  
  def reload
    @dataset_data = nil
    @data_scope = nil
    @full_code = nil
  end
  
  after_save :save_dataset_data
  
  protected
  
  def save_dataset_data
    dataset_data.id = id
    dataset_data.save
    # update dataset's attributes with dataset_data's attributes
    attributes.each{|k,v| attributes[k] = dataset_data.attributes[k] if dataset_data.attributes.has_key?(k) }
  end
  
  def enforce_required_formats
    # self.data = Quandl::Data.new(data).to_csv
    self.locations_attributes = locations_attributes.to_json if locations_attributes.respond_to?(:to_json) && !locations_attributes.kind_of?(String)
  end
  
end