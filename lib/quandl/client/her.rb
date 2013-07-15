require 'her'
require 'quandl/her/patch'

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
        # c.use Her::Middleware::DefaultParseJSON
        c.use Quandl::Client::Middleware::ParseJSON
        c.use Faraday::Adapter::NetHttp
      end
    end

    def rest_url
      @rest_url ||= "http://localhost:3000/api/#{API_VERSION}/"
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
    
    class TokenAuthentication < Faraday::Middleware
      def call(env)
        env[:request_headers]["X-API-Token"] = Quandl::Client.token if Quandl::Client.token.present?
        @app.call(env)
      end
    end
    
  end 
end
end