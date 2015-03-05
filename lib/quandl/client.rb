require "quandl/client/version"

require 'scope_composer'
require 'her'
require 'quandl/her/remove_method_data'
require 'quandl/her/collection'
require 'quandl/logger'
require "quandl/data"

require 'quandl/pattern'
require 'quandl/pattern/client'

require 'quandl/client/middleware'
require 'quandl/client/base'
require 'quandl/client/models/dataset'
require 'quandl/client/models/sheet'
require 'quandl/client/models/source'
require 'quandl/client/models/user'
require 'quandl/client/models/location'
require 'quandl/client/models/scraper'
require 'quandl/client/models/job'
require 'quandl/client/models/report'
require 'quandl/client/models/superset'

module Quandl
  module Client
    class << self
      attr_accessor :request_source, :request_version, :request_platform

      def request_source
        @request_source ||= "quandl_client"
      end

      def request_version
        @request_version ||= Quandl::Client::VERSION
      end

      def request_platform
        @request_platform ||= RUBY_PLATFORM
      end

    end

    def self.threadsafe_token!
      Quandl::Client::Base.threadsafe_token!
    end

    def self.use(url)
      Quandl::Client::Base.use(url)
    end

    def self.token=(value)
      Quandl::Client::Base.token = value
    end

    HTTP_STATUS_CODES = {100=>"Continue", 101=>"Switching Protocols", 102=>"Processing", 200=>"OK", 201=>"Created", 202=>"Accepted", 203=>"Non-Authoritative Information", 204=>"No Content", 205=>"Reset Content", 206=>"Partial Content", 207=>"Multi-Status", 208=>"Already Reported", 226=>"IM Used", 300=>"Multiple Choices", 301=>"Moved Permanently", 302=>"Found", 303=>"See Other", 304=>"Not Modified", 305=>"Use Proxy", 306=>"Reserved", 307=>"Temporary Redirect", 308=>"Permanent Redirect", 400=>"Bad Request", 401=>"Unauthorized", 402=>"Payment Required", 403=>"Forbidden", 404=>"Not Found", 405=>"Method Not Allowed", 406=>"Not Acceptable", 407=>"Proxy Authentication Required", 408=>"Request Timeout", 409=>"Conflict", 410=>"Gone", 411=>"Length Required", 412=>"Precondition Failed", 413=>"Request Entity Too Large", 414=>"Request-URI Too Long", 415=>"Unsupported Media Type", 416=>"Requested Range Not Satisfiable", 417=>"Expectation Failed", 422=>"Unprocessable Entity", 423=>"Locked", 424=>"Failed Dependency", 425=>"Reserved for WebDAV advanced collections expired proposal", 426=>"Upgrade Required", 427=>"Unassigned", 428=>"Precondition Required", 429=>"Too Many Requests", 430=>"Unassigned", 431=>"Request Header Fields Too Large", 500=>"Internal Server Error", 501=>"Not Implemented", 502=>"Bad Gateway", 503=>"Service Unavailable", 504=>"Gateway Timeout", 505=>"HTTP Version Not Supported", 506=>"Variant Also Negotiates (Experimental)", 507=>"Insufficient Storage", 508=>"Loop Detected", 509=>"Unassigned", 510=>"Not Extended", 511=>"Network Authentication Required"}

  end
end