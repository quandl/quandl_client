module Quandl
module Client
  class << self
    
    def use(url)
      self.rest_url = url
    end
    
    def token
      @token
    end    
    def token=(token)
      @token = token
      reload_models
    end
    
    def her_api
      # setup api
      api = Her::API.new
      api.setup url: rest_url do |c|
        c.use TokenAuthentication
        c.use Faraday::Request::UrlEncoded
        c.use Parser
        c.use Faraday::Adapter::NetHttp
      end
    end

    def rest_url
      @rest_url ||= 'http://www.quandl.com/api/'
    end
    
    def rest_url=(url)
      url = "http://#{url}" if ( url =~ /^http:\/\// ) == nil
      url = File.join(url, "#{API_VERSION}/")
      @rest_url = url
      reload_models
      @rest_url
    end
    
    def reload_models
      Models.use_api( her_api )
    end
    
    class Parser < Faraday::Response::Middleware
      def on_complete(env)
        json = MultiJson.load(env[:body], symbolize_keys: true)
        errors = []
        if json.is_a?(Hash) && json.has_key?(:docs)
          errors = [json.delete(:error)]
          data = json.delete(:docs)
          metadata = json
        else
          errors = [json.delete(:error)] if json.is_a?(Hash) && json.has_key?(:error)
          data = json.present? ? json : {}
          metadata = {}
        end
        env[:body] = {
          data: data,
          errors: errors,
          metadata: metadata
        }
      end
    end
    
    class TokenAuthentication < Faraday::Middleware
      def call(env)
        env[:request_headers]["X-API-Token"] = Quandl::Client.token if Quandl::Client.token.present?
        @app.call(env)
      end
    end
    
  end 
end
end