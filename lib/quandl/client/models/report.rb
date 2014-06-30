module Quandl
  module Client
    class Report < Quandl::Client::Base

      ###############
      # VALIDATIONS #
      ###############

      validates :message, presence: true

    end
  end
end