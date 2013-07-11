require 'yajl'

module Her
  module Model
    # remove deprecated data method since cassinatra returns data: []
    module DeprecatedMethods
      remove_method :data
      remove_method :data=
    end
  end
end