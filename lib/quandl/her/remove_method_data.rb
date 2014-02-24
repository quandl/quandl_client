module Her
  module Model
    # remove deprecated data method since cassinatra returns data: []
    module DeprecatedMethods
      remove_method( :data ) if method_defined?( :data )
      remove_method( :data= ) if method_defined?( :data= )
    end
  end
end