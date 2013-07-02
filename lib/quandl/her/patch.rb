module Her
  module Model
    # remove deprecated data method since cassinatra returns data: []
    module DeprecatedMethods
      remove_method :data
      remove_method :data=
    end
  end
  module Middleware
    class ParseJSON < Faraday::Response::Middleware
      # @private
      def parse_json(body = nil)
        body ||= '{}'
        message = "Response from the API must behave like a Hash or an Array (last JSON response was #{body.inspect})"

        json = begin
          Yajl.load(body, :symbolize_keys => true)
        rescue MultiJson::LoadError
          raise Her::Errors::ParseError, message
        end

        raise Her::Errors::ParseError, message unless json.is_a?(Hash) or json.is_a?(Array)

        json
      end
    end
  end
end