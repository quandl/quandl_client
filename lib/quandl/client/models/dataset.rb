class Quandl::Client::Dataset < Quandl::Client::Base
  
  require 'quandl/client/models/dataset/data'
  require 'quandl/client/models/dataset/validations'
  require 'quandl/client/models/dataset/benchmark'
  
  include Quandl::Client::Dataset::Validations
  include Quandl::Client::Dataset::Benchmark
  
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
  
  ##############
  # PROPERTIES #
  ##############
  
  attributes :source_code, :code, :name, :urlize_name, 
    :description, :updated_at, :frequency,
    :from_date, :to_date, :column_names, :private, :type,
    :display_url, :column_spec, :import_spec, :import_url,
    :locations_attributes, :availability_delay, :refreshed_at, :access
    
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
    File.join(Quandl::Client::Base.url.gsub(/api\/?/, ''), full_code)
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
  
  def code=(v)
    write_attribute(:code, sanitize_code(v) )
  end
  
  def source_code=(v)
    write_attribute(:source_code, sanitize_code(v) )
  end
  
  def sanitize_code(code)
    code.to_s.upcase.gsub(',','')
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
  
end