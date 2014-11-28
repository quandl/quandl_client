class Quandl::Client::Dataset::Data < Quandl::Client::Base
  
  @_her_resource_path = "datasets/:id/data"
  
  has_scope_composer
  
  scope.class_eval do
    delegate *Quandl::Client::Dataset::Data.forwardable_scope_methods, :to_h, to: :to_table, allow_nil: true
    delegate *Quandl::Data.forwardable_methods, to: :to_table, allow_nil: true
  end
  
  scope *[:row, :rows, :limit, :offset, :accuracy, :column, :order, 
    :transformation, :collapse, :exclude_headers]

  scope :trim_start,  ->(date){ date = parse_date(date); where( trim_start: date ) if date }
  scope :trim_end,    ->(date){ date = parse_date(date); where( trim_end:   date ) if date }
  
  scope_helper :parse_date, ->( value ){ 
    begin
      date = Date.jd(value.to_i) if value.kind_of?(String) && value.numeric?
      date = Date.jd(value) if value.is_a?(Integer)
      date = Date.parse(value) if value.is_a?(String) && value =~ /^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/
      date = value if value.is_a?(Date)
      date = value.to_date if value.respond_to?(:to_date)
      date.to_s
    rescue
      nil
    end
  }
  
  scope_helper :to_table, -> { 
    data = fetch_once.data
    data.headers = fetch_once.column_names
    data
  }

  attributes :id, :limit, :collapse, :transformation, :trim_start, :trim_end, 
    :rows, :row, :frequency, :data, :from_date, :to_date, :column_names

  def data
    read_data
  end

  def data=(value)
    write_data(value)
  end

  protected

  def read_data
    Quandl::Data.new( read_attribute(:data) )
  end

  def write_data(value )
    write_attribute(:data, Quandl::Data.new(value).to_csv )
  end
  
end