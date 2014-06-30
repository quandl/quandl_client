module Quandl
  module Client
    VERSION = File.read(File.expand_path(File.join(File.dirname(__FILE__), '../../../VERSION'))).strip.rstrip
    API_VERSION = 'v2'

    class << self

      def api_version
        API_VERSION
      end

    end

  end
end