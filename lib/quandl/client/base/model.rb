class Quandl::Client::Base
module Model
  
  extend ActiveSupport::Concern

  included do

    include Her::Model
    use_api Quandl::Client::Base.her_api
    
  end
  
end
end