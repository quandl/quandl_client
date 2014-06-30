class Quandl::Client::Base
  module Validation

    extend ActiveSupport::Concern

    included do

      before_save :halt_unless_valid!

      after_save :apply_response_errors

      def apply_response_errors
        return unless response_errors.respond_to?(:each)
        response_errors.each do |key, messages|
          if messages.respond_to?(:each) && @errors.respond_to?(:add)
            messages.each{|message| @errors.add(key.to_sym, message) unless @errors.has_key?(key.to_sym) }
          end
        end
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
        return 'Deleted' if metadata[:method] == :delete && status == 200
        return 'Updated' if metadata[:method] == :put && status == 200
        Quandl::Client::HTTP_STATUS_CODES[status]
      end

      def status
        metadata[:status].to_i
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

      def error_messages
        valid?
        errors.messages
      end

      def errors
        apply_response_errors
        super
      end

      def human_error_message(name, message)
        message = message.join(', ') if message.respond_to?(:join)
        "    #{name}: #{message}\n"
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