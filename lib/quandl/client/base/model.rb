class Quandl::Client::Base
  module Model

    extend ActiveSupport::Concern

    included do

      include Her::Model
      use_api Quandl::Client::Base.her_api

      before_save :touch_request_started_at
      after_save :touch_request_finished_at

      before_destroy :touch_request_started_at
      after_destroy :touch_request_finished_at

      attr_accessor :request_started_at, :request_finished_at

    end

    def elapsed_request_time_ms
      elapsed_request_time.to_f.microseconds.to_s + 'ms'
    end

    def elapsed_request_time
      return nil unless request_finished_at.is_a?(Time) && request_started_at.is_a?(Time)
      @elapsed_request_time ||= (request_finished_at - request_started_at)
    end

    private

    def touch_request_started_at
      self.request_started_at = Time.now
    end

    def touch_request_finished_at
      self.request_finished_at = Time.now
    end

  end
end