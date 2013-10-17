require "quandl/client/version"

require "active_support"
require "active_support/inflector"
require "active_support/core_ext/hash"
require "active_support/core_ext/object"

require 'quandl/client/middleware'
require 'quandl/client/her'
require 'quandl/client/concerns'
require 'quandl/client/base'
require 'quandl/client/models'

module Quandl
  module Client
    def self.use(url)
      Quandl::Client::Base.use(url)
    end
  end
end