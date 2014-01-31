require "active_support"
require "active_support/inflector"
require "active_support/core_ext/hash"
require "active_support/core_ext/object"

require 'quandl/client/base/model'
require 'quandl/client/base/attributes'
require 'quandl/client/base/validation'
require 'quandl/client/base/search'

I18n.enforce_available_locales = false

class Quandl::Client::Base
  
  class << self
    
    attr_accessor :url, :token
  
    def use(url)
      self.url = url
      models_use_her_api!
    end
    
    def token=(token)
      @token = token
      models_use_her_api!
    end
    
    def her_api
      Her::API.new.setup url: url_with_version do |c|
        c.use TokenAuthentication
        c.use TrackRequestSource
        c.use Faraday::Request::UrlEncoded
        c.use Quandl::Client::Middleware::ParseJSON
        c.use Faraday::Adapter::NetHttp
      end
    end

    def url
      @url ||= "http://quandl.com/api/"
    end

    def url_with_version
      File.join( url.to_s, Quandl::Client.api_version.to_s )
    end
    
    def inherited(subclass)
      # remember models that inherit from base
      models << subclass unless models.include?(subclass)
      # include model behaviour
      subclass.class_eval do
        include Quandl::Client::Base::Model
        include Quandl::Client::Base::Attributes
        include Quandl::Client::Base::Validation
        include Quandl::Client::Base::Search
      end
    end
    
    def models
      @@models ||= []
    end
    
    protected
    
    def models_use_her_api!
      models.each{|m|
        m.url = url_with_version
        m.use_api( her_api ) 
      }
    end
    
    class TokenAuthentication < Faraday::Middleware
      def call(env)
        env[:request_headers]["X-API-Token"] = Quandl::Client::Base.token if Quandl::Client::Base.token.present?
        @app.call(env)
      end
    end
    
    class TrackRequestSource < Faraday::Middleware
      def call(env)
        env[:body] ||= {}
        env[:body][:request_source] = Quandl::Client.request_source
        env[:body][:request_version] = Quandl::Client.request_version
        @app.call(env)
      end
    end
    
  end
  
end