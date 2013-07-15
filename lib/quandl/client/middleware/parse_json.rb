module Quandl
module Client
module Middleware

class ParseJSON < Faraday::Response::Middleware

  def on_complete(env)
    env[:body] = case env[:status]
    when 204
      parse('{}', env)
    else
      parse(env[:body], env)
    end
  end

  def parse(body, env)
    json = parse_json(body)
    errors = json.delete(:errors) || {}
    metadata = json.delete(:metadata) || {}
    # collect some response data
    metadata.merge!({
      status:                 env[:status],
      headers:                env[:response_headers],
      })
    # return object
    object = {
      :data => json,
      :errors => errors,
      :metadata => metadata
    }
    env[:status] = 200
    object
  end

  def parse_json(body = nil)
    body ||= '{}'
    message = "Response from the API must behave like a Hash or an Array (last JSON response was #{body.inspect})"

    json = begin
      Yajl.load(body, :symbolize_keys => true)
    rescue Yajl::ParseError
      { id: 1, errors: { parse_error: message } }
      
      # raise Her::Errors::ParseError, message
    end
    # raise Her::Errors::ParseError, message unless json.is_a?(Hash) or json.is_a?(Array)

    json
  end

end

end
end
end