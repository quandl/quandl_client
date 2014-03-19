class Quandl::Client::Superset < Quandl::Client::Base
  
  scope :query, :page, :owner, :code, :source_code
  
  attributes :id, :source_code, :code, :name, :urlize_name, :description, :updated_at, :private
  attributes :column_codes, :column_names
  attributes :frequency, :from_date, :to_date
  
end