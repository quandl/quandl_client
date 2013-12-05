class Quandl::Client::User < Quandl::Client::Base
  
  custom_post :login
  
  attributes :auth_token
  
end