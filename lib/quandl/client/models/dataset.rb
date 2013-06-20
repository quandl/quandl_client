require 'quandl/client/models/dataset/searchable'
require 'quandl/client/models/dataset/properties'

module Quandl
module Client

class Dataset
  
  include Properties
  include Searchable
  
  def source
    @source ||= Source.find(self.source_code)
  end
  
end

end
end