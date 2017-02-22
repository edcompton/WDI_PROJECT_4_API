Rails.application.routes.draw do
  get 'companies', to: "companies#index"

  get 'users/:id', to: "users#show"

  get 'companies/:id', to: "companies#show"

  # setting routes with form shown below
  # VERB(URL, to: CONTROLLER#METHOD)
  post 'register', to: "authentications#register"
  post 'login', to: "authentications#login"
  post 'watchlistfeed', to: "newsfeeds#watchlist_feed"
  post 'filingfeed', to: "rssfilings#filing_feed"
  post 'historicalprices', to: "historicalprices#historical_prices"
end
