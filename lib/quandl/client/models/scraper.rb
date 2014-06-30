module Quandl
  module Client
    class Scraper < Quandl::Client::Base

      has_many :jobs

      attributes  :id, :name, :scraper, :scraper_url, :git_url, :git_reference, :created_at, :updated_at,
                  :type, :schedule_at, :schedule_run_time, :schedule_next

      validates :name, presence: true

      def scraper=(value)
        write_attribute(:scraper, Faraday::UploadIO.new(value, 'text/plain') )
      end

      def run_now
        jobs.create
      end
    end
  end
end