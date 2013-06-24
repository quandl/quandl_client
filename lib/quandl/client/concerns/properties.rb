module Quandl
module Client
module Concerns
  
module Properties
  extend ActiveSupport::Concern

  included do

    include Her::Model
    use_api Client.her_api
  
    before_save :halt_unless_valid!
    
    def valid_with_server?
      r = valid_without_server?
      r = self.attributes[:errors].blank? if r == true
      r
    end
    alias_method_chain :valid?, :server
    
    def error_messages
      valid?
      m = errors.messages || {}
      e = self.attributes[:errors] || {}
      m.deep_merge(e)
    end
    
    protected
  
    def halt_unless_valid!
      return false unless valid?
    end
    
  end      
end

end
end
end
