module Quandl
  module Client
    class Sheet < Quandl::Client::Base

      ##########
      # SCOPES #
      ##########

      scope :query, :page, :parent_url_title


      ################
      # ASSOCIATIONS #
      ################

      def parent
        @parent ||= Quandl::Client::Sheet.find(parent_url_title)
      end

      def children
        Quandl::Client::Sheet.parent_url_title(self.full_url_title)
      end


      ###############
      # VALIDATIONS #
      ###############

      validates :title, presence: true


      ##############
      # PROPERTIES #
      ##############

      attributes :title, :content, :url_title, :full_url_title, :description, :skip_browse, :redirect_path

      def html
        @html ||= self.attributes[:html] || Quandl::Client::Sheet.find(full_url_title).attributes[:html]
      end

      def parent_url_title
        @parent_url_title ||= self.full_url_title.split('/')[0..-2].join()
      end


    end
  end
end