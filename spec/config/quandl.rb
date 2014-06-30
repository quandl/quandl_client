require 'ostruct'
require 'yaml'

module Spec
  module Config
    Quandl = OpenStruct.new(YAML.load(File.read(File.join(ENV['HOME'], '.quandl/test'))))
  end
end

require "quandl/client"
require "quandl/fabricate"

include Quandl::Client

Quandl::Client.token = Spec::Config::Quandl.token
Quandl::Client.use(Spec::Config::Quandl.quandl_url)
