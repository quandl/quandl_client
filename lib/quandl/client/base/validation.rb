class Quandl::Client::Base
module Validation
  
  extend ActiveSupport::Concern

  included do
  
    before_save :halt_unless_valid!
    
    def valid_with_server?
      return false unless valid?
      return false unless errors_params.blank?
      return false unless errors_server.blank?
      true
    end
    
    def save!
      save
    end
    
    def blank?
      !present?
    end
    
    def exists?
      present?
    end
    
    def present?
      status >= 200 && status < 300
    end
    
    def saved?
      status >= 200 && status <= 210
    end
    
    def queried?
      status > 0
    end
    
    def status
      metadata[:status].to_i
    end
    
    def parse_error
      error_messages[:response_errors].try( :[], :parse_error )
    end
    
    def error_messages
      valid?
      errors_client.deep_merge(errors_server).deep_merge(errors_params)
    end
    
    def errors_client
      errors.messages || {}
    end
    
    def errors_server
      messages = self.attributes[:errors] || {}
      messages[:message] = self.error if self.respond_to?(:error) && self.error.present?
      messages
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