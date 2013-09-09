module Quandl
module Client

class Sheet
  
  include Concerns::Search
  include Concerns::Properties
  
  
  ##########  
  # SCOPES #
  ##########
  
  search_scope :query, :page, :parent_url_title
  
  
  ################
  # ASSOCIATIONS #
  ################
  
  def parent
    @parent ||= Sheet.find(parent_url_title)
  end
  
  def children
    Sheet.parent_url_title(self.full_url_title)
  end
  
  
  ###############
  # VALIDATIONS #
  ###############
  
  validates :title, presence: true
  

  ##############
  # PROPERTIES #
  ##############
  
  attributes :title, :content, :url_title, :full_url_title, :description
  
  def html
    @html ||= self.attributes[:html] || Sheet.find(full_url_title).attributes[:html]
  end
  
  def parent_url_title
    @parent_url_title ||= self.full_url_title.split('/')[0..-2].join()
  end
  
  
end

end
end