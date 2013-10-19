class Quandl::Client::Dataset::Data < Quandl::Client::Base
  
  @_her_resource_path = "datasets/:id/data"
  
  has_scope_composer
  
  scope *[:row, :rows, :limit, :offset, :accuracy, :column, :order, 
    :trim_start, :trim_end, :transform, :collapse, :exclude_headers]
  
  scope_helper :to_table, -> { fetch_once.data }
  
  scope.class_eval do
    delegate *Quandl::Client::Dataset::Data.forwardable_scope_methods, :to_h, to: :to_table, allow_nil: true
    delegate *Quandl::Data::Table.forwardable_methods, to: :to_table, allow_nil: true
  end
    
  attributes :id, :limit, :collapse, :transformation, :trim_start, :trim_end, 
    :rows, :row, :frequency, :data, :from_date, :to_date

  def data
    read_data
  end
  
  def data=(value)
    write_data(value)
  end
  
  protected
  
  def read_data
    Quandl::Data::Table.new( read_attribute(:data) )
  end
  
  def write_data(value )
    write_attribute(:data, Quandl::Data::Table.new(value).to_csv )
  end
  
end