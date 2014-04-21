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
      # preformat
      value = format_id(value)
      # short-circuit if value is illegal
      return nil unless value.is_a?(Integer) || value.to_s =~ %r{^#{Quandl::Pattern.full_code}$}
      # search
      super(value)
    end
    
    def format_id(value)
      # enforce code formatting
      if value.is_a?(String)
        # strip extra whitespace
        value = value.strip.rstrip
        # ensure slashes are forward facing
        value = value.gsub("\\","/").gsub(".","/")
        # ensure uppercase
        value = value.upcase
      end
      value
    end
  
  end
  
  # SEARCH
  scope :query, :rows, :owner
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
  validate :data_should_be_valid!
  validate :dataset_data_should_be_valid!
  validate :data_row_count_should_match_column_count!
  validate :data_columns_should_not_exceed_column_names!
  validate :data_rows_should_have_equal_columns!
  validate :ambiguous_code_requires_source_code!
  
  validate :source_code_should_exist!
  
  
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
    defined?(@data) ? @data : data_scope
  end
  
  def data=(value)
    @data = Quandl::Data.new(value).sort_descending
  end
  
  def data?
    @data.is_a?(Quandl::Data)
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
  
  def dataset_data?
    @dataset_data.is_a?(Quandl::Client::Dataset::Data)
  end
  
  def reload
    @dataset_data = nil
    @data_scope = nil
    @full_code = nil
  end
  
  protected
  
  def data_should_be_valid!
    if data? && !data.valid?
      data.errors.each{|k,v| self.errors.add( k,v ) }
      return false
    end
    true
  end
  
  def dataset_data_should_be_valid!
    if dataset_data? && !dataset_data.valid?
      dataset_data.errors.each{|k,v| self.errors.add( k,v ) }
      return false
    end
    true
  end
  
  def source_code_should_exist!
    if source_code.present?
      Source.cached[source_code] = Source.find(source_code) unless Source.cached.has_key?(source_code)
      source = Source.cached[source_code]
      self.errors.add( :source_code, "Could not find a source with the source_code '#{source_code}'" ) if source.blank? || source.code.blank?
      return false
    end
    true 
  end
  
  def ambiguous_code_requires_source_code!
    if code.to_s.numeric? && source_code.blank?
      message = %Q{Pure numerical codes like "#{code}" are not allowed unless you include a source code. Do this:\nsource_code: <USERNAME>\ncode: #{code}}
      self.errors.add( :data, message )
      return false
    end
    true 
  end
  
  def data_columns_should_not_exceed_column_names!
    if errors.size == 0 && data? && data.present? && column_names.present? && data.first.count != column_names.count
      self.errors.add( :data, "You may not change the number of columns in a dataset. This dataset has #{column_names.count} columns but you tried to send #{data.first.count} columns." )
      return false
    end
    true 
  end
  
  def data_rows_should_have_equal_columns!
    # skip validation unless data is present
    return true unless data? && data.present?
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
    return true unless data? && data.present? && column_names.present?
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
    return if !data? || data.blank?
    
    dataset_data.id = id
    dataset_data.data = data.to_csv
    dataset_data.save
    # update dataset's attributes with dataset_data's attributes
    attributes.each{|k,v| attributes[k] = dataset_data.attributes[k] if dataset_data.attributes.has_key?(k) }
    # update dataset errors with dataset_data
    @metadata[:status] = dataset_data.status unless dataset_data.saved?
    # inherit_errors(dataset_data) unless dataset_data.saved?
  end
  
  def inherit_errors(object)
    return unless object.respond_to?(:response_errors) && object.response_errors.respond_to?(:each)
    object.response_errors.each do |key, messages|
      if messages.respond_to?(:each)
        messages.each{|message| errors.add(key, message) }
      end
    end
    @metadata[:status] = object.status
    object
  end
  
  def enforce_required_formats
    # self.data = Quandl::Data.new(data).to_csv
    self.source_code = self.source_code.to_s.upcase
    self.code = self.code.to_s.upcase
    self.locations_attributes = locations_attributes.to_json if locations_attributes.respond_to?(:to_json) && !locations_attributes.kind_of?(String)
  end
  
end