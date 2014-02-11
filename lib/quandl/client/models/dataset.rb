class Quandl::Client::Dataset < Quandl::Client::Base
  
  require 'quandl/client/models/dataset/data'

  ##########  
  # SCOPES #
  ##########
  class << self
    def touch_existing(id)
      put(File.join(Quandl::Client::Base.url_with_version, "datasets/#{id}/touch")).exists?
    end
  
    def find(value)
      # enforce code formatting
      if value.is_a?(String)
        # ensure slashes are forward facing
        value = value.gsub("\\","/").gsub(".","/")
        # ensure uppercase
        value = value.upcase
      end
      # short-circuit if value is illegal
      return nil unless value.is_a?(Integer) || value.to_s =~ %r{^#{Quandl::Pattern.full_code}$}
      super(value)
    end
  
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
  
  validates :code, presence: true, format: { with: Quandl::Pattern.code, message: "is invalid. Expected format: #{Quandl::Pattern.code.to_example}" }
  validates :display_url, allow_blank: true, url: true
  validate :data_row_count_should_match_column_count!
  validate :data_columns_should_not_exceed_column_names!
  validate :data_rows_should_have_equal_columns!
  validate :ambiguous_code_requires_source_code!
  
  
  ##############
  # PROPERTIES #
  ##############
  
  attributes :source_code, :code, :name, :urlize_name, 
    :description, :updated_at, :frequency,
    :from_date, :to_date, :column_names, :private, :type,
    :display_url, :column_spec, :import_spec, :import_url,
    :locations_attributes, :availability_delay, :refreshed_at
    
  before_save :enforce_required_formats
  
  after_save :save_dataset_data
  
  alias_method :locations, :locations_attributes
  alias_method :locations=, :locations_attributes=
  
  def reference_url
    self.display_url
  end
  def reference_url=(value)
    value = "http://#{value}" if value.present? && !(value =~ /:\/\//)
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
  
  protected
  
  def ambiguous_code_requires_source_code!
    if code.to_s.numeric? && source_code.blank?
      message = %Q{Pure numerical codes like "#{code}" are not allowed unless you prefix them with a source code. Do this:\ncode: <your-username>/#{code}}
      self.errors.add( :data, message )
      return false
    end
    true 
  end
  
  def data_columns_should_not_exceed_column_names!
    if errors.size == 0 && dataset_data.data? && column_names.present? && data.first.count != column_names.count
      self.errors.add( :data, "You may not change the number of columns in a dataset. This dataset has #{column_names.count} columns but you tried to send #{data.first.count} columns." )
      return false
    end
    true 
  end
  
  def data_rows_should_have_equal_columns!
    # skip validation unless data is present
    return true unless dataset_data.data?
    # use first row as expected column count
    column_count = data[0].count
    # check each row
    data.each_with_index do |row, index|
      # the row is valid if it's count matches the first row's count
      next if row.count == column_count
      # the row is invalid if the count is mismatched
      self.errors.add( :data, "Unexpected number of points in this row:\n#{row.join(',')}\nFound #{row.size-1} but expected #{data[0].size-1} based on precedent from the first row (#{data[0].join(',')})" )
      # return validation failure
      return false
    end
    true
  end
  
  def data_row_count_should_match_column_count!
    # skip validation unless data and column_names present
    return true unless dataset_data.data? && column_names.present?
    # count the number of expected columns
    column_count = column_names.count
    # check each row
    data.each_with_index do |row, index|
      # the row is valid if it's count matches the first row's count
      next if row.count == column_count
      # the row is invalid if the count is mismatched
      self.errors.add( :data, "Unexpected number of points in this row:\n#{row.join(',')}\nFound #{row.size-1} but expected #{column_names.count-1} based on precedent from the header row (#{column_names.join(',')})" )
      # return validation failure
      return false
    end
    true
  end
  
  def save_dataset_data
    return if (!saved? && id.blank?)
    return if !dataset_data.data?
    
    dataset_data.id = id
    dataset_data.save
    # update dataset's attributes with dataset_data's attributes
    attributes.each{|k,v| attributes[k] = dataset_data.attributes[k] if dataset_data.attributes.has_key?(k) }
    @metadata[:status] = dataset_data.status
  end
  
  def enforce_required_formats
    # self.data = Quandl::Data.new(data).to_csv
    self.source_code = self.source_code.to_s.upcase
    self.code = self.code.to_s.upcase
    self.locations_attributes = locations_attributes.to_json if locations_attributes.respond_to?(:to_json) && !locations_attributes.kind_of?(String)
  end
  
end