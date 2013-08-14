module Quandl
module Client
module Concerns
  
module Properties
  extend ActiveSupport::Concern

  included do

    include Her::Model
    use_api Client.her_api
  
    before_save :touch_save_time
    after_save :log_save_time
    
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
      status >= 201 && status <= 206
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
      messages[:message] = self.error if self.error.present?
      messages
    end
    
    def errors_params
      response_errors.present? ? { response_errors: response_errors } : {}
    end
    
    
    protected
  
    def halt_unless_valid!
      return false unless valid?
    end
    
    private
    
    def save_timer
      @save_timer
    end
    
    def touch_save_time
      @save_timer = Time.now
    end
    
    def log_save_time
      Quandl::Logger.info("#{self.class.name}.save (#{save_timer.elapsed_ms})")
    end
    
  end      
end

end
end
end
