require 'quandl/client/models/source'
require 'quandl/client/models/dataset'
require 'quandl/client/models/sheet'

module Quandl
  module Client
    module Models
      class << self
        
        def use_api(api)
          each{|k| k.use_api(api) }
        end
        
        def each(&block)
          types.each{|k| block.call(k) }
        end
        
        def types
          [Source, Dataset, Sheet]
        end
        
      end
    end
  end
end