class Quandl::Client::Dataset::Data < Quandl::Client::Base
  
  has_scope_composer
  scope :rows, :exclude_headers, :trim_start, :trim_end, :transform, :collapse
  
end