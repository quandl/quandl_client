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
      errors_client.deep_merge(errors_server).deep_merge(errors_params)
    end
    
    def errors_client
      errors.messages || {}
    end
    
    def errors_server
      self.attributes[:errors] || {}
    end
    
    def errors_params
      response_errors.present? ? { response_errors: response_errors } : {}
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
