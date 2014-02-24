require "quandl/client/version"

require 'scope_composer'
require 'her'
require 'quandl/her/remove_method_data'
require 'quandl/logger'
require "quandl/data"

require 'quandl/client/middleware'
require 'quandl/client/base'
require 'quandl/client/models/dataset'
require 'quandl/client/models/sheet'
require 'quandl/client/models/source'
require 'quandl/client/models/user'
require 'quandl/client/models/location'
require 'quandl/client/models/scraper'

module Quandl
  module Client
    def self.use(url)
      Quandl::Client::Base.use(url)
    end
    def self.token=(value)
      Quandl::Client::Base.token = value
    end
    
  end
end