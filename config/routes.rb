Rails.application.routes.draw do
  # get 'companies', to: "companies#index"
  #
  # get 'companies/:id', to: "companies#show"

  get 'companies/model', to: "companies#model_show"

  post 'register', to: "authentications#register"
  post 'login', to: "authentications#login"
  post 'watchlistfeed', to: "newsfeeds#watchlist_feed"
  post 'filingfeed', to: "rssfilings#filing_feed"
  post 'historicalprices', to: "historicalprices#historical_prices"
end
