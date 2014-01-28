class Quandl::Client::User < Quandl::Client::Base
  
  custom_get :info
  custom_post :login
  
  attributes :auth_token
  
end