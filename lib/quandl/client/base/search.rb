module Quandl
module Client
module Concerns
  
module Search
  extend ActiveSupport::Concern

  included do

    include ScopeComposer::Model
  
    scope_composer_for :search

    search_helper :all, ->{ connection.where(attributes).fetch }
    search_helper :connection, -> { self.class.parent }

    search_scope.class_eval do
      delegate *Array.forwardable_methods, to: :all
    end

  end      
end

end
end
end
