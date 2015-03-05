require "active_support"
require "active_support/inflector"
require "active_support/core_ext/hash"
require "active_support/core_ext/object"

require 'quandl/client/base/model'
require 'quandl/client/base/benchmark'
require 'quandl/client/base/attributes'
require 'quandl/client/base/validation'
require 'quandl/client/base/search'

I18n.enforce_available_locales = false

module Quandl
  module Client
    class Base
      TOKEN_THREAD_KEY = 'quandl_client_token'

      class << self
        attr_accessor :url, :token

        def threadsafe_token!
          @threadsafe_token = true
        end

        def threadsafe_token?
          @threadsafe_token || false
        end

        def use(url)
          self.url = url
          models_use_her_api!
        end

        def token=(token)
          if threadsafe_token?
            Thread.current[TOKEN_THREAD_KEY] = token
          else
            @token = token
          end
          models_use_her_api!
        end

        def token
          if threadsafe_token?
            Thread.current[TOKEN_THREAD_KEY]
          else
            @token
          end
        end

        def her_api
          Her::API.new.setup url: url_with_version do |c|
            c.use TokenAuthentication
            c.use TrackRequestSource
            c.use Faraday::Request::Multipart
            c.use Faraday::Request::UrlEncoded
            c.use Quandl::Client::Middleware::ParseJSON
            c.use Faraday::Adapter::NetHttp
          end
        end

        def url
          @url ||= "https://www.quandl.com/api/"
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
            include Quandl::Client::Base::Benchmark
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
          models.each  do |m|
            m.url = url_with_version
            m.use_api(her_api)
          end
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
            env[:body][:request_platform] = Quandl::Client.request_platform
            @app.call(env)
          end
        end
      end
    end
  end
end