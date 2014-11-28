module Quandl
  module Client
    class Source < Quandl::Client::Base

      class << self

        def cached
          @@cached ||= {}
        end

      end

      ##########
      # SCOPES #
      ##########

      scope :query
      scope :page, ->(p){ where( page: p.to_i )}
      scope :code, ->(c){ where( code: c.to_s.upcase )}


      ###############
      # ASSOCIATIONS #
      ###############

      def datasets
        Quandl::Client::Dataset.source_code(code)
      end


      ###############
      # VALIDATIONS #
      ###############

      validates :code, presence: true, length: { minimum: 2 }, format: { with: Quandl::Pattern.code, message: "is invalid. Expected format: #{Quandl::Pattern.code.to_example}" }
      validates :host, :name, presence: true


      ##############
      # PROPERTIES #
      ##############

      attributes :code, :name, :host, :description, :datasets_count, :use_proxy, :type, :concurrency, :documentation

    end
  end
end