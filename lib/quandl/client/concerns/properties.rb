module Quandl
module Client
module Concerns
  
module Properties
  extend ActiveSupport::Concern

  included do

    include Her::Model
    use_api Client.her_api
  
    before_save :halt_unless_valid!
    
    def error_messages
      valid?
      m = errors.messages.to_h || {}
      e = self.attributes[:errors].to_h || {}
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
