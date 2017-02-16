Rails.application.routes.draw do
  # setting routes with form shown below
  # VERB(URL, to: CONTROLLER#METHOD)
  post 'register', to: "authentications#register"
  post 'login', to: "authentications#login"
end
