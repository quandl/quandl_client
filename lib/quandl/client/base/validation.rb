class Quandl::Client::Base
module Validation
  
  extend ActiveSupport::Concern

  included do
  
    before_save :halt_unless_valid!
    
    validate :response_errors_should_be_blank!
    
    def response_errors_should_be_blank!
      return unless response_errors.respond_to?(:each)
      response_errors.each do |key, messages|
        if messages.respond_to?(:each)
          messages.each{|message| errors.add(key, message) }
        end
      end
      true
    end
    
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
    
    def human_status
      Quandl::Client::HTTP_STATUS_CODES[status]
    end
    
    def status
      metadata[:status].to_i
    end
    
    def parse_error
      error_messages[:response_errors].try( :[], :parse_error )
    end
  
    def human_error_messages
      return if errors.blank?
      m = "#{status}\n"
      m += "  errors: \n"
      m += error_messages.collect do |error_type, messages|
        next human_error_message(error_type, messages)  unless messages.is_a?(Hash)
        messages.collect{|n,m| human_error_message(n, m) }
      end.flatten.compact.join
    end
  
    def human_error_message(name, message)
      message = message.join(', ') if message.respond_to?(:join)
      "    #{name}: #{message}\n"
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
    
    class UrlValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        begin
          uri = URI.parse(value)
          resp = uri.kind_of?(URI::HTTP)
          
        rescue URI::InvalidURIError
          resp = false
        end
        unless resp == true
          record.errors[attribute] << (options[:message] || "is not an url")
        end
      end
    end
     
  end
end
end