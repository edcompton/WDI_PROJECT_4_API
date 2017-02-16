Rails.application.routes.draw do
  # setting routes with form shown below
  # VERB(URL, to: CONTROLLER#METHOD)
  post 'authentications/register', to: "authentications#register"
  post 'authentications/login', to: "authentications#login"
end
