require 'ostruct'
require 'yaml'

module Spec
module Config
  Quandl = OpenStruct.new(YAML.load(File.read(File.join(ENV['HOME'], '.quandl/test'))))
end
end
