class Quandl::Client::Base
  module Attributes

    extend ActiveSupport::Concern

    def write_attribute(attribute, value)
      self.send(:"#{attribute}_will_change!") if @attributes[:"#{attribute}"] != value
      @attributes[:"#{attribute}"] = value
    end

    def read_attribute(attribute)
      @attributes[:"#{attribute}"]
    end

  end
end